resourсe_name :app_deploy

property :version, String, default: '0.1.0'
property :file, String, required: true
property :path, String, required: true
property :link, String, required: true

default_action :deploy

load_current_value version

action :deploy do
	converge_if_changed :version do
		remote_file "#{new_resource.path}/#{new_resource.file}" do
			source "#{new_resource.link}"
			owner node['jboss']['jboss_user']
			group node['jboss']['jboss_group']
			show_progress true
			action :create_if_missing
		end
	end
end