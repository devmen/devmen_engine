# Load modules parametrs into CFG

ym = YAML.load_file("#{::Rails.root}/config/modules.yml")

cfg = Hash.new
MODULES = cfg['modules'] = ym['modules']
MODULES.each do |mod|
  cfg[mod] = ym[mod] if ym[mod]
  if cfg[mod] && ym[Rails.env]
    env_cfg = ym[Rails.env]
    env_cfg.each do |m, params|
      cfg[mod].merge params
    end
  end
end

CFG = cfg