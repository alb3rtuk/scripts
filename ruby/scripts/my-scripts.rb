require '/Users/Albert/Repos/scripts/ruby/lib/utilities.rb'

# Read contents of ~/.bash_profile into variable.
bashProfile = File.read('/Users/Albert/.bash_profile')

# Hashset of scripts + related information
bashScripts = {}

def getScriptInfo(bashProfile, bashScripts, scriptPath)
    aliasName = File.basename(scriptPath, '.sh')
    folderName = scriptPath.split('/')
    folderName = folderName[folderName.count - 2]

    if bashProfile.include?("alias #{aliasName}=")
        scriptInfo = {}
        scriptInfo['pathName'] = "#{folderName}#{aliasName}";
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

        bashScripts["#{folderName}#{aliasName}"] = scriptInfo

    end

end

# Loop through all the files within the scripts directory and get info.
Dir.glob('/Users/Albert/Repos/scripts/bash/*/**').each do |scriptPath|
    getScriptInfo(bashProfile, bashScripts, scriptPath)
end

# Loop through all the files within the scripts directory and get info.
Dir.glob('/Users/Albert/Repos/nimzo-ruby/scripts/*/**').each do |scriptPath|
    getScriptInfo(bashProfile, bashScripts, scriptPath)
end

# The output string to be displayed in the terminal.
terminalOutput = ''

# Variable to create a new section everytime a new folder is covered.
previousFolder = ''

# Loop through the Script data and compose output string.
bashScripts.sort.map do |scriptkey, scriptData|

    if scriptData['folder'] != previousFolder
        terminalOutput << "\n \x1B[44m #{scriptData['folder'].upcase} \033[0m\n"
        previousFolder = scriptData['folder']
    end

    terminalOutput << "\033[36m\xe2\x86\x92 #{scriptData['name']}\033[0m"

    if scriptData['description'] != nil
        terminalOutput << "\033[37m - #{scriptData['description']}\033[0m"
    else
        terminalOutput << "\033[37m - N/A\033[0m\n"
    end

    if scriptkey
        # DO NOTHING (This is to shut up the IDE)
    end

end

terminalOutput << "\n"

# Output string to temporary file.
File.open('/tmp/my-scripts-output.txt', 'w') { |file| file.write(terminalOutput) }