#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Scripts/

job_name=$1

if [[ ${job_name} == "" ]]; then
    message red "ERROR" "\$job_name cannot be blank."
    exit
fi

read -p "`echo "\033[0mYour job will be called \033[35m[\033[0m \033[33malbert.${job_name}\033[0m \033[35m]\033[0m Would you like to continue? \033[32m[y/n]\033[0m \033[37m=>\033[0m "`" -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "`tput setab 1` SCRIPT WAS ABORTED `tput setab 0`"
    exit
fi

shell_script="/Users/Albert/Repos/Scripts/bash/launchd/albert.${job_name}.sh"
ruby_script="/Users/Albert/Repos/Scripts/ruby/launchd/albert.${job_name}.rb"
launchd_script="/Users/Albert/Repos/Scripts/launchd/albert.${job_name}.plist"

touch ${shell_script}
touch ${ruby_script}
touch ${launchd_script}

git add .

# SETUP SHELL SCRIPT
chmod 0755 ${shell_script}
echo "#!/bin/sh\n" > ${shell_script}
echo ". ~/Repos/Scripts/bash/common/utilities.sh\n" >> ${shell_script}
echo "logCron \"Launchd job: 'albert.${job_name}' started.\"\n" >> ${shell_script}
echo "ruby ~/Repos/Scripts/ruby/launchd/albert.${job_name}.rb" >> ${shell_script}
echo "exit" >> ${shell_script}

# SETUP RUBY SCRIPT
echo "require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'" > ${ruby_script}
echo "require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'" >> ${ruby_script}

# SETUP LAUNCHD.PLIST FILE
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > ${launchd_script}
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> ${launchd_script}
echo "<plist version=\"1.0\">" >> ${launchd_script}
echo "    <dict>\n" >> ${launchd_script}
echo "        <key>Label</key>" >> ${launchd_script}
echo "        <string>albert.${job_name}</string>\n" >> ${launchd_script}
echo "        <key>Program</key>" >> ${launchd_script}
echo "        <string>/Users/Albert/Repos/Scripts/bash/launchd/albert.${job_name}.sh</string>\n" >> ${launchd_script}
echo "        <key>StartCalendarInterval</key>" >> ${launchd_script}
echo "        <dict>" >> ${launchd_script}
echo "            <key>Minute</key>" >> ${launchd_script}
echo "            <integer>30</integer>" >> ${launchd_script}
echo "            <key>Hour</key>" >> ${launchd_script}
echo "            <integer>3</integer>" >> ${launchd_script}
echo "            <key>Day</key>" >> ${launchd_script}
echo "            <integer>1</integer>" >> ${launchd_script}
echo "        </dict>\n" >> ${launchd_script}
echo "        <key>StandardOutPath</key>" >> ${launchd_script}
echo "        <string>/Users/Albert/Repos/Scripts/backup/cronerror.log</string>" >> ${launchd_script}
echo "        <key>StandardErrorPath</key>" >> ${launchd_script}
echo "        <string>/Users/Albert/Repos/Scripts/backup/cronerror.log</string>\n" >> ${launchd_script}
echo "        <key>KeepAlive</key>" >> ${launchd_script}
echo "        <false/>\n" >> ${launchd_script}
echo "        <key>RunAtLoad</key>" >> ${launchd_script}
echo "        <false/>\n" >> ${launchd_script}
echo "    </dict>" >> ${launchd_script}
echo "</plist>" >> ${launchd_script}

# OUTPUT CONFIRMATION TO TERMINAL
echo
echo "Launchd job skeleton \033[32mCREATED SUCCESSFULLY\033[0m but \033[31mNOT REGISTERED!\033[0m"
echo "Remember to run `tput setab 3` update-launchd `tput setab 0` after setting up the job to register it with the system."
echo
exit