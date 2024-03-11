module DotErd::Entities
  class Enum do
    
    def initialize(**attrs) do
      @schema = attrs[:schema]
      @enum = attrs[:enum]
      @values = attrs[:values]
    end
    
    def self.parse(content)
      regex = Regexp.new(
        "CREATE TYPE (?<schema>[^\.]+)\.(?<enum>[^\s]+) AS ENUM \(\s+
        (?<values>[^\)]+)\s+
        \);",
        Regexp::MULTILINE
      )

      content.scan(regex).map do |match|
        match.transform_keys!(&:to_sym)
        values = match[:values].split(',').map { |v| v.gsub(/'/, '').strip }
        match[:values]  = values
        self.new(match)
      end
    end

    def to_erd
      all_values = @values.map do |value|
        %Q(<tr><td align="left" port="#{value}">#{value}</td></tr>)
      end

      %Q[
        <table border="1" align="center" cellborder="0" cellpadding="2" cellspacing="2">
          <tr><td bgcolor="#f8f8f8" align="center" cellpadding="8"><font point-size="11">#{@schema}#{@enum}</font></td></tr>
          #{all_values.join("\n")}
        </table>
      ]
    end

  end
end
