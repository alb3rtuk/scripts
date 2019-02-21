#!/usr/bin/env ruby

require 'blufin-lib'

file = '/Users/Albert/Repos/repos-blufin/skybutler/java/skybutler-api/src/main/java/io/skybutler/api/model/app/SaleModel.java'

Blufin::Files::read_file(file).each do |line|

    puts "                        content << \"#{line}\"".gsub("\n", '')

end