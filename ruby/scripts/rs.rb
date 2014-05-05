require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require 'rubygems'
require 'appscript'

# Display list of system commands that can be run.
systemEvenets = Appscript.app('System Events')
systemEvenets.methods.each { |method| puts method }
