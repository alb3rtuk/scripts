require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'

displays = ARGV[0]

halifax = BankHalifax.new(
    Encrypter.new.decrypt(HalifaxUsername),
    Encrypter.new.decrypt(HalifaxPassword),
    Encrypter.new.decrypt(HalifaxSecurity),
    displays
)

halifax.login
exit