# Abstract module: have to be moved somewhere to core
module Abstract
  # Abstract::Object class
  class Object
    # Get an array of attr_accessor names
    # @return [Array] - Array of attribute accessor methods
    def attrs
      self.class.instance_eval do
        @attrs.each do |attr|
          attr_accessor attr
        end
      end
    end
  end

  # Abstract::Builder class
  class Builder
    attr_reader :object

    # Create an instance of Abstract::Object class and yield block to it
    # @return @object [AbstractObject] - Abstract::Object class instance
    def self.build
      builder = new(@build_class)
      yield builder if block_given?
      builder.object
    end

    # Define attribute writers to Abstract::Builder instance according to
    #   existing accessors of Abstract::Object instance
    # @param object [Abstract::Object] - Abstract::Object instance
    # @return [Abstract::Builder] - builder object
    def initialize(object)
      @object = Class.const_get(object).new
      @object.attrs.each do |attr|
        define_singleton_method "#{attr}=" do |param|
          @object.public_send("#{attr}=", param)
        end
      end
    end
  end
end

