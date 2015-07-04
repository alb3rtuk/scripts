require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'
require 'nokogiri'
require 'nexmo'
require 'webrick/httputils'

class GumTree

  GUMTREE_PREFIX = 'http://www.gumtree.com'
  GUMTREE_URL = 'http://www.gumtree.com/search?sort=date&page=1&distance=0&guess_search_category=holiday-rentals&q=&search_category=flats-and-houses-for-rent&search_location=bristol&seller_type=private&property_type=&min_price=&max_price=&min_property_number_beds=1&max_property_number_beds=2'
  NATALEE = '+447470472611'
  ALBERT = '+447749441611'

  def initialize

    time = Time.now.getutc
    system("echo '#{time} - SCRIPT RAN' >> /tmp/gumtree.log")

    @blacklist = %w(filton hartcliffe southmead horfield)
    @whitelist = %w(clifton redland whiteladies westbury bishopston andrews)

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

    page = Nokogiri::HTML(open(GUMTREE_URL))
    links = page.css('a[class=listing-link]')

    links.each do |link|
      link = link['href']
      url = "#{GUMTREE_PREFIX}#{link}"
      create_new_entry(url) unless existing_links.include? url
    end

  end


  def create_new_entry(url)

    page = Nokogiri::HTML(open(WEBrick::HTTPUtils.escape(url)))

    title = page.css('h1[itemprop=name]')
    title = title[0].text.strip

    price = page.css('strong[itemprop=price]')
    price = price[0].text.strip
    price_short = price.gsub('.00', '').gsub(/\D/, '').to_i

    description = page.css('p[itemprop=description]')
    description = description[0].text.strip

    description_short = "#{description[0..80]}.."

    @database.query("INSERT INTO gumtree (link) values ('#{url}')")

    if title != '' && price != '' && url !=''
      if title_description_matches_whitelist(title, description)
        if price_short > 699 && price_short < 1101

          text = "#{title}\n#{price}\n#{url}"
          nexmo = Nexmo::Client.new(key: @encrypter.decrypt(NEXMO_KEY), secret: @encrypter.decrypt(NEXMO_SECRET))

          puts text

          [NATALEE, ALBERT].each do |number|
            nexmo.send_message(from: 'Meelo', to: number, text: text)
          end

        end
      end
    end

  end

  def title_description_matches_whitelist(title, description)

    title_split = title.split(' ')
    description_split = description.split(' ')

    # CHECK BLACKLIST FIRST
    title_split.each do |word|
      return false if @blacklist.include? word.downcase
    end
    description_split.each do |word|
      return false if @blacklist.include? word.downcase
    end

    # WHITELIST SECOND
    title_split.each do |word|
      return true if @whitelist.include? word.downcase
    end
    description_split.each do |word|
      return true if @whitelist.include? word.downcase
    end

    false

  end

end

GumTree.new