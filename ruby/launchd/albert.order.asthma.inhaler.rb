require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/nevil-road-surgery.rb'

nrs = NevilRoadSurgery.new(
    Encrypter.new.decrypt(NevilRoadUsername),
    Encrypter.new.decrypt(NevilRoadPassword)
)

nrs.orderAsthma('single', true)

exit