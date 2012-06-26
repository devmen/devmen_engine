namespace :modules do
  # Install modules by copying files to corresponding application directories
  desc "Install modules"
  # Modules param should be a string with module names separated by spaces
  task :install, [:modules] => :environment do |t, args|
    modules = module_list(args[:modules])
    puts "Modules to install: #{modules.join(', ')}"

    # Create modules directory in app
    app_modules_path = File.join(Rails.root, "app", "modules")
    unless File.exists?(app_modules_path)
      Dir.mkdir(app_modules_path)
      puts "create: #{app_modules_path.sub Rails.root.to_s, ''}"
    else
      puts "exists: #{app_modules_path.sub Rails.root.to_s, ''}"
    end
    
    modules.each do |module_name|   

      dirs = module_dirs(module_name)
      # Nothing to install
      unless dirs.size
        puts "Can't install module '#{module_name}', there is no module directory"
        next
      end

      dirs.each do |dir|

        dir_full_path = File.join(module_full_path(module_name), dir)

        # It is the directory wich have to create
        if creatable_dir?(dir)
          # Create app dirs
          app_path = module_app_dir_path(module_name, dir)
          unless File.exists?(app_path)
            Dir.mkdir(app_path) unless File.exists?(app_path)
            puts "create: #{app_path.sub Rails.root.to_s, ''}"
          else
            puts "exists: #{app_path.sub Rails.root.to_s, ''}"
          end

          # Copy files to corresponding application directories          
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

        # Check special files, like routes.rb
        else
          # if module routes.rb exists, write its content to application routes.rb
          if dir == 'config' && File.exists?(file = File.join(dir_full_path, "routes.rb"))            
            if module_write_routes module_name, file 
              puts "Routes successfully recorded"
              puts "  change: config/routes.rb"
            else
              puts "Routes recording has failed!"
            end
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

        # It is the directory wich was created
        if creatable_dir?(dir)
          # Remove app dirs
          app_path = module_app_dir_path(module_name, dir)
          if File.exists?(app_path)
            FileUtils.remove_dir(app_path, true)
            puts "remove: #{app_path.sub Rails.root.to_s, ''}"
          else
            puts "no directory: #{app_path.sub Rails.root.to_s, ''}"
          end
        
        # Check special files, like routes.rb
        else
          # if module routes.rb exists, write its content to application routes.rb
          if dir == 'config' && File.exists?(file = File.join(dir_full_path, "routes.rb"))
            res = module_remove_routes module_name, file         
            if res
              puts "Routes successfully removed"
              puts "  change: config/routes.rb"
            elsif res.nil?
              puts "No routes was removed"
            else              
              puts "Routes removing has failed!"
            end
          end          
        end

      end
    end

    # Remove modules directory in app
    app_modules_path = File.join(Rails.root, "app", "modules")
    if File.exists?(app_modules_path)
      FileUtils.remove_dir(app_modules_path, true)
      puts "remove: #{app_modules_path.sub Rails.root.to_s, ''}"
    else
      puts "no directory: #{app_modules_path.sub Rails.root.to_s, ''}"
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
  if !dir.empty?
    File.join(Rails.root, dir, module_name)
  else 
    File.join(Rails.root, 'app', 'modules', module_name)
  end
end

def module_dirs(module_name, recursive = true)
  dirs = []    

  module_path = module_full_path(module_name)
  # Module dirertory doesn't exists 
  return dirs unless File.exists?(module_path)

  # For files exist in module directory directly
  dirs << ""

  path_pattern = recursive ? File.join(module_path, '**', '*') : File.join(module_path, '*')
  Dir[path_pattern].each do |path|    
    next unless File.directory?(path)        
    # dir = Pathname.new(path).relative_path_from(module_path)
    dir = path.sub module_path, ""
    dirs << dir if File.directory?(path)
  end
  dirs.sort
end

def creatable_dir?(dir)
  # Directories where module can create a subdirectory
  available_dirs = [
    'app/controllers',
    'app/controllers/admin',    
    'app/models',
    'app/views',
    'app/views/admin',
    'db/migrate',
    'config/locales/models',
    'config/locales/views',
    'config/locales/views/admin',
    'db/migrate'
  ]

  dir.slice!(0) if dir[0] == '/'
  available_dirs.include?(dir)
end

def module_write_routes(module_name, module_file)
  routes_file = File.join(Rails.root, 'config/routes.rb')
  return false unless File.writable? routes_file

  lines = File.readlines routes_file
  
  start_str = "#{module_name.capitalize} module routes start"
  end_str = "#{module_name.capitalize} module routes end"  

  module_route_lines = File.readlines(module_file)
  module_route_lines.map! { |line| " " * 2 + line }
  module_route_lines.unshift("  # #{start_str}\n").push("\n  # #{end_str}")

  start_pos = lines.index { |str| !str[start_str].nil? }
  end_pos = lines.index { |str| !str[end_str].nil? }
  
  if start_pos.nil? || end_pos.nil? || start_pos > end_pos
    # Insert routes into begin of Application.routes.draw
    draw_pos = lines.index { |str| str =~ /\.routes\.draw/ }
    module_route_lines.unshift("\n").push("\n")
    lines.insert draw_pos + 1, module_route_lines.join('')
  else
    # Replace existing routes
    lines.slice! start_pos, end_pos - start_pos + 1
    lines.insert start_pos, module_route_lines.push("\n").join('')
  end
  
  File.open(routes_file, 'w') do|f| 
    lines.each { |line| f.write line }
  end

  return true
end

def module_remove_routes(module_name)
  routes_file = File.join(Rails.root, 'config/routes.rb')
  return false unless File.writable? routes_file

  lines = File.readlines routes_file
  
  start_str = "#{module_name.capitalize} module routes start"
  end_str = "#{module_name.capitalize} module routes end"  

  start_pos = lines.index { |str| !str[start_str].nil? }
  end_pos = lines.index { |str| !str[end_str].nil? }
 
  if !start_pos.nil? && !end_pos.nil? && start_pos < end_pos
    # Remove existing routes
    lines.slice! start_pos, end_pos - start_pos + 1
    lines.slice!(start_pos) if lines[start_pos].strip.empty?
    
    File.open(routes_file, 'w') do|f| 
      lines.each { |line| f.write line }
    end
    return true
  end

  return nil
end