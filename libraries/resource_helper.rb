require_relative 'record'

# Generate parameters hash
# to pass it to a FactoryRecord constructor
# as an argument
class ResourceHelper
  def self.generate_params_hash
    Record.new.attrs.map do |a|
      a_name              = a.to_s.clone.to_sym
      a_resource_instance = "new_resource.#{a}"
      Hash.try_convert(a_name => a_resource_instance)
    end.reduce(&:merge).to_s.delete('"')
  end
end
