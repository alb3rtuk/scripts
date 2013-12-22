require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

displays = ARGV[0]

# CapitalOne
browser = openCapitalOne(displays)
browser.execute