require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/selenium/bank-capitalone.rb'

displays = ARGV[0]

capitalOne = BankCapitalOne.new(
    Encrypter.new.decrypt(CapitalOneUsername),
    Encrypter.new.decrypt(CapitalOneSecurity),
    displays
)

capitalOne.login()
exit