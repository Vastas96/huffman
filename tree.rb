require 'pqueue'

class Huffman
  class Tree
    attr_accessor :root
    attr_accessor :encoded_tree
    attr_accessor :size

    def initialize(frequencies, size = 1)
      @size = size
      nodes = PQueue.new { |a, b| a.value < b.value }

      frequencies.map { |key, value| nodes.push Node.new(value, key) }

      while nodes.length != 1
        first = nodes.pop
        second = nodes.pop

        parent = Node.new(first.value + second.value, nil, first, second)

        nodes.push(parent)
      end

      @root = nodes.pop

      root.set_binary_values
    end

    def dictionnary
      dictionnary = []
      root.visit { |node| dictionnary << [node.binary_value, node.symbol] if node.symbol }
      dictionnary.to_h
    end

    def symbol_to_integer(symbol)
      size = symbol.size

      symbol.each_char.each_with_index.map {|c, index| c.ord << 8 * (size - index - 1)}
    end

    def shift(n = 1)
      value = encoded_tree[0..n]
      encoded_tree = encoded_tree[n..-1]
      value
    end

    def encoded_dictionnary
      dictionnary = ''
      root.visit do |node|
        if node.symbol
          dictionnary += [1, node.symbol.ljust(size, '0')].join
        else
          dictionnary += '0'
        end
      end
      dictionnary
    end

    def encoded_dictionnary_test
      dictionnary = ''
      root.visit do |node|
        if node.symbol
          dictionnary += [1, node.symbol].join
        else
          dictionnary += '0'
        end
      end
      dictionnary
    end
  end
end
