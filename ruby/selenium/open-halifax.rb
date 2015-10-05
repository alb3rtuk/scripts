require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-halifax.rb'

displays = ARGV[0]

halifax = BankHalifax.new(
    Encrypter.new.decrypt(HalifaxUsername),
    Encrypter.new.decrypt(HalifaxPassword),
    Encrypter.new.decrypt(HalifaxSecurity),
    displays
)

halifax.login
exit