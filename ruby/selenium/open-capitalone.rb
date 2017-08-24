require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-capitalone.rb'

displays = ARGV[0]

capitalOne = BankCapitalOne.new(
    Encryptor.new.decrypt(CapitalOneUsername),
    Encryptor.new.decrypt(CapitalOneSecurity),
    displays
)

capitalOne.login()
exit