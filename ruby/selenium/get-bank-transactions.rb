require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-experian.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-natwest.rb'

include CommandLineReporter

displayProgress = (ARGV.empty?) ? false : true

# Get Database Connection
encrypter = Encrypter.new
databaseConnection = Mysql.new(
    encrypter.decrypt(EC2MySqlAlb3rtukHost),
    encrypter.decrypt(EC2MySqlAlb3rtukUser),
    encrypter.decrypt(EC2MySqlAlb3rtukPass),
    encrypter.decrypt(EC2MySqlAlb3rtukSchema)
)

experian = BankExperian.new(
    encrypter.decrypt(ExperianUsername),
    encrypter.decrypt(ExperianPassword),
    encrypter.decrypt(ExperianSecurity),
    'single',
    true,
    displayProgress
)

barclayCard = BankBarclayCard.new(
    encrypter.decrypt(BarclayCardUsername),
    encrypter.decrypt(BarclayCardPin),
    encrypter.decrypt(BarclayCardSecurity),
    'single',
    true,
    displayProgress
)

capitalOne = BankCapitalOne.new(
    encrypter.decrypt(CapitalOneUsername),
    encrypter.decrypt(CapitalOneSecurity),
    'single',
    true,
    displayProgress
)

halifax = BankHalifax.new(
    encrypter.decrypt(HalifaxUsername),
    encrypter.decrypt(HalifaxPassword),
    encrypter.decrypt(HalifaxSecurity),
    'single',
    true,
    displayProgress
)

lloyds = BankLloyds.new(
    encrypter.decrypt(LloydsUsername),
    encrypter.decrypt(LloydsPassword),
    encrypter.decrypt(LloydsSecurity),
    'single',
    true,
    displayProgress
)

natWest = BankNatWest.new(
    encrypter.decrypt(NatWestUsername),
    encrypter.decrypt(NatWestSecurityTop),
    encrypter.decrypt(NatWestSecurityBottom),
    'multiple',
    false,
    displayProgress,
    databaseConnection
)

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
