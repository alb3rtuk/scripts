require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/encryptor.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-barclaycard.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-capitalone.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-experian.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-halifax.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-lloyds.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/selenium/bank-natwest.rb')

include CommandLineReporter

# Make sure we're online before we start
checkMachineIsOnline

displayProgress = true

headless = (ARGV[1].nil?) ? true : false
displays = ARGV[0]

encryptor = Encryptor.new

databaseConnection = Mysql.new(
    encryptor.decrypt(EC2MySqlAlb3rtukHost),
    encryptor.decrypt(EC2MySqlAlb3rtukUser),
    encryptor.decrypt(EC2MySqlAlb3rtukPass),
    encryptor.decrypt(EC2MySqlAlb3rtukSchema)
)

natWest = BankNatWest.new(
    encryptor.decrypt(NatWestUsername),
    encryptor.decrypt(NatWestSecurityTop),
    encryptor.decrypt(NatWestSecurityBottom),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

halifax = BankHalifax.new(
    encryptor.decrypt(HalifaxUsername),
    encryptor.decrypt(HalifaxPassword),
    encryptor.decrypt(HalifaxSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

lloyds = BankLloyds.new(
    encryptor.decrypt(LloydsUsername),
    encryptor.decrypt(LloydsPassword),
    encryptor.decrypt(LloydsSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

capitalOne = BankCapitalOne.new(
    encryptor.decrypt(CapitalOneUsername),
    encryptor.decrypt(CapitalOneSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

barclayCard = BankBarclayCard.new(
    encryptor.decrypt(BarclayCardUsername),
    encryptor.decrypt(BarclayCardPin),
    encryptor.decrypt(BarclayCardSecurity),
    displays,
    headless,
    displayProgress,
    databaseConnection
)

experian = BankExperian.new(
    encryptor.decrypt(ExperianUsername),
    encryptor.decrypt(ExperianPassword),
    encryptor.decrypt(ExperianSecurity),
    displays,
    false,
    displayProgress,
    databaseConnection
)

natWest.runExtraction(true)
halifax.runExtraction(true)
lloyds.runExtraction(true)
capitalOne.runExtraction(true)
# barclayCard.runExtraction(true)
# experian.runExtraction(true)