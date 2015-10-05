require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/nevil-road-surgery.rb'

displays = ARGV[0]
nrs = NevilRoadSurgery.new(
    Encrypter.new.decrypt(NevilRoadUsername),
    Encrypter.new.decrypt(NevilRoadPassword)
)

nrs.login(displays)

exit