#!/usr/bin/env ruby

require 'nimzo-lib'

file = '/Users/Albert/Repos/repos-nimzo/skybutler/java/skybutler-api/src/main/java/io/skybutler/api/model/app/SaleModel.java'

Nimzo::Files::read_file(file).each do |line|

    puts "                        content << \"#{line}\"".gsub("\n" , '')

end