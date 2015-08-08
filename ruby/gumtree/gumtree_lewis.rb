require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require 'nokogiri'
require 'nexmo'
require 'webrick/httputils'

class Gumtree

    GUMTREE_URL = 'http://www.gumtree.com/search?sort=date&page=1&distance=0&guess_search_category=flats-and-houses-for-rent&q=flat&search_category=flats-and-houses-for-rent&search_location=bristol&seller_type=private&property_type=&min_price=&max_price=500&min_property_number_beds=0&max_property_number_beds=1&refine='
    SEARCH_TITLE = 'New Flat Available'
    MIN_PRICE = 350
    MAX_PRICE = 500

    # Must contain ATLEAST 1 word from BOTH whitelists.
    WHITELIST_1 = %w(horfield andrews redland bedminster barton george downs clifton werburghs cotham montpelier redfield philips judes hotwells brislington southville filton patchway stoke fishponds downend frenchay kingswood speedwell lawrence whitehall city centre center whiteladies johns marks bri bishopston ashley arches)
    # WHITELIST_2 = %w()

    # The phone numbers to text
    NUMBERS_TO_TEXT = %w(+447479161169)
    SENDER = "Albert's Script"

    # --------------------------------------------------------------------------------------------------------------------

    # DO NOT CHANGE
    GUMTREE_PREFIX = 'http://www.gumtree.com'
    TIME_PREFIX = "\033[1;37m[#{Time.now.getlocal}]\033[0m - "

    def initialize

        exit

        @encrypter = Encrypter.new
        @database = Mysql.new(
            @encrypter.decrypt(EC2MySqlAlb3rtukHost),
            @encrypter.decrypt(EC2MySqlAlb3rtukUser),
            @encrypter.decrypt(EC2MySqlAlb3rtukPass),
            @encrypter.decrypt(EC2MySqlAlb3rtukSchema)
        )

        existing_links = []
        query = @database.query('SELECT link FROM gumtree ORDER BY id DESC')
        query.each_hash do |row|
            existing_links << row['link']
        end
        query.free

        page = Nokogiri::HTML(open(WEBrick::HTTPUtils.escape(GUMTREE_URL)))
        links = page.css('a[class=listing-link]')

        links.each do |link|
            link = link['href']
            url = "#{GUMTREE_PREFIX}#{link}"
            create_new_entry(url) unless existing_links.include? url
        end

        system("echo '#{TIME_PREFIX}Searched GumTree for: \033[1;31m#{SEARCH_TITLE}\033[0m' >> /tmp/gumtree.log")

    end

    def create_new_entry(url)

        count = 0

        rows = @database.query("SELECT COUNT(link) FROM gumtree WHERE link = '#{url}'")
        rows.each_hash do |row|
            count = row['COUNT(link)'].to_i
            break
        end

        return if count > 0

        system("echo '#{TIME_PREFIX}New Listing: \033[1;36m#{url}\033[0m' >> /tmp/gumtree.log")

        page = Nokogiri::HTML(open(WEBrick::HTTPUtils.escape(url)))

        title = page.css('h1[itemprop=name]')
        title = title[0].text.strip

        price = page.css('strong[itemprop=price]')
        price = price[0].text.strip
        price_short = price.gsub('.00', '').gsub(/\D/, '').to_i

        description = page.css('p[itemprop=description]')
        description = description[0].text.strip

        @database.query("INSERT INTO gumtree (link) values ('#{url}')")

        if title != '' && price != '' && url !=''
            if title_description_matches_whitelist(title, description)
                if price_short > (MIN_PRICE - 1) && price_short < (MAX_PRICE + 1)

                    text = "#{title}\n#{price}\n#{url}"
                    nexmo = Nexmo::Client.new(key: @encrypter.decrypt(NEXMO_KEY), secret: @encrypter.decrypt(NEXMO_SECRET))

                    system("echo '#{TIME_PREFIX}Sent TXT alert: \033[1;32m#{title} - #{price}\033[0m' >> /tmp/gumtree.log")

                    # NUMBERS_TO_TEXT.each do |number|
                    #     nexmo.send_message(from: SENDER, to: number, text: text)
                    # end

                end
            end
        end

    end

    def title_description_matches_whitelist(title, description)

        title_split = title.split(' ')
        description_split = description.split(' ')

        whitelist_1 = false
        # whitelist_2 = false

        title_split.each do |word|
            whitelist_1 = true if WHITELIST_1.include?(word.downcase.gsub(/[^a-zA-Z0-9"]/, ''))
            # whitelist_2 = true if WHITELIST_2.include?(word.downcase.gsub(/[^a-zA-Z0-9"]/, ''))
        end

        description_split.each do |word|
            whitelist_1 = true if WHITELIST_1.include?(word.downcase.gsub(/[^a-zA-Z0-9"]/, ''))
            # whitelist_2 = true if WHITELIST_2.include?(word.downcase.gsub(/[^a-zA-Z0-9"]/, ''))
        end

        whitelist_1 ? true : false
        # whitelist_1 && whitelist_2 ? true : false

    end

end

Gumtree.new