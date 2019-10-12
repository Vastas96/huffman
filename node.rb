class Huffman
  class Node
    attr_accessor :value, :binary_value, :symbol, :left, :right

    def initialize(value = nil, symbol = nil, left = nil, right = nil)
      @value = value
      @symbol = symbol
      @left = left
      @right = right
      @binary_value = ''
    end

    def self.build_from_tree(tree, size = 1)
      bit = tree.shift
      if bit == '1'
        symbol = tree.shift(size)
        return Node.new(nil, symbol, nil, nil)
      elsif bit == '0'
        left = Node.build_from_tree(tree, size)
        right = Node.build_from_tree(tree, size)
        return Node.new(nil, nil, left, right)
      end
    end

    def visit(order=:preorder, &block)
      case order
      when :preorder
        yield self
        @left.visit(order, &block) if left
        @right.visit(order, &block) if right
      when :inorder
        @left.visit(order, &block) if left
        yield self
        @right.visit(order, &block) if right
      when :postorder
        @left.visit(order, &block) if left
        @right.visit(order, &block) if right
        yield self
      end
    end

    def set_binary_values()
      [right, left].each_with_index do |node, bit_value|
        if node
          node.binary_value = binary_value + bit_value.to_s
          node.set_binary_values
        end
      end
    end

    def leaf?
      !left && !right
    end
  end
end
