require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require 'rubygems'
require 'appscript'

include Appscript

# Display list of system commands that can be run.
systemEvenets = Appscript.app('System Events')
systemEvenets.methods.each { |method| puts method }

# This is how you would run Command + K (in Terminal)
app('System Events').key_code(40, :using => [:command_down])
