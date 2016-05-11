require 'rest-client'
require 'rexml/document'
require 'yaml'

require File.expand_path('~/.secrets/secrets.rb')

category_id = 32834 # TV & Home Audio Accessories > Sound & Vision > Video Cables & Connectors



raw_xml = "
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<VerifyAddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">
  <RequesterCredentials>
    <eBayAuthToken>#{EBAY_AUTH_FACTORY_MALL}</eBayAuthToken>
  </RequesterCredentials>
  <ErrorLanguage>en_US</ErrorLanguage>
  <WarningLevel>High</WarningLevel>
  <Item>
    <Title>Harry Potter and the Philosopher's Stone</Title>
    <Description>
      This is the first book in the Harry Potter series. In excellent condition!
    </Description>
    <PrimaryCategory>
      <CategoryID>#{category_id}</CategoryID>
    </PrimaryCategory>
    <StartPrice>1.0</StartPrice>
    <CategoryMappingAllowed>true</CategoryMappingAllowed>
    <ConditionID>4000</ConditionID>
    <Country>US</Country>
    <Currency>USD</Currency>
    <DispatchTimeMax>3</DispatchTimeMax>
    <ListingDuration>Days_7</ListingDuration>
    <ListingType>Chinese</ListingType>
    <PaymentMethods>PayPal</PaymentMethods>
    <PayPalEmailAddress>magicalbookseller@yahoo.com</PayPalEmailAddress>
    <PictureDetails>
      <PictureURL>http://i1.sandbox.ebayimg.com/03/i/00/30/07/20_1.JPG?set_id=8800005007</PictureURL>
    </PictureDetails>
    <PostalCode>95125</PostalCode>
    <Quantity>1</Quantity>
    <ReturnPolicy>
      <ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>
      <RefundOption>MoneyBack</RefundOption>
      <ReturnsWithinOption>Days_30</ReturnsWithinOption>
      <Description>If you are not satisfied, return the book for refund.</Description>
      <ShippingCostPaidByOption>Buyer</ShippingCostPaidByOption>
    </ReturnPolicy>
    <ShippingDetails>
      <ShippingType>Flat</ShippingType>
      <ShippingServiceOptions>
        <ShippingServicePriority>1</ShippingServicePriority>
        <ShippingService>USPSMedia</ShippingService>
        <ShippingServiceCost>2.50</ShippingServiceCost>
      </ShippingServiceOptions>
    </ShippingDetails>
    <Site>US</Site>
  </Item>
</VerifyAddItemRequest>
"

# result = RestClient.post 'https://api.ebay.com/ws/api.dll',
#     raw_xml,
#     :content_type => :xml,
#     :accept => :xml,
#     :'X-EBAY-API-COMPATIBILITY-LEVEL' => '931',
#     :'X-EBAY-API-DEV-NAME' => EBAY_LIVE_DEV,
#     :'X-EBAY-API-APP-NAME' => EBAY_LIVE_APP,
#     :'X-EBAY-API-CERT-NAME' => EBAY_LIVE_CERT,
#     :'X-EBAY-API-SITEID' => '3',
#     :'X-EBAY-API-CALL-NAME' => 'VerifyAddItem'


# Write neatly to terminal
puts
doc = REXML::Document.new(raw_xml)
formatter = REXML::Formatters::Pretty.new
formatter.compact = true
formatter.write(doc, $stdout)
puts
