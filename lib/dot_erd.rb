class DotErd
  require 'dot_erd/entities/table'
  require 'dot_erd/entities/reference'
  require 'dot_erd/graphviz/digraph'

  def self.process(content)
    dot_content = DotErd::Graphviz::Digraph.wrapper do |block|
      [
        DotErd::Entities::Table.parse(content),
        DotErd::Entities::Reference.parse(content)
      ].flatten.map(&:to_erd).join()
    end

    puts dot_content
  end

end
