#
# Cookbook:: task2_nginx
# Recipe:: nginx
#

nginx_install "custom" do
  version node['nginx']['version']
  port node['nginx']['port']
  proxy_port node['jboss']['port']
  jboss_ip { search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first }
  jboss_app node['jboss']['path']
end