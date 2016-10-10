# 15Gifts Test App

This repo contains app code (Node.js) and provisioning code (Chef) for
the 15Gifts test.  The app is a simple passphrase generator in the
style of https://www.xkcd.com/936/.

## Getting Started

Just ensure you have Vagrant set up and do a `vagrant up`.  When it's
finished you should be able to see the app at http://127.0.0.1:8080 on
the vagrant host machine.

## The App

As mentioned the app is a basic Node.js app.  Have a look in the
`code` directory to see what it's about.  Note that this dir is also
shared with the dev machine.

Unfortunately, due to time constraints there are no tests for the app!
(I usually use mocha for node.js.)  However there is a linter which
you can run by sshing into the dev machine and doing

    npm run lint

from the `~/code` directory.

## The Ops

As mentioned the ops tool is Chef via Vagrant.  There is a very basic
test suite using Test Kitchen.  To run the tests you'll need the Chef
Development Kit installed, then just do

    kitchen test

from the `ops/cookbooks/15gifts` directory.

## Some notes

### Berkhself

Note, to avoid the need for a Berkshelf plugin to be installed with
vagrant, we include our cookbook dependencies in
`ops/vendored-cookbooks`.  If new dependencies are added to the
Berksfile they should be re-vendored via

    berks vendor --delete  ../../vendored-cookbooks

from the `ops/cookbooks/15gifts` directory.

### Dev only

Note, the cookbook is written with app development in mind...

- Vagrant user is used.
- Application code is mounted from a local directory.
- NPM dev-dependencies are installed by default.
- The node process watches for file changes and restarts automatically.
- MySQL is configured with a weak passwords and listens on all interfaces.

None of this is a good idea unless you're just working locally and
want to get up and running quickly – which is the intention here.
