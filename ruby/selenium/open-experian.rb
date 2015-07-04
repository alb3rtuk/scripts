require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/selenium/bank-experian.rb'

displays = ARGV[0]

experian = BankExperian.new(
    Encrypter.new.decrypt(ExperianUsername),
    Encrypter.new.decrypt(ExperianPassword),
    Encrypter.new.decrypt(ExperianSecurity),
    displays
)

experian.login()
exit