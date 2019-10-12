class Huffman
  class EncodedTree
    attr_accessor :root
    attr_accessor :encoded_tree

    def initialize(encoded_tree, size)
      @encoded_tree = encoded_tree
      @root = Node.build_from_tree(self, size)
      root.set_binary_values
    end

    def dictionnary
      dictionnary = []
      root.visit { |node| dictionnary << [node.binary_value, node.symbol] if node.symbol }
      dictionnary.to_h
    end

    def symbol_to_integer(symbol)
      size = symbol.size

      symbol.each_char.each_with_index.map {|c, index| c.ord << size - index - 1}
    end

    def tree_constructed?
      constructed = true
      root.visit { |node|  }
      constructed
    end

    def shift(n = 1)
      return '' if @encoded_tree.nil?
      value = @encoded_tree[0...n]
      @encoded_tree = @encoded_tree[n..-1]
      value.to_s
    end

    def encoded_dictionnary
      dictionnary = ''
      root.visit do |node|
        if node.symbol
          dictionnary += [1, symbol_to_integer(node.symbol).reduce(&:+).to_s(2)].join
        else
          dictionnary += '0'
        end
      end
      dictionnary
    end
  end
end
