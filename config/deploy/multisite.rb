@stages_from_yaml = YAML.load_file(File.join(Dir.pwd, 'config', 'deploy', 'sites.yml'))

def load_config_for_stage(stage_name)
  config = @stages_from_yaml
  config[stage_name.to_s].each do |hash_key, hash_value|
    if hash_key =~ /after_tasks/
      # puts "Setting After() Callback after(#{hash_key.to_s}, #{hash_value.to_s})"
      after(hash_key.to_s, hash_value.to_s)
    elsif hash_key =~ /before_tasks/
      # puts "Setting Before() Callback before(#{hash_key.to_s}, #{hash_value.to_s})"
      before(hash_key.to_s, hash_value.to_s)
    elsif hash_key =~ /roles/
      hash_value.each do |role_key, role_value|
        role(role_key.to_sym, role_value.to_s)
      end
    else
      set(hash_key.to_sym, hash_value.to_s)
    end
  end
end

@stages_from_yaml.keys.each do |stage|
  code = <<-EOB
    desc "Set up and load config from YAML for the #{stage} stage."
    task :#{stage} do 
      puts "Loading stage: #{stage}"
      # This method *actually* runs after the load statement below, 
      # but it is defined here, and called here, so that the variables 
      # exist before capistrano gets that far!
      load_config_for_stage('#{stage.to_s}')
      
      # Load the settings
      config.prepare
    end 
  EOB
  
  eval(code)
end
