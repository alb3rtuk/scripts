require 'rubygems'
require 'rainbow'
require 'command_line_reporter'
require 'watir-webdriver'
require 'openssl'

# Will exit script if element is not contained in arrayOfValidElements.
# @return boolean
def verifyInput(arrayOfValidElements, element, downcase = true)
    if downcase
        element = element.downcase
    end
    if !arrayOfValidElements.include?(element)
        raise(RuntimeError, "ERROR: Invalid input. The value '#{element}' is not accepted.")
    end
    return true
end

# Same as verifyInput(), except this function doesn't stop the script if the element isn't found.
# Instead it returns false.
# @return boolean
def inArray(arrayOfValidElements, element, downcase = false)
    if downcase
        element = element.downcase
    end
    if arrayOfValidElements.include?(element)
        return true
    else
        return false
    end
end

# Checks if a String or Integer is a whole Number
# @return boolean
def isWholeNumber(value)
    if value =~ /^\s*\d+\s*$/
        return true
    elsif value.is_a? Integer
        return true
    else
        return false
    end
end

# Get the character at a specific index in a string.
# @return string
def getCharAt(charAt, string)
    if (isWholeNumber(charAt))
        charAt = charAt.to_i
        charAt = (charAt - 1)
        return string[charAt]
    else
        raise(RuntimeError, "The value for CharAt must be a whole number. The script received (#{charAt.class}) #{charAt}.")
    end
end

# Get a Watir Browser object.
# @return [Watir::Browser]
def getBrowser(displays = 'single', headless = false)
    verifyInput(Array['single', 'multiple'], displays)
    browser = Watir::Browser.new(headless == false ? 'chrome' : 'phantomjs')
    if displays == 'single'
        width = 1680
        height = 2000
        x = 0
        y = -0
    elsif displays == 'multiple'
        width = 1920
        height = 2000
        x = 1440
        y = -2000
    end
    browser.window.move_to(x, y)
    browser.window.resize_to(width, height)
    browser.window.use
    return browser
end

# Logs a message in backup/cronlog.txt
# @return void
def cronLog(message = '')
    timestamp = Time.now.strftime('%a %b %d %H:%I:%S %Z %Y')
    File.open('/Users/Albert/Repos/Scripts/backup/cronlog.txt', 'a') { |file| file.write("#{timestamp} - #{message}\n") }
end

# Converts a number to 2 decimal points and adds thousands delimiter.
# @return number
def toCurrency(number, delimiter = ',')
    number = number.to_f
    number = '%.2f' % number
    number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end

# Exits a script and raises a runtime error.
# @return void
def exitScript(msg = 'Something went wrong and the script died. Please check your code.')
    raise(RuntimeError, msg)
end