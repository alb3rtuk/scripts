require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')

if ARGV.empty?
    puts "\x1B[31mNothing to decrypt\x1B[0m"
    exit
end

puts "\x1B[90m#{Encryptor.new.decrypt(ARGV[0])}"
exit