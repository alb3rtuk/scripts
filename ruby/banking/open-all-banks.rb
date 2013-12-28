require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

displays = ARGV[0]

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

browser = getBrowser(displays, false, 'ff')

browser = natWest.login(browser)
browser.send_keys [:command, 't']

browser = halifax.login(browser)
browser.send_keys [:command, 't']

browser = lloyds.login(browser)
browser.send_keys [:command, 't']

browser = barclayCard.login(browser)
browser.send_keys [:command, 't']

capitalOne.login(browser)

exit