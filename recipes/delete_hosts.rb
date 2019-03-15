prefix = node['first_cookbook']['network_prefix']
domain = node['first_cookbook']['domain']

(1..10).each do |i|
  hosts_record  "hosts_record_#{prefix}.#{i}" do
    origin      "#{prefix}.#{i}"
    domain_name "node#{i}.#{domain}"
    action      :delete_record
    api_type    'hosts'
  end
end
