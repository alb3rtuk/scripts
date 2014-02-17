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
    echo "`tput setab 1` Script was aborted! `tput setab 0`"
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

# SETUP RUBY SCRIPT
echo "require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'" > ${ruby_script}
echo "require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'" >> ${ruby_script}

echo
echo "Launchd job skeleton created but \033[31mNOT REGISTERED!\033[0m"
echo "Remember to run `tput setab 3` update-launchd `tput setab 0` after setting up the job to register it with the system."
echo
exit