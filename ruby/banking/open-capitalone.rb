require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'

displays = ARGV[0]

crypter = Encrypter.new

capitalOne = BankCapitalOne.new(
    crypter.decrypt(CapitalOneUsername),
    crypter.decrypt(CapitalOneSecurity),
    displays
)

capitalOne.login()
exit