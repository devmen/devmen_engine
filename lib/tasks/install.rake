namespace :modules do
  # Install modules by copying files to corresponding application directories
  desc "Install modules"
  # Modules param should be a string with module names separated by spaces
  task :install, [:modules] => :environment do |t, args|
    modules = module_list(args[:modules])
    puts "Modules to install: #{modules.join(', ')}"
    
    modules.each do |module_name|   

      dirs = module_dirs(module_name)
      # Nothing to install
      unless dirs.size
        puts "Can't install module '#{module_name}', there is no module directory"
        next
      end

      dirs.each do |dir|
        # Create app dirs
        app_path = module_app_dir_path(module_name, dir)
        unless File.exists?(app_path)
          Dir.mkdir(app_path) unless File.exists?(app_path)
          puts "create: #{app_path.sub Rails.root.to_s, ''}"
        else
          puts "exists: #{app_path.sub Rails.root.to_s, ''}"
        end

        # Copy files to corresponding application directories
        dir_full_path = File.join(module_full_path(module_name), dir)
        Dir[File.join(dir_full_path, '*')].each do |path|
          next unless File.file?(path)
          # file = Pathname.new(path).relative_path_from(dir_full_path)
          file = path.sub dir_full_path, ""
          app_file_path = File.join(app_path, file)
          unless File.exists?(app_file_path)
            FileUtils.copy_file path, app_file_path
            puts "  create: #{app_file_path.sub Rails.root.to_s, ''}"
          else
            puts "  exists: #{app_file_path.sub Rails.root.to_s, ''}"
          end
        end
      end
    end
  end

  desc "Uninstall modules"
  task :uninstall, [:modules] => :environment do |t, args|
    modules = module_list(args[:modules])
    puts "Modules to uninstall: #{modules.join(', ')}"

    modules.each do |module_name|
      
      dirs = module_dirs(module_name)
      # Nothing to uninstall
      unless dirs.size
        puts "Can't uninstall module '#{module_name}', there is no module directory"
        next
      end

      dirs.each do |dir|
        # Remove app dirs
        app_path = module_app_dir_path(module_name, dir)
        if File.exists?(app_path)
          FileUtils.remove_dir(app_path, true)
          puts "remove: #{app_path.sub Rails.root.to_s, ''}"
        else
          puts "no directory: #{app_path.sub Rails.root.to_s, ''}"
        end
      end
    end
  end 
end

def module_list(string)
  modules = string.split if string and string != 'all'
  
  if modules && modules.size
    modules = modules.select { |m| MODULES.include? m }
  else
    modules = MODULES
  end

  modules
end

def module_full_path(module_name)
  File.join(Rails.root, "lib", "modules", module_name)
end

def module_app_dir_path(module_name, dir)
  File.join(Rails.root, 'app', dir, module_name)
end

def module_dirs(module_name, recursive = true)
  dirs = []    

  module_path = module_full_path(module_name)
  # Module dirertory doesn't exists 
  return dirs unless File.exists?(module_path)
  
  path_pattern = recursive ? File.join(module_path, '**', '*') : File.join(module_path, '*')
  Dir[path_pattern].each do |path|    
    next unless File.directory?(path)        
    # dir = Pathname.new(path).relative_path_from(module_path)
    dir = path.sub module_path, ""
    dirs << dir if File.directory?(path)   
  end
  dirs
end