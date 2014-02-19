require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

file = ARGV[0]
version = newVersion = false

if file.nil?
    exitScript('No parameter was passed.')
end

File.open(file) do |file_handle|
    file_handle.each_line do |line|
        param = line.split(' ')
        if param[0].downcase == 'version'
            version = param[1][1..-2]
            versionSplit = version.split('.')
            versionLast = (versionSplit[2].to_i) + 1
            newVersion = "#{versionSplit[0]}.#{versionSplit[1]}.#{versionLast}"
        end
    end
end

if newVersion
    content = File.read(file)
    newContent = content.gsub(/#{version}/, "#{newVersion}")
    File.open(file, 'w') { |file| file.write(newContent) }
    puts "\x1B[36mChanged cookbook version to: \x1B[0m\x1B[32m#{newVersion}\x1B[0m"
end