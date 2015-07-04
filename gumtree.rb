require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'
require 'nokogiri'
require 'nexmo'

GUMTREE_URL = 'http://www.gumtree.com/search?sort=date&page=1&distance=0&guess_search_category=holiday-rentals&q=&search_category=flats-and-houses-for-rent&search_location=bristol&seller_type=private&property_type=&min_price=&max_price=&min_property_number_beds=2&max_property_number_beds=2'

  encrypter = Encrypter.new
      nexmo = Nexmo::Client.new(key: encrypter.decrypt(NEXMO_KEY), secret: encrypter.decrypt(NEXMO_SECRET))
   database = Mysql.new(
       encrypter.decrypt(EC2MySqlAlb3rtukHost),
       encrypter.decrypt(EC2MySqlAlb3rtukUser),
       encrypter.decrypt(EC2MySqlAlb3rtukPass),
       encrypter.decrypt(EC2MySqlAlb3rtukSchema)
   )
       page = Nokogiri::HTML(open(GUMTREE_URL))

      links = page.css('a[class=listing-link]')
      links.each do |link|
          url = link['href']
      end



# nexmo.send_message(from: 'Meelo', to: '+447749441611', text: 'HEY NATALEE I LOVE YOU!')






