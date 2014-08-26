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

halifax = BankHalifax.new(
    encrypter.decrypt(HalifaxUsername),
    encrypter.decrypt(HalifaxPassword),
    encrypter.decrypt(HalifaxSecurity),
    'multiple',
    headless,
    displayProgress,
    databaseConnection
)

lloyds = BankLloyds.new(
    encrypter.decrypt(LloydsUsername),
    encrypter.decrypt(LloydsPassword),
    encrypter.decrypt(LloydsSecurity),
    'multiple',
    headless,
    displayProgress,
    databaseConnection
)

experian = BankExperian.new(
    encrypter.decrypt(ExperianUsername),
    encrypter.decrypt(ExperianPassword),
    encrypter.decrypt(ExperianSecurity),
    'multiple',
    headless,
    displayProgress
)

barclayCard = BankBarclayCard.new(
    encrypter.decrypt(BarclayCardUsername),
    encrypter.decrypt(BarclayCardPin),
    encrypter.decrypt(BarclayCardSecurity),
    'multiple',
    headless,
    displayProgress
)

capitalOne = BankCapitalOne.new(
    encrypter.decrypt(CapitalOneUsername),
    encrypter.decrypt(CapitalOneSecurity),
    'multiple',
    headless,
    displayProgress
)

def insertTransactions(data, bank_account_id)
    data.each do |transaction|
        result = @databaseConnection.query("SELECT * FROM bank_account_transactions WHERE bank_account_id='#{bank_account_id}' AND date='#{transaction['date']}' AND type='#{transaction['type']}' AND description='#{transaction['description']}' AND paid_in='#{transaction['paid_in']}' AND paid_out='#{transaction['paid_out']}'")
        if result.num_rows == 0
            @databaseConnection.query("INSERT INTO bank_account_transactions (bank_account_id, date_fetched_string, date, type, description, paid_in, paid_out) VALUES (#{bank_account_id}, '#{DateTime.now}', '#{transaction['date']}', '#{transaction['type']}', '#{transaction['description']}', '#{transaction['paid_in']}', '#{transaction['paid_out']}')")
        end
    end
end


natWest.runExtraction(true)
halifax.runExtraction(true)
lloyds.runExtraction(true)

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
