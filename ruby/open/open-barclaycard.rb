require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

displays = ARGV[0]

# BarclayCard
browser = openBarclayCard(displays)
browser.execute
