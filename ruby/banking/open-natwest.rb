require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/browser.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/banks.rb'

displays = ARGV[0]

crypter = Encrypter.new
banking = Banking.new

browser = banking.openNatWest(
    crypter.decrypt(NatWestUsername),
    crypter.decrypt(NatWestSecurityTop),
    crypter.decrypt(NatWestSecurityBottom),
    displays
)

exit

# Legacy function..

require '/Users/Albert/Repos/Scripts/ruby/lib/banks.rb'

displays = ARGV[0]

# NatWest
browser = openNatWest(displays)
browser.execute