require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

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

capitalOne = BankCapitalOne.new(
    crypter.decrypt(CapitalOneUsername),
    crypter.decrypt(CapitalOneSecurity),
    'single',
    true,
    true
)

halifax = BankHalifax.new(
    crypter.decrypt(HalifaxUsername),
    crypter.decrypt(HalifaxPassword),
    crypter.decrypt(HalifaxSecurity),
    'single',
    true,
    true
)

lloyds = BankLloyds.new(
    crypter.decrypt(LloydsUsername),
    crypter.decrypt(LloydsPassword),
    crypter.decrypt(LloydsSecurity),
    'single',
    true,
    true
)

natWest = BankNatWest.new(
    crypter.decrypt(NatWestUsername),
    crypter.decrypt(NatWestSecurityTop),
    crypter.decrypt(NatWestSecurityBottom),
    'single',
    true,
    true
)

puts "\n"
barclayCardBalances = barclayCard.getBalances(true)
barclayCardBalances = barclayCardBalances[1]
puts "\n"
capitalOneBalances = capitalOne.getBalances(true)
capitalOneBalances = capitalOneBalances[1]
puts "\n"
halifaxBalances = halifax.getBalances(true)
halifaxBalances = halifaxBalances[1]
puts "\n"
lloydsBalances = lloyds.getBalances(true)
lloydsBalances = lloydsBalances[1]
puts "\n"
natWestBalances = natWest.getBalances(true)
natWestBalances = natWestBalances[1]
puts "\n"

summary = {}
summary['total_available'] =
    natWestBalances['advantage_gold'] +
        natWestBalances['step_account'] +
        natWestBalances['savings_account'] +
        halifaxBalances['account_1_available'] +
        halifaxBalances['account_2_available'] +
        halifaxBalances['isa'] +
        lloydsBalances['cc_available'] +
        lloydsBalances['account_1_available'] +
        barclayCardBalances['available_funds'] +
        capitalOneBalances['available_funds'] +

        summary['total_cash'] =
            natWestBalances['advantage_gold'] +
                natWestBalances['step_account'] +
                natWestBalances['savings_account']
halifaxBalances['account_1_balance'] +
    halifaxBalances['account_2_balance'] +
    halifaxBalances['isa'] +
    lloydsBalances['account_1_balance']

summary['total_credit'] =
    halifaxBalances['account_1_overdraft'] +
        halifaxBalances['account_2_overdraft'] +
        lloydsBalances['cc_limit'] +
        lloydsBalances['account_1_overdraft'] +
        barclayCardBalances['credit_limit'] +
        capitalOneBalances['credit_limit']

summary['total_credit_used'] =
    lloydsBalances['cc_balance'] +
        barclayCardBalances['balance'] +
        barclayCardBalances['pending_transactions'] +
        capitalOneBalances['balance'] +
        (halifaxBalances['account_1_balance'] < 0 ? halifaxBalances['account_1_balance'] : 0) +
        (halifaxBalances['account_2_balance'] < 0 ? halifaxBalances['account_2_balance'] : 0) +
        (lloydsBalances['account_1_balance'] < 0 ? lloyds['account_1_balance'] : 0)

puts "\n[ #{Rainbow("Summary").foreground('#ff008a')} ]"
table(:border => true) do
    row do
        column('Total Available', :width => 20, :align => 'right')
        column('Total Cash', :width => 20, :align => 'right')
        column('Total Credit', :width => 20, :align => 'right')
        column('Credit Used', :width => 20, :align => 'right')
    end
    row do
        column("#{toCurrency(summary['total_available'])}", :color => (summary['total_available'] > 0) ? 'green' : 'white')
        column("#{toCurrency(summary['total_cash'])}", :color => (summary['total_available'] > 0) ? 'green' : 'white')
        column("#{toCurrency(summary['total_credit'])}", :color => (summary['total_available'] > 0) ? 'green' : 'white')
        column("#{toCurrency(0 - summary['total_credit_used'])}", :color => (summary['total_available'] > 0) ? 'green' : 'white')
    end
end