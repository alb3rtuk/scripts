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
natWestBalances = natWest.getBalances(true)
natWestBalances = natWestBalances[1]
puts "\n"
halifaxBalances = halifax.getBalances(true)
halifaxBalances = halifaxBalances[1]
puts "\n"
lloydsBalances = lloyds.getBalances(true)
lloydsBalances = lloydsBalances[1]
puts "\n"
barclayCardBalances = barclayCard.getBalances(true)
barclayCardBalances = barclayCardBalances[1]
puts "\n"
capitalOneBalances = capitalOne.getBalances(true)
capitalOneBalances = capitalOneBalances[1]
puts "\n"

# DEBUG STUFF, DELETE BY 8TH JAN IF NOT USING

#natWestBalances = {"advantage_gold" => 1932.61, "step_account" => 5.59, "savings_account" => 20.72}
#halifaxBalances = {"isa" => 75.0, "isa_remaining" => 5710.04, "account_1_balance" => 105.0, "account_1_available" => 5105.0, "account_1_overdraft" => 5000.0, "account_2_balance" => 600.0, "account_2_available" => 600.0, "account_2_overdraft" => 0.0}
#lloydsBalances = {"account_1_balance" => 169.42, "account_1_available" => 3169.42, "account_1_overdraft" => 3000.0, "cc_balance" => 1673.41, "cc_available" => 2324.98, "cc_limit" => 4000.0, "cc_minimum_payment" => 10.0}
#barclayCardBalances = {"balance" => 19.69, "available_funds" => 1580.31, "credit_limit" => 1600.0, "minimum_payment" => 5.0, "pending_transactions" => 0.0}
#capitalOneBalances= {"balance" => 783.25, "available_funds" => 216.75, "credit_limit" => 1000.0, "minimum_payment" => 7.83}

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

puts "[ #{Rainbow("Summary").foreground('#ff008a')} ]"
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