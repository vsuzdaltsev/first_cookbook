#!/usr/bin/env ruby

require_relative 'record_manager'

class FactoryRecord
  def initialize(opts = {})
    @opts    = opts
    api_type = @opts[:api_type].capitalize
    record_manager = %{Class.const_get(api_type + 'RecordManager')}
    @factory       = instance_eval(record_manager).new(record).freeze
  end

  def record_exists?
    @factory.record_exists?
  end

  def add_record
    @factory.add_record
  end

  def delete_record
    @factory.delete_record
  end

  private

  def record
    RecordBuilder.build do |b|
      params = b.object.attrs
      params.each do |param|
        b.public_send("#{param}=", @opts[:"#{param}"])
      end
    end
  end
end
