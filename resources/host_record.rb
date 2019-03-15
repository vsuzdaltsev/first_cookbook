resource_name :hosts_record

property :origin,           kind_of:  String
property :domain_name,      kind_of:  String

property :bind_record_type, kind_of:  String,
                            default:  node['first_cookbook']['bind_record_type'],
                            equal_to: %w(a mx cname)

property :api_type,         kind_of:  String,
                            default:  node['first_cookbook']['api_type'],
                            equal_to: %w(hosts bind)

property :mx_weight,        kind_of:  String,
                            default:  node['first_cookbook']['mx_weight']

action_class do
  opts = ResourceHelper.generate_params_hash
  F    = %{FactoryRecord.new(#{opts})}.freeze
end

action :add_record do
  f = instance_eval(F)
  ruby_block 'add_record' do
    block do
      f.add_record
    end
    not_if { f.record_exists? }
  end
end

action :delete_record do
  f = instance_eval(F)
  ruby_block 'delete_record' do
    block do
      f.delete_record
    end
    only_if { f.record_exists? }
  end
end
