require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

if ARGV.empty?
    puts "\x1B[31mNothing to encrypt\x1B[0m"
    exit
end

enputs "\x1B[90m#{encrypter.encrypt(ARGV[0])}"
exit