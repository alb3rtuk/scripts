require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-creditCardPayer.rb'

BankCreditCardPayer.new(
    'capitalone',
    Array['natwest'],
    ARGV[0],
    ARGV[1].nil? ? true : false,
    ARGV[1].nil? ? true : false
)

exit