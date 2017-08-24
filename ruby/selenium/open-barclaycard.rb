require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-barclaycard.rb'

displays = ARGV[0]

barclayCard = BankBarclayCard.new(
    Encryptor.new.decrypt(BarclayCardUsername),
    Encryptor.new.decrypt(BarclayCardPin),
    Encryptor.new.decrypt(BarclayCardSecurity),
    displays
)

barclayCard.login
exit