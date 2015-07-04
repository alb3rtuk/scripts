require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Natalee/Repos/Scripts/ruby/lib/selenium/bank-lloyds.rb'

displays = ARGV[0]

lloyds = BankLloyds.new(
    Encrypter.new.decrypt(LloydsUsername),
    Encrypter.new.decrypt(LloydsPassword),
    Encrypter.new.decrypt(LloydsSecurity),
    displays
)

lloyds.login
exit