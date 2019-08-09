require 'rubygems'
require 'rainbow'
require 'command_line_reporter'
require 'watir-webdriver'
require 'time'
require 'fileutils'
require 'date'
require 'mysql2'
require 'yaml'
require 'open-uri'
require 'net/http'
require 'csv'
require File.expand_path('~/Repos/blufin-secrets/secrets.rb')
require File.expand_path('~/Repos/scripts/ruby/lib/encryptor.rb')

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

# Gets all the indexes of a hash in an array
# Currently doesn't validate if it's a Hash or not.
# @return Array|boolean
def getKeysInHash(hash)
    response = Array.new
    hash.each_key { |key| response << key }
    response
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

# Logs a message in config/cronlog.log
# @return void
def cronLog(message = '')
    timestamp = Time.now.strftime('%a %b %e %H:%M:%S %Z %Y')
    File.open('/Users/Albert/Repos/scripts/config/cronlog.log', 'a') { |file| file.write("#{timestamp} - #{message}\n") }
end

# Converts a number to 2 decimal points and adds thousands delimiter + currency symbol.
# @return string
def toCurrency(number, symbol = '£', delimiter = ',')
    number = number.to_f
    minus  = (number < 0) ? '-' : ''
    number = '%.2f' % number.abs
    number = number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
    "#{minus}#{symbol}#{number}"
end

# Removes the '£' sign and any ',' delimiters from a string
# @return float
def cleanCurrency(string)
    if string.include? '£'
        string = string.delete('£')
    end
    if string.include? ','
        string = string.delete(',')
    end
    string.to_f
end

# Calculates how many days between 2 dates (must be in 2013-10-29 format).
def diffBetweenDatesInDays(laterDate = nil, earlierDate = nil)
    dates = Array[earlierDate, laterDate]
    dates.map! { |date|
        if date == nil
            today = DateTime.now
            today.strftime('%y-%m-%d')
        else
            explodedDate = date.split('-')
            date         = DateTime.new(explodedDate[0].to_i, explodedDate[1].to_i, explodedDate[2].to_i)
            date.strftime('%y-%m-%d')
        end
    }
    earlierDate = Date.parse(dates[0])
    laterDate   = Date.parse(dates[1])
    laterDate.mjd - earlierDate.mjd
end

# Exits a script and raises a runtime error.
# @return void
def exitScript(msg = 'Something went wrong and the script died. Please check your code.')
    raise(RuntimeError, msg)
end

# Checks wheather a directory exists. Directory must be passed from root (IE: /Users/Albert/Repos/...)
# @return boolean
def directoryExists?(directory)
    File.directory?(directory)
end

# Checks wheather a directory exists. Directory must be passed from root (IE: /Users/Albert/Repos/...)
# @return boolean
def fileExists?(file)
    File.file?(file)
end

# Writes whatever string you pass it, to file you specify.
# @return void
def writeDataToFile(string = '', file = '/tmp/tmpfile.txt')
    File.open(file, 'w') { |fileResource| fileResource.write(string) }
end

# Returns TRUE if a string is alpha-numeric, FALSE if not.
# @return boolean
def isAlphaNumeric(string)
    ((string =~ /\A[[:alnum:]]+\z/) == 0) ? true : false
end

# Returns time ago in human readble format.
# @string
def getTimeAgoInHumanReadable(timeStamp)
    secondsAgo = getSecondsAgo(timeStamp)
    secondsAgo = secondsAgo.to_f
    case secondsAgo
        when 1..59
            return 'Less than a minute ago'
        when 60..119
            return 'A minute ago'
        when 120..2999
            return "#{(secondsAgo / 60).round} minutes ago"
        when 3000..5399
            return 'About an hour ago'
        when 5399..86399
            return "#{((secondsAgo / 60) / 60).round} hours ago"
        when 86400..169999
            return 'A day ago'
        when 170000..2505599
            return "#{(((secondsAgo / 24) / 60) / 60).round} days ago"
        when 2600000..4000000
            return 'A month ago'
        when 4000001..31535999
            return "#{((((secondsAgo / 30.4368) / 24) / 60) / 60).round} months ago"
        when 31536000..47303999
            return 'A year ago'
        when 47304000..9999999999999
            return "#{((((secondsAgo / 365) / 24) / 60) / 60).round} years ago"
        else
            return 'Out of range'
    end
end

# Returns the number of seconds that have elapsed between a timestamp (0000-00-00T00:00:00+00:00) and now
# @return integer
def getSecondsAgo(timeStamp)
    timeStamp = DateTime.strptime(timeStamp, '%Y-%m-%dT%H:%M:%S%z')
    timeNow   = DateTime.now
    ((timeNow - timeStamp) * 24 * 60 * 60).to_i
end

# Returns a formatted of a timestamp. Numerous formats.
# 1) 26-08-2014 02:53
# @return string
def formatTimestamp(timeStamp, format = 1)
    dateFormatted = DateTime.strptime(timeStamp, '%Y-%m-%dT%H:%M:%S%z')
    case format
        when 1
            return dateFormatted.strftime('%d-%m-%Y %H:%M')
    end
end

# Checks if internet connection is present
# @return boolean|void
def checkMachineIsOnline
    begin
        true if open('http://www.google.com')
    rescue
        puts "\x1B[41m ERROR \x1B[0m No internet connection found."
        exit
    end
end

# Removes line-breaks from a string and replaces them with a space ' '.
# @return string
def replaceLineBreaks(string, replacementString = ' ')
    if string.include? "\n"
        string = string.gsub!(/[\n]+/, replacementString)
    end
    string
end
