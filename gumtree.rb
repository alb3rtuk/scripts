require '/Users/Natalee/Repos/scripts/ruby/lib/utilities.rb'
require 'nexmo'

GUMTREE_URL = 'http://www.gumtree.com/search?sort=date&page=1&distance=0&guess_search_category=holiday-rentals&q=&search_category=flats-and-houses-for-rent&search_location=bristol&seller_type=private&property_type=&min_price=&max_price=&min_property_number_beds=2&max_property_number_beds=2'

  encrypter = Encrypter.new
      nexmo = Nexmo::Client.new(key: encrypter.decrypt(NEXMO_KEY), secret: encrypter.decrypt(NEXMO_SECRET))



       page = Nokogiri::HTML(open(GUMTREE_URL))

puts page.class


# nexmo.send_message(from: 'Meelo', to: '+447749441611', text: 'HEY NATALEE I LOVE YOU!')






