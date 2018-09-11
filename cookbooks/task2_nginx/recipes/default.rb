#
# Cookbook:: task2_nginx
# Recipe:: nginx
#

package 'nginx'

template '/etc/nginx/conf.d/jboss.conf' do
  source 'jboss.conf.erb'
  variables(
    jboss_ip: search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
    jboss_port: node['jboss']['port'],
    jboss_app: node['jboss']['path'],
    nginx_port: node['nginx']['port'])
end

template '/usr/share/nginx/html/info.html' do
  source 'info.html.erb'
  variables(info: search(:nginx, 'id:nginx_item')[0]['key'])
end

service 'nginx' do
  action [ :enable, :start ]
end 