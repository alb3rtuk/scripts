require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')

if ARGV.empty?
    puts "\x1B[31mNothing to encrypt\x1B[0m"
    exit
end

puts "\x1B[90m#{Encrypter.new.encrypt(ARGV[0])}"
exit