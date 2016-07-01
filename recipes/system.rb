# System packages
package node['system']['extra_packages'] do
  action :upgrade
end

locales node['locales']['available_locales']

node['system']['ssh_known_hosts'].each do |known_host|
  ssh_known_hosts_entry known_host
end

directory '/vagrant' do
  action :create
  mode '0777'
end
