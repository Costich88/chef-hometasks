# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "costich88"
client_key               "#{current_dir}/costich88.pem"
chef_server_url          "https://api.chef.io/organizations/storksoft"
cookbook_path            ["#{current_dir}/../cookbooks"]
validation_client_name   "storksoft-validator"
validation_key           "#{current_dir}/storksoft-validator.pem"
knife[:editor] = 'vim'
