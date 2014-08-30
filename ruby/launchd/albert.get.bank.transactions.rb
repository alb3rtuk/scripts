require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-experian.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-natwest.rb'

include CommandLineReporter

# Make sure we're online before we start
checkMachineIsOnline

displayProgress = false
headless = true

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

capitalOne = BankCapitalOne.new(
    encrypter.decrypt(CapitalOneUsername),
    encrypter.decrypt(CapitalOneSecurity),
    'multiple',
    headless,
    displayProgress,
    databaseConnection
)

barclayCard = BankBarclayCard.new(
    encrypter.decrypt(BarclayCardUsername),
    encrypter.decrypt(BarclayCardPin),
    encrypter.decrypt(BarclayCardSecurity),
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
    displayProgress,
    databaseConnection
)

natWest.runExtraction(displayProgress)
halifax.runExtraction(displayProgress)
lloyds.runExtraction(displayProgress)
capitalOne.runExtraction(displayProgress)
barclayCard.runExtraction(displayProgress)
experian.runExtraction(displayProgress)