require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

# Read contents of ~/.bash_profile into variable.
bashProfile = File.read('/Users/Albert/.bash_profile')

# Array of scripts + related information
bashScripts = Array.new

# Loop through all the files within the scripts directory and get info.
Dir.glob('/Users/Albert/Repos/Scripts/bash/*/**').each do |scriptPath|
    aliasName = File.basename(scriptPath, '.sh')
    folderName = scriptPath.split('/')
    folderName = folderName[folderName.count - 2]

    if bashProfile.include?("alias #{aliasName}=")
        scriptInfo = {}
        scriptInfo['name'] = aliasName
        scriptInfo['folder'] = folderName
        scriptInfo['description'] = nil

        # Loop through the script and find the first comment.
        file = File.open(scriptPath)
        file.each_line do |line|
            if line.include?('# ')
                scriptInfo['description'] = line[2..-1]
                break
            end
        end

        bashScripts << scriptInfo

    end
end

# The output string to be displayed in the terminal.
terminalOutput = ''

# Variable to create a new section everytime a new folder is covered.
previousFolder = ''

# Loop through the Script data and compose output string.
bashScripts.each do |scriptData|

    if scriptData['folder'] != previousFolder

        terminalOutput << "\033[33
m#{scriptData['folder'].upcase}\033[0m\n\n"
        previousFolder = scriptData['folder']
    end

    terminalOutput << "
\033[36m\xe2\x86\x92 #{scriptData['name']}\033[0m"

    if scriptData['description'] != nil
        terminalOutput << "\033[37m - #{scriptData['description']}\033[0m"
    else
        terminalOutput << "\033[37m - N/A\033[0m\n"
    end

end

terminalOutput << "\n"

# Output string to temporary file.
File.open('/tmp/my-scripts-output.txt', 'w') { |file| file.write(terminalOutput) }