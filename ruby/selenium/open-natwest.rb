require '/Users/Albert/Repos/scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-natwest.rb'

displays = ARGV[0]

natWest = BankNatWest.new(
    Encrypter.new.decrypt(NatWestUsername),
    Encrypter.new.decrypt(NatWestSecurityTop),
    Encrypter.new.decrypt(NatWestSecurityBottom),
    displays
)

natWest.login()
exit