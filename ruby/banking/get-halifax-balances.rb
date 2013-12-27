require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
include CommandLineReporter

crypter = Encrypter.new

halifax = BankHalifax.new(
    crypter.decrypt(HalifaxUsername),
    crypter.decrypt(HalifaxPassword),
    crypter.decrypt(HalifaxSecurity),
    'single',
    true,
    true
)

puts "\n"
halifax.getBalances(true)
puts "\n"
exit