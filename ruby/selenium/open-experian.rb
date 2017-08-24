require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-experian.rb'

displays = ARGV[0]

experian = BankExperian.new(
    Encryptor.new.decrypt(ExperianUsername),
    Encryptor.new.decrypt(ExperianPassword),
    Encryptor.new.decrypt(ExperianSecurity),
    displays
)

experian.login()
exit