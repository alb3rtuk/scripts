require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')
require '/Users/Albert/Repos/scripts/ruby/lib/encryptor.rb'
require '/Users/Albert/Repos/scripts/ruby/lib/selenium/bank-lloyds.rb'

displays = ARGV[0]

lloyds = BankLloyds.new(
    Encryptor.new.decrypt(LloydsUsername),
    Encryptor.new.decrypt(LloydsPassword),
    Encryptor.new.decrypt(LloydsSecurity),
    displays
)

lloyds.login
exit