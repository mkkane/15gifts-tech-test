# Use a recent version of node
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.7.0'
default['nodejs']['binary']['checksum'] = 'abe81b4150917cdbbeebc6c6b85003b80c972d32c8f5dfd2970d32e52a6877af'

# Configure nginx
default['nginx']['default_site_enabled'] = false

# Configure 15gifts
default['15gifts']['app_host'] = '127.0.0.1'
default['15gifts']['app_port'] = '1337'
default['15gifts']['db_host'] = '127.0.0.1'
default['15gifts']['db_port'] = '3306'
default['15gifts']['db_name'] = '15gifts'
default['15gifts']['db_user'] = '15gifts'
default['15gifts']['db_password'] = '15gifts'
default['15gifts']['db_root_password'] = 'root'
default['15gifts']['db_pool_size'] = '20'
