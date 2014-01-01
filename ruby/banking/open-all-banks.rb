require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

displays = ARGV[0]

barclayCard = BankBarclayCard.new(
    Encrypter.new.decrypt(BarclayCardUsername),
    Encrypter.new.decrypt(BarclayCardPin),
    Encrypter.new.decrypt(BarclayCardSecurity),
    'single',
    true,
    true
)

capitalOne = BankCapitalOne.new(
    Encrypter.new.decrypt(CapitalOneUsername),
    Encrypter.new.decrypt(CapitalOneSecurity),
    'single',
    true,
    true
)

halifax = BankHalifax.new(
    Encrypter.new.decrypt(HalifaxUsername),
    Encrypter.new.decrypt(HalifaxPassword),
    Encrypter.new.decrypt(HalifaxSecurity),
    'single',
    true,
    true
)

lloyds = BankLloyds.new(
    Encrypter.new.decrypt(LloydsUsername),
    Encrypter.new.decrypt(LloydsPassword),
    Encrypter.new.decrypt(LloydsSecurity),
    'single',
    true,
    true
)

natWest = BankNatWest.new(
    Encrypter.new.decrypt(NatWestUsername),
    Encrypter.new.decrypt(NatWestSecurityTop),
    Encrypter.new.decrypt(NatWestSecurityBottom),
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