require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

controllerPath = ARGV[0].sub(/^[\/]*/, '').sub(/(\/)+$/, '')
controllerType = ARGV[1]
action = ARGV[2]
controllerFileUpperCase = ''
controllerFileLowerCase = ''
pathToRepo = '/Users/Albert/Repos/Nimzo/httpdocs'
error = false
filesToDelete = Array.new
dirsToDelete = Array.new

puts

unless inArray(%w(modal overlay page widget), controllerType)
    exitScript("'#{controllerType}' is not a valid Controller Type.")
end

unless inArray(%w(create delete), action)
    exitScript("'#{action}' is not a valid Action.")
end

case controllerType
    when 'modal'
        pathToPrivate = "#{pathToRepo}/private/ajax/v1/modal"
        pathToPublicDev = "#{pathToRepo}/public/dev/ajax/v1/modal"
        pathToPublicMin = "#{pathToRepo}/public/min/ajax/v1/modal"
    when 'overlay'
        pathToPrivate = "#{pathToRepo}/private/ajax/v1/overlay"
        pathToPublicDev = "#{pathToRepo}/public/dev/ajax/v1/overlay"
        pathToPublicMin = "#{pathToRepo}/public/min/ajax/v1/overlay"
    when 'page'
        pathToPrivate = "#{pathToRepo}/private/app/v1"
        pathToPublicDev = "#{pathToRepo}/public/dev/app/v1"
        pathToPublicMin = "#{pathToRepo}/public/min/app/v1"
    when 'widget'
        pathToPrivate = "#{pathToRepo}/private/ajax/v1/widget"
        pathToPublicDev = "#{pathToRepo}/public/dev/ajax/v1/widget"
        pathToPublicMin = "#{pathToRepo}/public/min/ajax/v1/widget"
    else
        exit
end

unless isAlphaNumeric(controllerPath.gsub('/', ''))
    error = true
    puts "\x1B[41m ERROR \x1B[0m Name must be alphanumeric and contain only slashes ('/'). You passed: \x1B[33m#{controllerPath}\x1B[0m"
end

# Get controller filename from path.
controllerPath.split('/').each { |name|
    controllerFileUpperCase = "#{name.slice(0, 1).capitalize + name.slice(1..-1)}"
    controllerFileLowerCase = name
}

# PHP Controller
file1 = "#{pathToPrivate}/controllers/#{controllerPath}/#{controllerFileUpperCase}.php"
if fileExists?(file1)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A private file already exists: \x1B[33m#{file1.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        filesToDelete.push(file1)
    end
end
# PHTML View
file2 = "#{pathToPrivate}/views/#{controllerPath}/#{controllerFileUpperCase}.phtml"
if fileExists?(file2)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A private file already exists: \x1B[33m#{file2.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        filesToDelete.push(file2)
    end
end
# PHP Helper Path
dir1 = "#{pathToPrivate}/helpers/#{controllerPath}"
if directoryExists?(dir1)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A private file already exists: \x1B[33m#{dir1.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        dirsToDelete.push(dir1)
    end
end
# Public DEV .js
file3 = "#{pathToPublicDev}/#{controllerPath}/#{controllerFileLowerCase}.js"
if fileExists?(file3)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A public  file already exists: \x1B[33m#{file3.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        filesToDelete.push(file3)
    end
end
# Public DEV .less
file4 = "#{pathToPublicDev}/#{controllerPath}/#{controllerFileLowerCase}.less"
if fileExists?(file4)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A public  file already exists: \x1B[33m#{file4.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        filesToDelete.push(file4)
    end
end
# Public MIN .min.js
file5 = "#{pathToPublicMin}/#{controllerPath}/#{controllerFileLowerCase}.min.js"
if fileExists?(file5)
    if action == 'create'
        error = true
        puts "\x1B[41m ERROR \x1B[0m A public  file already exists: \x1B[33m#{file5.gsub("#{pathToRepo}/", '')}\x1B[0m"
    elsif action == 'delete'
        filesToDelete.push(file5)
    end
end

# If we're deleting files, this makes sure we do not miss the parent directories.
if action == 'delete'
    filesToCleanse = [file1, file2, file3, file4, file5]
    filesToCleanse.each { |file|
        if directoryExists?(File.dirname(file))
            dirsToDelete.push(File.dirname(file))
        end
    }
end


# Abort if error occured (IE: A file/dir already exists).
if error
    puts "        \x1B[90mScript aborted.\x1B[0m"
    puts
    exit
end

if action == 'delete'
    allEmpty = true
    unless dirsToDelete.empty?
        allEmpty = false
        dirsToDelete.each { |dir| puts "\x1B[31m#{dir}\x1B[0m" }
        unless filesToDelete.empty?
            puts
        end
    end
    unless filesToDelete.empty?
        allEmpty = false
        filesToDelete.each { |file| puts "\x1B[31m#{file}\x1B[0m" }
    end
    if allEmpty === false
        STDOUT.flush
        puts
        print "\x1B[41m WARNING \x1B[0m \x1B[90mYou're about to \x1B[0mCOMPLETELY\x1B[90m remove these files/directories. Are you sure you want to continue? [y/n]\x1B[0m => "
        continue = STDIN.gets.chomp
        if continue != 'y' && continue != 'Y'
            puts "          \x1B[90mScript aborted.\x1B[0m"
            puts
            exit
        end
        puts
    else
        puts "\x1B[44m ABORTING \x1B[0m This #{controllerType} has either already been deleted or doesn't exist. Aborting script."
        puts
        exit
    end
end

actionTitle = ((action == 'create') ? "\x1B[44m CREATED \x1B[0m" : "\x1B[41m DELETED \x1B[0m")
actionResult = ((action == 'create') ? "\x1B[32mcreated\x1B[0m" : "\x1B[31mdeleted\x1B[0m")

# Excecute the action.
if action == 'create'
    # PHP Controller
    FileUtils::mkpath(File.dirname(file1))
    File::new(file1, 'w')

    # PHTML View
    FileUtils::mkpath(File.dirname(file2))
    File::new(file2, 'w')

    # PHP Helper Path
    FileUtils::mkdir_p(dir1)

    # Public DEV .js
    FileUtils::mkpath(File.dirname(file3))
    File::new(file3, 'w')

    # Public DEV .less
    FileUtils::mkpath(File.dirname(file4))
    File::new(file4, 'w')

    # Public MIN .min.js
    FileUtils::mkpath(File.dirname(file5))
    File::new(file5, 'w')

    puts "#{actionTitle} \x1B[90m#{dir1}\x1B[0m"
    puts "#{actionTitle} \x1B[33m#{file1}\x1B[0m"
    puts "#{actionTitle} \x1B[33m#{file2}\x1B[0m"
    puts "#{actionTitle} \x1B[33m#{file3}\x1B[0m"
    puts "#{actionTitle} \x1B[33m#{file4}\x1B[0m"
    puts "#{actionTitle} \x1B[33m#{file5}\x1B[0m"

elsif action == 'delete'
    unless dirsToDelete.empty?
        dirsToDelete.each { |dir|
            FileUtils.rm_rf(dir)
            puts "#{actionTitle} \x1B[33m#{dir}\x1B[0m"
        }
        unless filesToDelete.empty?
            puts
        end
    end
    unless filesToDelete.empty?
        filesToDelete.each { |file|
            FileUtils.rm_rf(file)
            puts "#{actionTitle} \x1B[33m#{file}\x1B[0m"
        }

    end
end

puts
puts "\x1B[42m SUCCESS \x1B[0m The #{controllerType}: \x1B[35m#{controllerPath}\x1B[0m (and all its dependices) were successfully #{actionResult}."
puts