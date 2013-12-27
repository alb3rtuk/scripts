require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
include CommandLineReporter

crypter = Encrypter.new

barclayCard = BankBarclayCard.new(
    crypter.decrypt(BarclayCardUsername),
    crypter.decrypt(BarclayCardPin),
    crypter.decrypt(BarclayCardSecurity),
    'single',
    true,
    true
)

puts "\n"

data = barclayCard.getBalances()
data = data[1]

puts "\n [ #{Rainbow("BarclayCard").foreground('#ff008a')} ]"

table(:border => true) do
    row do
        column('Outstanding Balance', :width => 20, :align => 'right')
        column('Pending Transactions', :width => 20, :align => 'right')
        column('Available Credit', :width => 20, :align => 'right')
        column('Credit Limit', :width => 20, :align => 'right')
        column('Minimum Payment', :width => 20, :align => 'right')
        column('Payment Due', :width => 20, :align => 'right')
    end
    row do
        column("-£#{toCurrency(data['current_balance'])}", :color => 'red')
        column("£#{toCurrency(data['pending_transactions'])}", :color => 'green')
        column("£#{toCurrency(data['available_credit'])}", :color => 'green')
        column("£#{toCurrency(data['credit_limit'])}", :color => 'green')
        column("£#{toCurrency(data['minimum_payment'])}", :color => 'green')
        column("#{data['due_date'].strftime('%d %b %Y')}", :color => 'white')
    end
end

puts "\n"
exit