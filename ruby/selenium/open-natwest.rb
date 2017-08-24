require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-natwest.rb'

displays = ARGV[0]

natWest = BankNatWest.new(
    Encryptor.new.decrypt(NatWestUsername),
    Encryptor.new.decrypt(NatWestSecurityTop),
    Encryptor.new.decrypt(NatWestSecurityBottom),
    displays
)

natWest.login()
exit