require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities-banks.rb'

displays = ARGV[0]
accountName = ARGV[1]
if accountName.kind_of? String
    if accountName.length > 0
        accountName = accountName.downcase
        verifyInput(Array['lloyds', 'halifax', 'natwest', 'barclaycard', 'capitalone'], accountName)
    end
else
    accountName = 'all'
end

if inArray(Array['all', 'lloyds'], accountName)
    openLloyds(displays)
end
if inArray(Array['all', 'halifax'], accountName)
    openHalifax(displays)
end
if inArray(Array['all', 'natwest'], accountName)
    openNatWest(displays)
end
if inArray(Array['all', 'capitalone'], accountName)
    openCapitalOne(displays)
end
if inArray(Array['all', 'barclaycard'], accountName)
    browser = openBarclayCard(displays)
    browser.execute
end