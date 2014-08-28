require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class BankCommon

    # Checks that transactions in DB actually still exist
    # @return void
    def checkIfTransactionStillExist(databaseConnection, objectData)
        objectData.each do |data|
            transactions = databaseConnection.query('SELECT * FROM bank_account_transactions WHERE date > DATE_SUB(CURDATE(), INTERVAL 30 DAY) ORDER BY date ASC, bank_account_id ASC, type ASC')
            transactions.each_hash do |transactionsInDB|
                if transactionsInDB['bank_account_id'].to_i == data[:bank_account_id]
                    transactionFound = false
                    data[:transactions].each do |x|
                        if transactionsInDB['date'] == x['date'] && transactionsInDB['description'] == x['description'] && transactionsInDB['type'] == x['type'] && transactionsInDB['paid_in'].to_f == x['paid_in'].to_f && transactionsInDB['paid_out'].to_f == x['paid_out'].to_f && transactionsInDB['balance'].to_f == x['balance'].to_f
                            transactionFound = true
                            break
                        end
                    end
                    unless transactionFound
                        puts "\x1B[41m DELETING \x1B[0m #{transactionsInDB['date']} - [ BANK ACCOUNT ID: #{transactionsInDB['bank_account_id']} ] - #{transactionsInDB['description']} => #{transactionsInDB['paid_in'].to_f > 0 ? transactionsInDB['paid_in'] : "-#{transactionsInDB['paid_out']}"}"
                        databaseConnection.query("DELETE FROM bank_account_transactions WHERE id='#{transactionsInDB['id']}'")
                    end
                end
            end
        end
    end

    # Inserts individal transactions into DB
    def insertTransactions(databaseConnection, data, bank_account_id)
        data.each do |transaction|
            result = databaseConnection.query("SELECT * FROM bank_account_transactions WHERE bank_account_id='#{bank_account_id}' AND date='#{transaction['date']}' AND type='#{transaction['type']}' AND description='#{transaction['description'].gsub(/'/) {|s| "\\'"}}' AND paid_in='#{transaction['paid_in']}' AND paid_out='#{transaction['paid_out']}' AND balance='#{transaction['balance']}'")
            if result.num_rows == 0
                databaseConnection.query("INSERT INTO bank_account_transactions (bank_account_id, date_fetched, date_fetched_string, date, type, description, paid_in, paid_out, balance) VALUES (#{bank_account_id}, '#{DateTime.now}', '#{DateTime.now}', '#{transaction['date']}', '#{transaction['type']}', '#{transaction['description'].gsub(/'/) {|s| "\\'"}}', '#{transaction['paid_in']}', '#{transaction['paid_out']}', '#{transaction['balance']}')")
            end
        end
    end

end