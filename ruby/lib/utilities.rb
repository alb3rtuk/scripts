require 'rubygems'
require 'rainbow'
require 'command_line_reporter'
require 'watir-webdriver'
require 'openssl'
require 'time'
require '/Users/Albert/bin/config/private.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'

# Will exit script if element is not contained in arrayOfValidElements.
# @return boolean
def verifyInput(arrayOfValidElements, element, downcase = true)
    if downcase
        element = element.downcase
    end
    unless arrayOfValidElements.include?(element)
        raise(RuntimeError, "ERROR: Invalid input. The value '#{element}' is not accepted.")
    end
    true
end

# Same as verifyInput(), except this function doesn't stop the script if the element isn't found.
# Instead it returns false.
# @return boolean
def inArray(arrayOfValidElements, element, downcase = false)
    if downcase
        element = element.downcase
    end
    if arrayOfValidElements.include?(element)
        true
    else
        false
    end
end

# Checks if a String or Integer is a whole Number
# @return boolean
def isWholeNumber(value)
    if value =~ /^\s*\d+\s*$/
        true
    elsif value.is_a? Integer
        true
    else
        false
    end
end

# Get the character at a specific index in a string.
# @return string
def getCharAt(charAt, string)
    if isWholeNumber(charAt)
        charAt = charAt.to_i
        charAt = (charAt - 1)
        string[charAt]
    else
        raise(RuntimeError, "The value for CharAt must be a whole number. The script received (#{charAt.class}) #{charAt}.")
    end
end

# Get a Watir Browser object.
# @return [Watir::Browser]
def getBrowser(displays = 'single', headless = false, browser = 'chrome')
    verifyInput(Array['single', 'multiple'], displays)
    browser = Watir::Browser.new(!headless ? browser : 'phantomjs')
    x = y= width = height = 0
    if displays == 'single'
        width = 1680
        height = 2000
        x = 0
        y = -0
    elsif displays == 'multiple'
        width = 1920
        height = 2000
        x = 3360
        y = -2000
    end
    browser.window.move_to(x, y)
    browser.window.resize_to(width, height)
    browser.window.use
    browser
end

# Logs a message in backup/cronlog.txt
# @return void
def cronLog(message = '')
    timestamp = Time.now.strftime('%a %b %d %H:%I:%S %Z %Y')
    File.open('/Users/Albert/Repos/Scripts/backup/cronlog.txt', 'a') { |file| file.write("#{timestamp} - #{message}\n") }
end

# Converts a number to 2 decimal points and adds thousands delimiter + currency symbol.
# @return number
def toCurrency(number, symbol = '£', delimiter = ',')
    number = number.to_f
    minus = (number < 0) ? '-' : ''
    number = '%.2f' % number.abs
    number = number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
    "#{minus}#{symbol}#{number}"
end

# Calculates how many days between 2 dates (must be in 2013-10-29 format).
def diffBetweenDatesInDays(laterDate = nil, earlierDate = nil)
    dates = Array[earlierDate, laterDate]
    dates.map! { | date |
        if date == nil
            today = DateTime.now
            today.strftime('%y-%m-%d')
        else
            explodedDate = date.split('-')
            date = DateTime.new(explodedDate[0].to_i, explodedDate[1].to_i, explodedDate[2].to_i)
            date.strftime('%y-%m-%d')
        end
    }
    earlierDate = Date.parse(dates[0])
    laterDate = Date.parse(dates[1])
    laterDate.mjd - earlierDate.mjd
end

# Exits a script and raises a runtime error.
# @return void
def exitScript(msg = 'Something went wrong and the script died. Please check your code.')
    raise(RuntimeError, msg)
end