# System packages
node['system']['extra_packages'].each do |pkg|
  package pkg do
    action :upgrade
  end
end

locales node['system']['available_locales']

node['system']['ssh_known_hosts'].each do |known_host|
  ssh_known_hosts_entry known_host
end
