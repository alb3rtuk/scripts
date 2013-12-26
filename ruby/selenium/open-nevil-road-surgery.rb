require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/nevil-road-surgery.rb'

displays = ARGV[0]
crypter = Encrypter.new

nrs = NevilRoadSurgery.new(
    crypter.decrypt(NevilRoadUsername),
    crypter.decrypt(NevilRoadPassword)
)

nrs.login(displays)

exit