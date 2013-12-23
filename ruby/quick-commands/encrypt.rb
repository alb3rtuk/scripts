require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

encrypter = Encrypter.new

puts "\x1B[90m#{encrypter.encrypt(ARGV[0])}"