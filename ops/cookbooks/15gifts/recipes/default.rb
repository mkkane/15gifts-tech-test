#
# Cookbook Name:: 15gifts
# Recipe:: default
#
# Copyright (c) 2016 Michael Kane, All Rights Reserved.

# Set up a mysql server
mysql_service '15gifts' do
  port node['15gifts']['db_port']
  version '5.5'
  initial_root_password node['15gifts']['db_root_password']
  action [:create, :start]
end

# Set up a mysql client for helping with local dev
mysql_client 'default' do
  action :create
end

# Initialise a db
template '/tmp/init.sql' do
  source 'mysql_init.sql.erb'
end

execute 'create db and user' do
  command "mysql -h'#{node['15gifts']['db_host']}' -u'root' -p'#{node['15gifts']['db_root_password']}' < /tmp/init.sql"
  not_if "mysql -h'#{node['15gifts']['db_host']}' -u'#{node['15gifts']['db_user']}' -p'#{node['15gifts']['db_password']}' -D'#{node['15gifts']['db_name']}' -e 'SELECT 1 + 1'"
end

# Populate db with data
cookbook_file '/tmp/words.txt' do
  source 'words.txt'
end

execute 'populate db' do
  command "mysqlimport -h'#{node['15gifts']['db_host']}' -u'root' -p'#{node['15gifts']['db_root_password']}' --local 15gifts /tmp/words.txt"
  only_if "mysql -h'#{node['15gifts']['db_host']}' -u'#{node['15gifts']['db_user']}' -p'#{node['15gifts']['db_password']}' -D'#{node['15gifts']['db_name']}' -e 'SELECT count(*) FROM words' | grep '\\b0\\b'"
end


# Set up nginx
include_recipe 'chef_nginx'

# Enable reverse-proxy to nodejs
template "#{node['nginx']['dir']}/sites-available/15gifts.conf" do
  source 'nginx_15gifts.conf.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

link "#{node['nginx']['dir']}/sites-enabled/15gifts.conf" do
  to "#{node['nginx']['dir']}/sites-available/15gifts.conf"
  notifies :reload, 'service[nginx]', :delayed
end


# Set up nodejs
include_recipe 'nodejs'

# Ensure we install our npm dependencies
execute "install NPM packages" do
  cwd '/home/vagrant/code'
  command 'npm install'
end

# Set up the app
template '/home/vagrant/code/.env' do
  source 'app_env.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  notifies :reload, 'service[15gifts]', :delayed
end

# Ensure our app can run as a service
template '/etc/init/15gifts.conf' do
  source 'init_15gifts.conf.erb'
  notifies :reload, 'service[15gifts]', :delayed
end

link '/etc/init.d/15gifts' do
  to '/lib/init/upstart-job'
end

service '15gifts' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
