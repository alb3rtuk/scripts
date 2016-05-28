directory = File.expand_path('~/Repos/nimzo-ruby/auto-sql/data')

Dir["#{directory}/**/*"].each do |file|
    command = "mv #{file} #{file.gsub('_', '-')}"
    # `#{command}`
    puts command
end
