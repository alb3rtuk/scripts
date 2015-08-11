require '/Users/Albert/Repos/scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-experian.rb'

displays = ARGV[0]

experian = BankExperian.new(
    Encrypter.new.decrypt(ExperianUsername),
    Encrypter.new.decrypt(ExperianPassword),
    Encrypter.new.decrypt(ExperianSecurity),
    displays
)

experian.login()
exit