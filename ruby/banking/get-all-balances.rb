require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

include CommandLineReporter

notClean = (ARGV.empty?) ? false : true

barclayCard = BankBarclayCard.new(
    Encrypter.new.decrypt(BarclayCardUsername),
    Encrypter.new.decrypt(BarclayCardPin),
    Encrypter.new.decrypt(BarclayCardSecurity),
    'single',
    true,
    notClean
)

capitalOne = BankCapitalOne.new(
    Encrypter.new.decrypt(CapitalOneUsername),
    Encrypter.new.decrypt(CapitalOneSecurity),
    'single',
    true,
    notClean
)

halifax = BankHalifax.new(
    Encrypter.new.decrypt(HalifaxUsername),
    Encrypter.new.decrypt(HalifaxPassword),
    Encrypter.new.decrypt(HalifaxSecurity),
    'single',
    true,
    notClean
)

lloyds = BankLloyds.new(
    Encrypter.new.decrypt(LloydsUsername),
    Encrypter.new.decrypt(LloydsPassword),
    Encrypter.new.decrypt(LloydsSecurity),
    'single',
    true,
    notClean
)

natWest = BankNatWest.new(
    Encrypter.new.decrypt(NatWestUsername),
    Encrypter.new.decrypt(NatWestSecurityTop),
    Encrypter.new.decrypt(NatWestSecurityBottom),
    'single',
    true,
    notClean
)

if notClean then puts "\n" end
natWestBalances = natWest.getBalances(true)
natWestBalances = natWestBalances[1]
if notClean then puts "\n" end
halifaxBalances = halifax.getBalances(true)
halifaxBalances = halifaxBalances[1]
if notClean then puts "\n" end
lloydsBalances = lloyds.getBalances(true)
lloydsBalances = lloydsBalances[1]
if notClean then puts "\n" end
barclayCardBalances = barclayCard.getBalances(true)
barclayCardBalances = barclayCardBalances[1]
if notClean then puts "\n" end
capitalOneBalances = capitalOne.getBalances(true)
capitalOneBalances = capitalOneBalances[1]
if notClean then puts "\n\x1B[90mGenerating Summary\x1B[0m\n" end

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
    capitalOneBalances['available_funds']

summary['total_credit_used'] =
    lloydsBalances['cc_balance'] +
    barclayCardBalances['balance'] +
    barclayCardBalances['pending_transactions'] +
    capitalOneBalances['balance'] +
    (natWestBalances['advantage_gold'] < 0 ? -natWestBalances['advantage_gold'] : 0) +
    (natWestBalances['step_account'] < 0 ? -natWestBalances['step_account'] : 0) +
    (natWestBalances['savings_account'] < 0 ? -natWestBalances['savings_account'] : 0) +
    (halifaxBalances['account_1_balance'] < 0 ? -halifaxBalances['account_1_balance'] : 0) +
    (halifaxBalances['account_2_balance'] < 0 ? -halifaxBalances['account_2_balance'] : 0) +
    (lloydsBalances['account_1_balance'] < 0 ? -lloyds['account_1_balance'] : 0)

summary['total_credit'] =
    halifaxBalances['account_1_overdraft'] +
    halifaxBalances['account_2_overdraft'] +
    lloydsBalances['cc_limit'] +
    lloydsBalances['account_1_overdraft'] +
    barclayCardBalances['credit_limit'] +
    capitalOneBalances['credit_limit']

summary['total_cash'] =
    summary['total_available'] -
    summary['total_credit']

puts "\n[ #{Rainbow("Summary").foreground('#ff008a')} ]"
table(:border => true) do
    row do
        column('Total Available', :width => 20, :align => 'right')
        column('Total Cash', :width => 20, :align => 'right')
        column('Total Credit', :width => 20, :align => 'right')
        column('Credit Used', :width => 20, :align => 'right')
    end
    row do
        column("#{toCurrency(summary['total_available'])}", :color => (summary['total_available'] >= 0) ? 'green' : 'red')
        column("#{toCurrency(summary['total_cash'])}", :color => (summary['total_cash'] >= 0) ? 'green' : 'red')
        column("#{toCurrency(summary['total_credit'])}", :color => 'white')
        column("#{toCurrency(0 - summary['total_credit_used'])}", :color => (summary['total_credit_used'] > 0) ? 'red' : 'white')
    end
end
puts "\n"

exit