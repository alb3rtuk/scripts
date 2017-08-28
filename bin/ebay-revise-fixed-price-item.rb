require 'rest-client'
require 'rexml/document'
require 'yaml'

require File.expand_path('~/.secrets/secrets.rb')

item_id = 401064215958

def get_variation_xml(data)

    puts data

    "<Variation>
        <SKU>#{data['sku']}</SKU>
        <StartPrice>#{data['price']}</StartPrice>
        <Quantity>#{data['original_qty']}</Quantity>
      </Variation>"

end


variation_xml = ''

[
    { 'sku' => 'HDMI-VARIOUS-0.5M', 'price' => '4.99', 'original_qty' => '100' },
    { 'sku' => 'HDMI-VARIOUS-1M', 'price' => '4.99', 'original_qty' => '400' },
    { 'sku' => 'HDMI-VARIOUS-1.5M', 'price' => '5.59', 'original_qty' => '400' },
    { 'sku' => 'HDMI-VARIOUS-2M', 'price' => '6.19', 'original_qty' => '400' },
    { 'sku' => 'HDMI-VARIOUS-3M', 'price' => '7.99', 'original_qty' => '350' },
    { 'sku' => 'HDMI-VARIOUS-5M', 'price' => '9.99', 'original_qty' => '250' },
    { 'sku' => 'HDMI-VARIOUS-7.5M', 'price' => '13.99', 'original_qty' => '50' },
    { 'sku' => 'HDMI-VARIOUS-10M', 'price' => '17.99', 'original_qty' => '50' },
    { 'sku' => 'HDMI-VARIOUS-15M', 'price' => '22.99', 'original_qty' => '50' }
].each do |data|
    variation_xml = "#{variation_xml}#{get_variation_xml(data)}"
end

raw_xml = "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<ReviseFixedPriceItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">
  <RequesterCredentials>
    <eBayAuthToken>#{EBAY_AUTH_FACTORY_MALL}</eBayAuthToken>
  </RequesterCredentials>
  <ErrorLanguage>en_US</ErrorLanguage>
  <WarningLevel>High</WarningLevel>
  <Item>
    <ItemID>#{item_id}</ItemID>
    <Variations>
        #{variation_xml}
    </Variations>
  </Item>
</ReviseFixedPriceItemRequest>
"

result = RestClient.post 'https://api.ebay.com/ws/api.dll',
                         raw_xml,
                         :content_type                     => :xml,
                         :accept                           => :xml,
                         :'X-EBAY-API-COMPATIBILITY-LEVEL' => '931',
                         :'X-EBAY-API-DEV-NAME'            => EBAY_LIVE_DEV,
                         :'X-EBAY-API-APP-NAME'            => EBAY_LIVE_APP,
                         :'X-EBAY-API-CERT-NAME'           => EBAY_LIVE_CERT,
                         :'X-EBAY-API-SITEID'              => '3',
                         :'X-EBAY-API-CALL-NAME'           => 'ReviseFixedPriceItem'


# Write neatly to terminal
puts
doc               = REXML::Document.new(result)
formatter         = REXML::Formatters::Pretty.new
formatter.compact = true
formatter.write(doc, $stdout)
puts