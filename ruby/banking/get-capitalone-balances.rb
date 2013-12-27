require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'

crypter = Encrypter.new

capitalOne = BankCapitalOne.new(
    crypter.decrypt(CapitalOneUsername),
    crypter.decrypt(CapitalOneSecurity),
    'single',
    true,
    true
)

puts "\n"
capitalOne.getBalances(true)
puts "\n"
exit