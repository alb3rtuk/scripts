require 'rubygems'
require 'watir-webdriver'
require 'openssl'

require '/Users/Albert/Repos/Scripts/ruby/lib/browser.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/mysql.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/twitter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities-banks.rb'

# Exits a script and raises a runtime error.
# @return void
def exitScript(msg = 'Something went wrong and the script died. Please check your code.')
    raise(RuntimeError, msg)
end

# Will exit script if element is not contained in arrayOfValidElements.
# @return boolean
def verifyInput(arrayOfValidElements, element, downcase = true)
    if downcase
        element = element.downcase
    end
    if !arrayOfValidElements.include?(element)
        exitScript("ERROR: Invalid input. The value '#{element}' is not accepted.")
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
        exitScript("Value passed must be a string or integer that represents a WHOLE NUMBER. You passed (#{value.class}) #{value}.")
    end
end

# Get the character at a specific index in a string.
# @return string
def getCharAt(charAt, string)
    if(isWholeNumber(charAt))
        charAt = charAt.to_i
        charAt = (charAt - 1)
        return string[charAt]
    end
end
