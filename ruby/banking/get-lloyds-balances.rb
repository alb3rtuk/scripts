require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'

crypter = Encrypter.new

lloyds = BankLloyds.new(
    crypter.decrypt(LloydsUsername),
    crypter.decrypt(LloydsPassword),
    crypter.decrypt(LloydsSecurity),
    'single',
    true,
    true
)

puts "\n"
lloyds.getBalances(true)
puts "\n"
exit