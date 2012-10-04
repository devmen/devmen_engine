# Load modules parametrs into CFG

ym = YAML.load_file("#{::Rails.root}/config/modules.yml")

CFG = Hash.new
MODULES = CFG['modules'] = ym['modules'] || []
MODULES.each do |mod|
  # Create module const
  # Object.const_set(mod.camelize.to_sym, Module.new)

  CFG[mod] = ym[mod] if ym[mod]
  if CFG[mod] && ym[Rails.env]
    ym[Rails.env].each do |m, params|
      CFG[mod].merge params
    end
  end
end

# Add app/modules dir and all subdirs to load paths
# Somehow this code don't require module files
# DevmenEngine::Application.config.autoload_paths += Dir[File.join(Rails.root, "app", "modules", '{**}')]
# Use this code to require module files explicitly
Rails.application.config.before_initialize do
  Dir[File.join(Rails.root, "app", "modules", '**', '*.rb')].each { |modfile| require modfile }
end

