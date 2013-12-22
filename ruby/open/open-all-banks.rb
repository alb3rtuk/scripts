require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

displays = ARGV[0]

# Halifax
browser = openHalifax(displays)
browser.execute

# NatWest
browser = openNatWest(displays)
browser.execute

# Lloyds
browser = openLloyds(displays)
browser.execute

# CapitalOne
browser = openCapitalOne(displays)
browser.execute

# BarclayCard
browser = openBarclayCard(displays)
browser.execute
