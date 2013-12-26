require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/nevil-road-surgery.rb'

crypter = Encrypter.new

nrs = NevilRoadSurgery.new(
    crypter.decrypt(NevilRoadUsername),
    crypter.decrypt(NevilRoadPassword)
)

nrs.orderAsthma('single', true)

exit