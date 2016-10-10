# # encoding: utf-8

# Inspec test for recipe 15gifts::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe service('mysql') do
  it { should be_installed }
end

describe port(3306) do
  it { should be_listening }
end

describe service('15gifts') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(1337) do
  it { should be_listening }
end
