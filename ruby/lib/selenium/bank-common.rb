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
                        if transactionsInDB['date'] == x['date'] && transactionsInDB['description'] == x['description'] && transactionsInDB['type'] == x['type'] && transactionsInDB['paid_in'].to_f == x['paid_in'].to_f && transactionsInDB['paid_out'].to_f == x['paid_out'].to_f
                            transactionFound = true
                            break
                        end
                    end
                    unless transactionFound
                        databaseConnection.query("DELETE FROM bank_account_transactions WHERE id='#{transactionsInDB['id']}'")
                    end
                end
            end
        end
    end

end