#
# Cookbook:: task1_jboss
# Recipe:: jboss
#

package 'java-1.8.0-openjdk'

package 'unzip'

user node['jboss']['jboss_user'] do
  action :create
end

group node['jboss']['jboss_group'] do
  action :create
  members node['jboss']['jboss_user']
end

remote_file "#{node['jboss']['jboss_path']}/jboss.zip" do
  source node['jboss']['url']
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

execute 'jboss_extract' do
  user 'root'
  cwd node['jboss']['jboss_path']
  command "unzip -o jboss.zip"
  action :run
end

execute 'jboss_install_path' do
  user 'root'
  cwd node['jboss']['jboss_path']
  command "mv /opt/wildfly-14.0.1.Final /opt/wildfly/"
  action :run
end

systemd_unit 'jboss.service' do 
  content <<-EOU
  [Unit]
  Description=WildFly application server
  After=network.target

  [Service]
  Type=simple
  User=web
  Group=web
  Type=forking
  ExecStart=/bin/bash -c '/opt/wildfly/bin/domain.sh'

  [Install]
  WantedBy=multi-user.target
  EOU
  action [ :create, :enable, :start ]
end

remote_file '/opt/wildfly/standalone/deployments/sample.war' do
  source "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  show_progress true
  action :create_if_missing
end
