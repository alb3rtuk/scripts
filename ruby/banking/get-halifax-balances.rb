require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
include CommandLineReporter

halifax = BankHalifax.new(
    Encrypter.new.decrypt(HalifaxUsername),
    Encrypter.new.decrypt(HalifaxPassword),
    Encrypter.new.decrypt(HalifaxSecurity),
    ARGV[0],
    ARGV[1].nil? ? true : false,
    ARGV[1].nil? ? true : false
)

puts "\n"
halifax.getBalances(true)
puts "\n"
exit