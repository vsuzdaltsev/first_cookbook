default['first_cookbook'].tap do |first_cookbook|
  first_cookbook['network_prefix']   = '10.7.1'
  first_cookbook['domain']           = 'ololo.net'
  first_cookbook['hosts_file']       = '/tmp/my_hosts_file_from_attrs'
  first_cookbook['bind_file']        = '/tmp/my_bind_file_from_attrs'
  first_cookbook['bind_record_type'] = 'a'
  first_cookbook['api_type']         = 'hosts'
  first_cookbook['mx_weight']        = ''
end
