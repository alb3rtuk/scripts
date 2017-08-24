require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-halifax.rb'

displays = ARGV[0]

halifax = BankHalifax.new(
    Encryptor.new.decrypt(HalifaxUsername),
    Encryptor.new.decrypt(HalifaxPassword),
    Encryptor.new.decrypt(HalifaxSecurity),
    displays
)

halifax.login
exit