name '15gifts'
maintainer 'Michael Kane'
maintainer_email 'michael@mkkorp.com'
license 'all_rights'
description 'Installs/Configures a dev environment forthe 15gifts app'
long_description 'Installs/Configures a dev environment for the 15gifts app'
version '0.1.0'

recipe '15gifts::default', 'Installs/Configures a dev environment for the 15gifts app'

depends 'chef_nginx'
depends 'mysql'
depends 'nodejs'

supports 'ubuntu'

chef_version '>= 12.1'
