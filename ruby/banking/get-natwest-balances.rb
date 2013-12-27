require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'
include CommandLineReporter

crypter = Encrypter.new

natWest = BankNatWest.new(
    crypter.decrypt(NatWestUsername),
    crypter.decrypt(NatWestSecurityTop),
    crypter.decrypt(NatWestSecurityBottom),
    'single',
    true,
    true
)

puts "\n"

data = natWest.getBalances()
data = data[1]

puts "\n [ #{Rainbow("NatWest").foreground('#ff008a')} ]"

table(:border => true) do
    row do
        column('90042689 Account', :width => 20, :align => 'right')
        column('STEP Account', :width => 20, :align => 'right')
        column('Savings Account', :width => 20, :align => 'right')
    end
    row do
        column("£#{toCurrency(data['main_account'])}", :color => 'green')
        column("£#{toCurrency(data['step_account'])}", :color => 'green')
        column("£#{toCurrency(data['savings_account'])}", :color => 'green')
    end
end

puts "\n"
exit