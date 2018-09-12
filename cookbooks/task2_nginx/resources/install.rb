resource_name :nginx_install

property :version, String, default: '1.14.0'
property :port, String, default: '80'
property :proxy_port, String, default: '8080'
property :source, String, default: lazy { |r| "https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-#{r.version}-1.el7_4.ngx.x86_64.rpm" }
property :jboss_ip, String, required: true
property :jboss_app, String, required: true

default_action :install

action :install do
  remote_file "/tmp/nginx-#{new_resource.version}-1.el7.ngx.x86_64.rpm" do
    source "#{new_resource.source}"
  end

  rpm_package "/tmp/nginx-#{new_resource.version}-1.el7.ngx.x86_64.rpm" do
    action :install
  end

  template '/etc/nginx/conf.d/jboss.conf' do
    source 'jboss.conf.erb'
    variables(jboss_ip: new_resource.jboss_ip,
              nginx_port: new_resource.port,
              port_jboss: new_resource.proxy_port,
              jboss_app: new_resource.jboss_app)
  end

  template '/usr/share/nginx/html/info.html' do
    source 'info.erb'
    variables(info: search(:nginx, 'id:nginx_item')[0]['key'])
  end

  service 'nginx' do
    action [:enable, :start]
  end

end