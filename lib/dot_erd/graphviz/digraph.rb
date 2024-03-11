module DotErd::Graphviz
  class Digraph 

    def self.wrapper(&block)
      %Q|
        digraph EntityRelationshipDiagram {
          nodesep = 1;
          engine = fdp;
          edge [color=black]
          node [shape=none, fontname=Ariel, fontsize=10]

          #{yield(block)}
        }
      |
    end
  end
end