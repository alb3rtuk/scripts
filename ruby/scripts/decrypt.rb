require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'

if ARGV.empty?
    puts "\x1B[31mNothing to decrypt\x1B[0m"
    exit
end

puts "\x1B[90m#{Encrypter.new.decrypt(ARGV[0])}"
exit