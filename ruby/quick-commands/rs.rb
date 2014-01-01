require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'

barclayCard = BankBarclayCard.new(Encrypter.new.decrypt(BarclayCardUsername), Encrypter.new.decrypt(BarclayCardPin), Encrypter.new.decrypt(BarclayCardSecurity), 'multiple')

barclayCard.payBarclayCard('5.00', 'halifax')