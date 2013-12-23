require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

displays = ARGV[0]

# NatWest
browser = openNatWest(displays)
browser.execute