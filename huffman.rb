# encoding: utf-8
require 'yaml'
require 'active_support/all'
require './frequency.rb'
require './bit_stream.rb'
require './node.rb'
require './tree.rb'
require './encoded_tree.rb'

class Huffman
  def self.encode_text(text, size)
    frequencies = Frequency.get_frequencies(text, size)
    tree = Tree.new(frequencies, size)
    dictionnary = tree.dictionnary

    encoded_text = BitStream.bits_from_text(text, dictionnary, size)
    return encoded_text, tree
  end

  def self.decode_text(encoded_text, dictionnary)
    BitStream.text_from_bits(encoded_text, dictionnary)
  end

  def self.encode_file(file_path, size)
    text_file = File.open(file_path)

    text = text_file.read(text_file.size)

    encoded_text, tree = encode_text(text.unpack('B*').join, size)

    encoded_file_name = file_path + '.hffe'

    remainder = (8 - (tree.encoded_dictionnary + encoded_text.join).size % 8) % 8

    prefix = size.to_s(2).rjust(5, '0') + remainder.to_s(2).rjust(3, '0')

    values = tree.dictionnary.values.map { |value| value.size }.uniq.sort

    extra = (values.last - values.first).to_s(2).rjust(8, '0')

    File.open(encoded_file_name, 'wb' ) { |f| f.write [prefix + extra + tree.encoded_dictionnary + encoded_text.join].pack("B*") }
  end

  def self.decode_file(file_path)
    encoded_file = File.open(file_path)

    encoded_text = encoded_file.read(encoded_file.size).unpack("B*").join

    prefix = encoded_text[0...16]

    size = prefix[0...5].to_i(2)

    remainder = prefix[5...8].to_i(2)

    extra = prefix[8..-1].to_i(2)

    encoded_text = encoded_text[16..(-1 - remainder)]

    tree = EncodedTree.new(encoded_text, size)

    dictionnary = tree.dictionnary

    original_text = decode_text(tree.encoded_tree, dictionnary)

    File.open(file_path + '.ori', 'wb' ) { |f| f.write [original_text[0..(-1 - extra)]].pack("B*") }
  end
end
