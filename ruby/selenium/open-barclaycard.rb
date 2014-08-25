require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-barclaycard.rb'

displays = ARGV[0]

barclayCard = BankBarclayCard.new(
    Encrypter.new.decrypt(BarclayCardUsername),
    Encrypter.new.decrypt(BarclayCardPin),
    Encrypter.new.decrypt(BarclayCardSecurity),
    displays
)

barclayCard.login
exit