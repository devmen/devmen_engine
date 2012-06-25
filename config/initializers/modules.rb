# Load modules parametrs into CFG

ym = YAML.load_file("#{::Rails.root}/config/modules.yml")

cfg = Hash.new
MODULES = cfg['modules'] = ym['modules'] || []
MODULES.each do |mod|
  # Create module const
  # Object.const_set(mod.camelize.to_sym, Module.new)

  cfg[mod] = ym[mod] if ym[mod]
  if cfg[mod] && ym[Rails.env]
    env_cfg = ym[Rails.env]
    env_cfg.each do |m, params|
      cfg[mod].merge params
    end
  end
end

CFG = cfg

# Add app/modules dir and all subdirs to load paths
# Somehow this code don't require module files
# DevmenEngine::Application.config.autoload_paths += Dir[File.join(Rails.root, "app", "modules", '{**}')]
# Use this code to require module files explicitly 
Rails.application.config.before_initialize do
  Dir[File.join(Rails.root, "app", "modules", '**', '*.rb')].each { |modfile| require modfile }
end

