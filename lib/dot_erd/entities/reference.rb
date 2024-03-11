module DotErd::Entities
  class Reference

    PATTERN = /
      ALTER\ TABLE\ ONLY\s+
      (?<schema>[^\.]+)\.
      (?<table>[^\s]+)\s+
      ADD\ CONSTRAINT\s+
      (?<name>[^\s]+)\s+
      FOREIGN\ KEY\s+
      \((?<column>[^\s]+)\)\s+
      REFERENCES\s+
      (?<foreign_schema>[^\.]+)\.
      (?<foreign_table>[^\()]+)
      \((?<foreign_column>[^\s]+)\)
    /x

    # String.scan doesn't return named captures ??
    KEYS = %i(schema table name column foreign_schema foreign_table foreign_column)

    def self.parse(content)
      content.scan(PATTERN).map do |match|
        results = Hash[KEYS.zip(match)]
        new(results)
      end
    end

    def initialize(attrs)
      @schema = attrs[:schema]
      @table = attrs[:table]
      @name = attrs[:name]
      @column = attrs[:column]
      @foreign_schema = attrs[:foreign_schema]
      @foreign_table = attrs[:foreign_table]
      @foreign_column = attrs[:foreign_column]
    end

    def to_erd
      %Q(    "#{@schema}.#{@table}" -> "#{@foreign_schema}.#{@foreign_table}"\n)
    end

  end
end
