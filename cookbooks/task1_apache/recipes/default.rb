#
# Cookbook:: task1_apache
# Recipe:: werbserver
#

package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

package 'php' do
  action :install
  notifies :restart, "service[httpd]"
end

file '/var/www/html/info.php' do
  content '<?php
	phpinfo();
  ?>'
end