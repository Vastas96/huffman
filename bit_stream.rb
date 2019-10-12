class Huffman
  class BitStream
    def self.bits_from_text(text, dictionnary, size = 1)
      dictionnary = dictionnary.invert
      text.each_char.each_slice(size).to_a.map { |group| group.reduce(&:+) }.map { |c| dictionnary[c] }
    end

    def self.text_from_bits(bits, dictionnary)
      text = ''
      buffer = ''
      bits.each_char do |bit|
        buffer += bit
        if dictionnary[buffer]
          text += dictionnary[buffer]
          buffer.clear
        end
      end

      text
    end
  end
end
