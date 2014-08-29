require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require 'rubygems'
require 'appscript'

include Appscript

# Display list of system commands that can be run.
# systemEvenets = Appscript.app('System Events')
# systemEvenets.methods.each { |method| puts method }

# This is how you would run Command + K (in Terminal)
# app('System Events').key_code(40, :using => [:command_down])


# encrypter = Encrypter.new
# databaseConnection = Mysql.new(
#     encrypter.decrypt(EC2MySqlAlb3rtukHost),
#     encrypter.decrypt(EC2MySqlAlb3rtukUser),
#     encrypter.decrypt(EC2MySqlAlb3rtukPass),
#     encrypter.decrypt(EC2MySqlAlb3rtukSchema)
# )
# transactions = databaseConnection.query('SELECT * FROM bank_account_transactions WHERE date > DATE_SUB(CURDATE(), INTERVAL 30 DAY) ORDER BY date ASC, bank_account_id ASC, type ASC')
# transactions.each_hash do |transactionsInDB|
#     puts "\x1B[41m DELETING \x1B[0m #{transactionsInDB['date']} - [ BANK ACCOUNT ID: #{transactionsInDB['bank_account_id']} ] - #{transactionsInDB['description']} => #{transactionsInDB['paid_in'].to_f > 0 ? transactionsInDB['paid_in'] : "-#{transactionsInDB['paid_out']}"}"
# end

require 'craig'

listings = Craig.query(:birmingham, :personals => :strictly_platonic)

listings.each do |listing|
    puts listing.inspect
end