require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-experian.rb'

displays = ARGV[0]

experian = BankExperian.new(
    Encrypter.new.decrypt(ExperianUsername),
    Encrypter.new.decrypt(ExperianPassword),
    Encrypter.new.decrypt(ExperianSecurity),
    displays
)

experian.login()
exit