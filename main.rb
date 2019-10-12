require 'optparse'
require './huffman.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options] <file>"

  opts.on("-m", "--mode MODE", [:encode, :decode], "Set the mode: encode/decode") do |mode|
    options['mode'] = mode
  end

  opts.on("-s", "--size SIZE", "Set dictionnary length") do |size|
    options['size'] = size
  end
end.parse!

if options['mode'].nil?
  puts "You must specify a mode: encode/decode"
  Kernel::exit(FALSE)
end

options['size'] = 1 if options['size'].nil?

if ARGV.length < 1
  puts "You must specify a file to #{options['mode']}"
  Kernel::exit(FALSE)
end

case options['mode']
  when :encode
    Huffman::encode_file(ARGV.first, options['size'].to_i)
  when :decode
    Huffman::decode_file(ARGV.first)
  else
    puts "Invalid mode"
    Kernel::exit(FALSE)
end
