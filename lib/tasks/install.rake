namespace :modules do
  # Install modules by copying files to corresponding application directories
  desc "Install modules"
  task :install, [:modules] => :environment do |t, args|
    modules = module_list(args[:modules])
    puts modules

    modules.each do |module_name|   

      dirs = module_dirs(module_name)
      # Nothing to install
      next unless dirs.size

      dirs.each do |dir|
        # Create app dirs
        app_path = module_app_dir_path(module_name, dir)
        Dir.mkdir(app_path) unless File.exists?(app_path)
        puts "Create dir: #{app_path}"

        # Copy files to corresponding application directories
        dir_full_path = File.join(module_full_path(module_name), dir)
        Dir[File.join(dir_full_path, '*')].each do |path|
          next unless File.file?(path)
          # file = Pathname.new(path).relative_path_from(dir_full_path)
          file = path.sub dir_full_path, ""
          FileUtils.copy_file path, File.join(app_path, file)
          puts "Copy file\n  from #{path}\n  to #{File.join(app_path, file)}"
        end
      end
    end
  end

  desc "Uninstall modules"
  task :uninstall, [:modules] => :environment do |t, args|
    modules = module_list(args[:modules])
    puts modules

    modules.each do |module_name|
      
      dirs = module_dirs(module_name, false)
      # Nothing to install
      next unless dirs.size

      dirs.each do |dir|
        # Remove app dirs
        app_path = module_app_dir_path(module_name, dir)
        FileUtils.remove_dir(app_path, true) if File.exists?(app_path)
        puts "Remove dir: #{app_path}"
      end
    end
  end 
end

def module_list(string)
  if string
    modules = string.split
  elsif args[:modules].nil? || args[:modules] == 'all'
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