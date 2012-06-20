namespace :modules do
  desc "Install modules"
  task :install => :environment do
    # do modules installation
    MODULES.each do |m|
      puts m
      continue unless Dir.exists?(File.expand_path("../modules/#{m}", __FILE__))
    end
  end
end