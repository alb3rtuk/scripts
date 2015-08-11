require '/Users/Albert/Repos/scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-barclaycard.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-capitalone.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-experian.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-halifax.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-lloyds.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-natwest.rb'

include CommandLineReporter

# Make sure we're online before we start
checkMachineIsOnline

displayProgress = true

headless = (ARGV[1].nil?) ? true : false
displays = ARGV[0]

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
    displays,
    headless,
    displayProgress,
    databaseConnection
)

halifax = BankHalifax.new(
    encrypter.decrypt(HalifaxUsername),
    encrypter.decrypt(HalifaxPassword),
    encrypter.decrypt(HalifaxSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

lloyds = BankLloyds.new(
    encrypter.decrypt(LloydsUsername),
    encrypter.decrypt(LloydsPassword),
    encrypter.decrypt(LloydsSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

capitalOne = BankCapitalOne.new(
    encrypter.decrypt(CapitalOneUsername),
    encrypter.decrypt(CapitalOneSecurity),
    displays,
    false,
    displayProgress,
    databaseConnection
)

barclayCard = BankBarclayCard.new(
    encrypter.decrypt(BarclayCardUsername),
    encrypter.decrypt(BarclayCardPin),
    encrypter.decrypt(BarclayCardSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

experian = BankExperian.new(
    encrypter.decrypt(ExperianUsername),
    encrypter.decrypt(ExperianPassword),
    encrypter.decrypt(ExperianSecurity),
    displays,
    false,
    displayProgress,
    databaseConnection
)

natWest.runExtraction(true)
halifax.runExtraction(true)
lloyds.runExtraction(true)
capitalOne.runExtraction(true)
barclayCard.runExtraction(true)
experian.runExtraction(true)