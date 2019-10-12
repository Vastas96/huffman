class Huffman
  class Frequency
    def self.get_frequencies(text, size = 1)
      frequencies = Hash.new(0)
      text.each_char.each_slice(size).to_a.map { |group| group.reduce(&:+) }.map { |sym| frequencies[sym] += 1 }
      frequencies
    end
  end
end
