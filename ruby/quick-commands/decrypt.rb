require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

if ARGV.empty?
    puts "\x1B[31mNothing to decrypt\x1B[0m"
    exit
end

encrypter = Encrypter.new

puts "\x1B[90m#{encrypter.decrypt(ARGV[0])}"
exit