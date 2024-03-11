module DotErd::Entities
  class Table

    @@pattern = /
      CREATE\ TABLE\s+
      (?<schema>[^\.]+)\.(?<table>[^\s]+)\s+
      \(\s+(?<columns>[^;]+)\s+\);
      /x

    # String.scan doesn't return named captures ??
    @@keys = %i(schema table columns)

    def self.parse(content)
      content.scan(@@pattern).map do |match|
        results = Hash[@@keys.zip(match)]

        columns = results[:columns].split(',').map do |column|
          column.strip!
          content = column.split(' ')
          type = content[1..-1].
            join(' ').
            gsub("NOT NULL", '').
            gsub(/DEFAULT [^\s]+/, '').
            gsub("without time zone", '').
            gsub("public.", '').
            gsub("_type_enum", '_enum').
            strip!
          {name: content[0].gsub(/"/, ''), type: type}
        end

        results[:columns] = columns
        new(results)
      end
    end

    def initialize(attrs)
      @schema = attrs[:schema]
      @table = attrs[:table]
      @columns = attrs[:columns]
    end

    def to_erd
      all_columns = @columns.map do |value|
        %Q(
          <tr>
            <td align="right" port="#{value[:name]}">#{value[:name]}</td>
            <td align="left">#{value[:type]}</td>
          </tr>
        ).gsub(/\s+/, ' ').gsub(/> </, '><')
      end

      %Q(
        "#{@schema}.#{@table}" [
          shape=none
          label=<
            <table border="0" cellspacing="1" cellborder="1">
              <tr><td bgcolor="#e0e0e0" colspan="2"><font point-size="14">#{@table}</font></td></tr>
              #{all_columns.join("\n             ")}
            </table>
          >
        ]
      )
    end

  end
end