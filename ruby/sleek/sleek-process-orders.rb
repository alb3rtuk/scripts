require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/iconsign.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/ebay.rb'
require 'rest_client'
require 'json'

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


data = RestClient.get 'http://localhost:8080/ebay-service/getOrders/numberOfDays/1/1', {'environment' => 'production', 'ebay-token' => 'AgAAAA**AQAAAA**aAAAAA**e2GOUw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wGkYWiC5iAoA2dj6x9nY+seQ**96sAAA**AAMAAA**/FmNT6b3fxvF7XGBObBYSheWXgONWjF71tc/q9EjKzd57QBytpqIv6z3cbge3CUTdMGnENkJ7YIoUyRgULQQDEUpaCLMwD+Aes9eYCG9wW9/yoRGGLvK0rfLb3yJBBICGNUV+BgmzGNhyf0YJ/KCAJ7NCOB6K6mBiuOR2yd1QuDwNGTjjkRytlGH5ZS5CqzN0DdWkELzpZSkuDU7JDDRW0OWMJA2FyJc7DifX36yfSjcbYpSw8mISBOEgwvI9W1deMVNwb+k8lG4ejFtzHKfln1I3qt2ZvvYFMNWqUtNAmRA3BGfLKPtPaym/tobBSgvjC3HoIChazNfO7ONa+rnKJAFZZoG27Kw//TT1VnQo/VG3Uei10eoj8pCxhC69JAjM9Fu0mSPL9Zr9PIHhpvTVCjfsXnXDQJKfBRe8/Hp0X41HlnjB4YsePoH17F5WrbArxlnZu16/0GpsaNJjL2Sk1f2X7uFgw3VSsprYamU9f5zfKj7WY2Mqp+ITspgyugWo3VpYQdFewl9FjL/QsqRGCxRpdqFzHmieJD05oViPJscK3UjWrmOqfd78qGQfIiYOIV2s8WtCmdhMe3KJvXEyfeWOB2IGPFgehotcRwtSnDGC+wOhtJIre+ujEJNCBijaeivVFpS9uXgqsU8qZa54qDtmsqucPkGPrbJ7oAzizIm1SuVra1tfLH+v+vPYppC5QdBnzucyPqSiV2GIWV4I/T3yq9WIjA1xFM4yysoq8esyQGBIi5sMJ0umc7hIs7t'}
data = JSON.parse(data)

count = 0

data['orders'].each do |order|
    if order['orderStatus'] == 'COMPLETED'
        unless order.has_key?('shippedTime')
            count = count + 1
            orderIDSplit = order['orderID'].split('-')
            itemID = orderIDSplit[0]
            transID = orderIDSplit[1]
            ebayBrowser = ebay.getOrder(ebayBrowser, transID, itemID)

            iConsignBrowser = iConsign.processOrder(
                iConsignBrowser,
                order['shippingAddress']['name'],
                order['shippingAddress']['street1'],
                order['shippingAddress']['street2'],
                order['shippingAddress']['cityName'],
                order['shippingAddress']['stateOrProvince'],
                order['shippingAddress']['postalCode'].gsub(/\s+/, ''),
                order['shippingAddress']['phone'].gsub(/\s+/, ''),
                order['transactionArray']['transaction'][0]['buyer']['email'],
                order['transactionArray']['transaction'][0]['item']['sku'],
                2,
                20,
            )
        end
    end

    proceed = false
    until proceed
        STDOUT.flush
        print "\x1B[42m Confirm \x1B[0m \x1B[32mAre you absolutely sure you want to continue? \x1B[90m[y/n]\x1B[0m => "
        userResponse = STDIN.gets.chomp
        if userResponse == 'y'
            proceed = true
        elsif userResponse == 'n'
            puts "\n\x1B[41m Abort \x1B[0m You've chosen to abort paying your credit card. Goodbye!\n\n"
            exit
        end
    end
end




exit