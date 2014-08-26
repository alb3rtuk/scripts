require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-experian.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-natwest.rb'

include CommandLineReporter

displayProgress = true
headless = (ARGV.empty?) ? true : false

encrypter = Encrypter.new

databaseConnection = Mysql.new(
    encrypter.decrypt(EC2MySqlAlb3rtukHost),
    encrypter.decrypt(EC2MySqlAlb3rtukUser),
    encrypter.decrypt(EC2MySqlAlb3rtukPass),
    encrypter.decrypt(EC2MySqlAlb3rtukSchema)
)

natWest = BankNatWest.new(
    encrypter.decrypt(NatWestUsername),
    encrypter.decrypt(NatWestSecurityTop),
    encrypter.decrypt(NatWestSecurityBottom),
    'multiple',
    headless,
    displayProgress,
    databaseConnection
)

experian = BankExperian.new(
    encrypter.decrypt(ExperianUsername),
    encrypter.decrypt(ExperianPassword),
    encrypter.decrypt(ExperianSecurity),
    'single',
    headless,
    displayProgress
)

barclayCard = BankBarclayCard.new(
    encrypter.decrypt(BarclayCardUsername),
    encrypter.decrypt(BarclayCardPin),
    encrypter.decrypt(BarclayCardSecurity),
    'single',
    headless,
    displayProgress
)

capitalOne = BankCapitalOne.new(
    encrypter.decrypt(CapitalOneUsername),
    encrypter.decrypt(CapitalOneSecurity),
    'single',
    headless,
    displayProgress
)

halifax = BankHalifax.new(
    encrypter.decrypt(HalifaxUsername),
    encrypter.decrypt(HalifaxPassword),
    encrypter.decrypt(HalifaxSecurity),
    'single',
    headless,
    displayProgress
)

lloyds = BankLloyds.new(
    encrypter.decrypt(LloydsUsername),
    encrypter.decrypt(LloydsPassword),
    encrypter.decrypt(LloydsSecurity),
    'single',
    headless,
    displayProgress
)

# data = {"select_platinum_balance" => -2030.99, "select_platinum_available" => 5468.01, "select_platinum_overdraft" => 7500, "savings_account" => 5044.88, "step_account" => 10.0, "select_platinum_transactions" => [{"date" => "2014-08-12", "type" => "BAC", "description" => "A RANNETSPERGER , LLOYDS ACCOUNT , FP 12/08/14 1230 , 400000000134072603", "paid_in" => 602.65, "paid_out" => 0.0}, {"date" => "2014-08-13", "type" => "POS", "description" => "4838 12AUG14 , BARCLAYCARD , BILL PAYMENT GB", "paid_in" => 0.0, "paid_out" => 30.26}, {"date" => "2014-08-14", "type" => "POS", "description" => "4838 12AUG14 , SPOTIFY SPOTIFY , PREMIU , LONDON GB", "paid_in" => 0.0, "paid_out" => 9.99}, {"date" => "2014-08-14", "type" => "D/D", "description" => "UK MAIL LIMITED", "paid_in" => 0.0, "paid_out" => 2.0}, {"date" => "2014-08-19", "type" => "-  ", "description" => "521005 19AUG 1528", "paid_in" => 500.0, "paid_out" => 0.0}, {"date" => "2014-08-20", "type" => "BAC", "description" => "PAYPAL , PPWDL5DCJ28AHBF64L, FP 19/08/14 2119 , PPWD000000002F6MU6", "paid_in" => 145.03, "paid_out" => 0.0}, {"date" => "2014-08-20", "type" => "OTR", "description" => "CALL REF.NO. 0483 , LLYODS TSB , FP 19/08/14 10 , 44223817697808000N", "paid_in" => 0.0, "paid_out" => 53.21}, {"date" => "2014-08-20", "type" => "OTR", "description" => "CALL REF.NO. 0483 , LLYODS TSB , FP 19/08/14 10 , 21223733386272000N", "paid_in" => 0.0, "paid_out" => 462.73}, {"date" => "2014-08-21", "type" => "OTR", "description" => "MOBILE PAYMENT , FROM 07519616416", "paid_in" => 25.0, "paid_out" => 0.0}, {"date" => "2014-08-21", "type" => "D/D", "description" => "UK MAIL LIMITED", "paid_in" => 0.0, "paid_out" => 281.7}, {"date" => "2014-08-22", "type" => "BAC", "description" => "PAYPAL , PPWDL5DCJ28APG8GCL, FP 22/08/14 1059 , PPWD000000002FM9R8", "paid_in" => 180.52, "paid_out" => 0.0}, {"date" => "2014-08-22", "type" => "BAC", "description" => "PAYPAL , PPWDL5DCJ28AN8HJXU, FP 21/08/14 2045 , PPWD000000002FJ514", "paid_in" => 435.34, "paid_out" => 0.0}, {"date" => "2014-08-22", "type" => "D/D", "description" => "NAMES.CO.UK", "paid_in" => 0.0, "paid_out" => 29.99}, {"date" => "2014-08-22", "type" => "BAC", "description" => "PPWDL5DCJ28AQJRQ56", "paid_in" => 229.88, "paid_out" => 0.0}, {"date" => "2014-08-23", "type" => "BAC", "description" => "PPWDL5DCJ28ARZA7SQ", "paid_in" => 270.7, "paid_out" => 0.0}], "step_account_transactions" => [], "savings_account_transactions" => []}
#
# def insertTransactions(data, bank_account_id)
#     data.each do |transaction|
#         result = @databaseConnection.query("SELECT * FROM bank_account_transactions WHERE bank_account_id='#{bank_account_id}' AND date='#{transaction['date']}' AND type='#{transaction['type']}' AND description='#{transaction['description']}' AND paid_in='#{transaction['paid_in']}' AND paid_out='#{transaction['paid_out']}'")
#         if result.num_rows == 0
#             @databaseConnection.query("INSERT INTO bank_account_transactions (bank_account_id, date_fetched, date, type, description, paid_in, paid_out) VALUES (#{bank_account_id}, '#{DateTime.now}', '#{transaction['date']}', '#{transaction['type']}', '#{transaction['description']}', '#{transaction['paid_in']}', '#{transaction['paid_out']}')")
#         end
#     end
# end
#
# @databaseConnection = databaseConnection
# @databaseConnection.query('DELETE FROM bank_account_type_bank_account WHERE bank_account_id=1 OR bank_account_id=2 OR bank_account_id=3')
# @databaseConnection.query('DELETE FROM bank_account_transactions WHERE bank_account_id=1 OR bank_account_id=2 OR bank_account_id=3')
#
# @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched) VALUES (1, #{data['select_platinum_balance']}, #{data['select_platinum_available']}, #{data['select_platinum_overdraft']}, '#{DateTime.now}')")
# @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched) VALUES (2, #{data['step_account']}, #{data['step_account']}, 0, '#{DateTime.now}')")
# @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched) VALUES (3, #{data['savings_account']}, #{data['savings_account']}, 0, '#{DateTime.now}')")
# insertTransactions(data['select_platinum_transactions'], 1)
# insertTransactions(data['step_account_transactions'], 2)
# insertTransactions(data['savings_account_transactions'], 3)
#
#
# exit

natWest.runExtraction(true)


# puts "\n" if notClean
# experianCreditInfo = experian.getCreditInfo
# experianCreditInfo = experianCreditInfo[1]


# puts "\n" if notClean
# halifaxBalances = halifax.getBalances(true)
# halifaxBalances = halifaxBalances[1]
# puts "\n" if notClean
# lloydsBalances = lloyds.getBalances(true)
# lloydsBalances = lloydsBalances[1]
# puts "\n" if notClean
# barclayCardBalances = barclayCard.getBalances(true)
# barclayCardBalances = barclayCardBalances[1]
# puts "\n" if notClean
# capitalOneBalances = capitalOne.getBalances(true)
# capitalOneBalances = capitalOneBalances[1]
# puts "\n\x1B[90mGenerating Summary\x1B[0m\n" if notClean
