require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/iconsign.rb'

iConsign = IConsign.new(
    Encrypter.new.decrypt(IConsignUsername),
    Encrypter.new.decrypt(IConsignPassword)
)
iConsignBrowser = iConsign.login(ARGV[0])

iConsign.getSentConsignments(iConsignBrowser)