require 'watir-webdriver'

Selenium::WebDriver::Firefox::Binary.path='/Users/Albert/Applications/TOR.app/Contents/MacOS/TorBrowser.app/Contents/MacOS/firefox'
$browser                                 = Watir::Browser.new :firefox

$browser.goto 'http://assets.factorymall.co.uk/ebay/listing-2.php?p=hdmi-multi'
