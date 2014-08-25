require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/iconsign.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/ebay.rb'
require 'rest_client'
require 'json'

pageCount = 0
orderCount = 0
orders = Array.new
ordersInfo = Array.new

data = {}
data['hasMoreOrders'] = true

while data['hasMoreOrders']
    pageCount = pageCount + 1
    data = RestClient.get "http://localhost:8080/ebay-service/getOrders/numberOfDays/3/#{pageCount}", {'environment' => 'production', 'ebay-token' => 'AgAAAA**AQAAAA**aAAAAA**e2GOUw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wGkYWiC5iAoA2dj6x9nY+seQ**96sAAA**AAMAAA**/FmNT6b3fxvF7XGBObBYSheWXgONWjF71tc/q9EjKzd57QBytpqIv6z3cbge3CUTdMGnENkJ7YIoUyRgULQQDEUpaCLMwD+Aes9eYCG9wW9/yoRGGLvK0rfLb3yJBBICGNUV+BgmzGNhyf0YJ/KCAJ7NCOB6K6mBiuOR2yd1QuDwNGTjjkRytlGH5ZS5CqzN0DdWkELzpZSkuDU7JDDRW0OWMJA2FyJc7DifX36yfSjcbYpSw8mISBOEgwvI9W1deMVNwb+k8lG4ejFtzHKfln1I3qt2ZvvYFMNWqUtNAmRA3BGfLKPtPaym/tobBSgvjC3HoIChazNfO7ONa+rnKJAFZZoG27Kw//TT1VnQo/VG3Uei10eoj8pCxhC69JAjM9Fu0mSPL9Zr9PIHhpvTVCjfsXnXDQJKfBRe8/Hp0X41HlnjB4YsePoH17F5WrbArxlnZu16/0GpsaNJjL2Sk1f2X7uFgw3VSsprYamU9f5zfKj7WY2Mqp+ITspgyugWo3VpYQdFewl9FjL/QsqRGCxRpdqFzHmieJD05oViPJscK3UjWrmOqfd78qGQfIiYOIV2s8WtCmdhMe3KJvXEyfeWOB2IGPFgehotcRwtSnDGC+wOhtJIre+ujEJNCBijaeivVFpS9uXgqsU8qZa54qDtmsqucPkGPrbJ7oAzizIm1SuVra1tfLH+v+vPYppC5QdBnzucyPqSiV2GIWV4I/T3yq9WIjA1xFM4yysoq8esyQGBIi5sMJ0umc7hIs7t'}
    data = JSON.parse(data)
    data['orders'].each do |order|
        if order['orderStatus'] == 'COMPLETED'
            unless order.has_key?('shippedTime')
                orderCount = orderCount + 1
                orders << order
            end
        end
    end
end

puts
puts "\x1B[42m Found \x1B[0m \x1B[32m#{orders.count} orders\x1B[0m"
puts

orderCount = 0

models = %w(CT-011 CT-012 CT-013 CT-021 CT-022 ST-011 ST-012 ST-013 TS-011 TS-012)
models.each do |model|
    orders.each do |order|
        unless order.has_key?('shippedTime')
            if order['orderStatus'] == 'COMPLETED'
                if order['transactionArray']['transaction'].count == 1

                    if order['transactionArray']['transaction'][0].has_key?('variation')
                        if order['transactionArray']['transaction'][0]['variation']['sku'].downcase != model.downcase
                            next
                        else
                            itemSku = order['transactionArray']['transaction'][0]['variation']['sku'].downcase
                        end
                    elsif order['transactionArray']['transaction'][0]['item']['sku'].downcase != model.downcase
                        next
                    else
                        itemSku = order['transactionArray']['transaction'][0]['item']['sku'].downcase
                    end

                    orderCount = orderCount + 1
                    case itemSku
                        when 'ct-011'
                            itemName = 'LARGE BLACK C/T'
                        when 'ct-012'
                            itemName = 'LARGE WHITE C/T'
                        when 'ct-013'
                            itemName = 'LARGE RED C/T'
                        when 'ct-021'
                            itemName = 'SMALL BLACK C/T'
                        when 'ct-022'
                            itemName = 'SMALL WHITE C/T'
                        when 'st-011'
                            itemName = 'BLACK SIDE TABLE'
                        when 'st-012'
                            itemName = 'WHITE SIDE TABLE'
                        when 'st-013'
                            itemName = 'RED SIDE TABLE'
                        when 'ts-011'
                            itemName = 'BLACK TV STAND'
                        when 'ts-012'
                            itemName = 'WHITE TV STAND'
                        else
                            itemName = order['transactionArray']['transaction'][0]['item']['sku']
                            puts "\x1B[31mITEM '#{order['transactionArray']['transaction'][0]['item']['sku'].downcase}' NOT FOUND!\x1B[0m"
                    end

                    qty = order['transactionArray']['transaction'][0]['quantityPurchased']

                    if qty == 1
                        puts "#{orderCount}) #{itemName} (#{qty}x) - #{order['buyerUserID']}"
                    else
                        puts "#{orderCount}) #{itemName} \x1B[33m(#{qty}x)\x1B[0m - #{order['buyerUserID']}"
                        itemName = "#{qty} X #{itemName}"
                    end

                    orderIDSplit = order['orderID'].split('-')
                    orderInfo = {}
                    orderInfo['itemID'] = orderIDSplit[0]
                    orderInfo['transID'] = orderIDSplit[1]
                    orderInfo['name'] = order['shippingAddress']['name']
                    orderInfo['street1'] = order['shippingAddress']['street1']
                    orderInfo['street2'] = order['shippingAddress']['street2']
                    orderInfo['cityName'] = order['shippingAddress']['cityName']
                    orderInfo['stateOrProvince'] = order['shippingAddress']['stateOrProvince']
                    orderInfo['postalCode'] = order['shippingAddress']['postalCode'].gsub(/\s+/, '')
                    orderInfo['phone'] = order['shippingAddress']['phone'].gsub(/\s+/, '')
                    orderInfo['email'] = order['transactionArray']['transaction'][0]['buyer']['email']
                    orderInfo['itemName'] = itemName
                    orderInfo['qty'] = qty * 2
                    orderInfo['weight'] = 20
                    orderInfo['userID'] = order['buyerUserID']
                    ordersInfo << orderInfo

                end
            end
        end
    end
end

puts

proceed = false
until proceed
    STDOUT.flush
    print "\x1B[42m Continue \x1B[0m \x1B[32mPress ENTER to start processing orders \x1B[0m=> "
    userResponse = STDIN.gets.chomp
    if userResponse == ''
        proceed = true
    elsif userResponse != ''
        puts "\n\x1B[41m Aborted! \x1B[0\n\n"
        exit
    end
end

puts

iConsign = IConsign.new(
    Encrypter.new.decrypt(IConsignUsername),
    Encrypter.new.decrypt(IConsignPassword)
)
iConsignBrowser = iConsign.login(ARGV[0])

ebay = Ebay.new(
    Encrypter.new.decrypt(EbayUsernameSleek),
    Encrypter.new.decrypt(EbayPasswordSleek)
)
ebayBrowser = ebay.login(ARGV[0])

ordersInfo.each do |order|

    ebayBrowser = ebay.getOrder(ebayBrowser, order['transID'], order['itemID'])

    iConsignBrowser = iConsign.processOrder(
        iConsignBrowser,
        order['name'],
        order['street1'],
        order['street2'],
        order['cityName'],
        order['stateOrProvince'],
        order['postalCode'],
        order['phone'],
        order['email'],
        order['itemName'],
        order['qty'],
        order['weight'],
        order['userID']
    )
    orderCount = orderCount - 1

    sleep(1)

    #proceed = false
    #until proceed
    #    STDOUT.flush
    #    print "\x1B[42m Continue \x1B[0m \x1B[32m#{orderCount} orders left. \x1B[0m=> "
    #    userResponse = STDIN.gets.chomp
    #    if userResponse == ''
    #        proceed = true
    #    elsif userResponse != ''
    #        puts "\n\x1B[41m Aborted! \x1B[0\n\n"
    #        exit
    #    end
    #end

    ebayBrowser.checkbox(:id => 'shippedflag').click
    ebayBrowser.input(:type => 'submit', :id => 'cmdsave').click
    iConsignBrowser.input(:type => 'submit', :id => 'ctl00_mainContent_SavePrint').click

    puts "\x1B[42m DONE! \x1B[0m \x1B[32m#{orderCount} orders left. \x1B[0m "
    sleep(1)
end

exit