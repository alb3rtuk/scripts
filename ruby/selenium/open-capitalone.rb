require '/Users/Albert/Repos/scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-capitalone.rb'

displays = ARGV[0]

capitalOne = BankCapitalOne.new(
    Encrypter.new.decrypt(CapitalOneUsername),
    Encrypter.new.decrypt(CapitalOneSecurity),
    displays
)

capitalOne.login()
exit