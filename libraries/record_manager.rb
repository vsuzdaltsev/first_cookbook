#!/usr/bin/env ruby

require_relative 'record'

# Manages records: checks if record exists, adds and deletes record
class RecordManager
  attr_reader :record,
              :opts

  def initialize(record, opts = {})
    @record      = record
    @opts        = opts
    @node        = Chef.node
    @run_context = Chef.node.run_context
    #binding.pry
  end
end

# Subclass to handle file-based records
class FileRecordManager < RecordManager
  def add_record
    output        = @opts[:output]
    record_string = @opts[:output_string]
    puts "=> Create #{self.class} record: #{record_string.squeeze(' ')}"
    ::IO.write(output, record_string, mode: 'a')
    true
  end

  def delete_record
    output_content = ::IO.read(@opts[:output])
    output         = @opts[:output]
    record_string  = @opts[:output_string]
    new_content    = output_content.sub(record_string, '')
    puts "=> Delete #{self.class} record: #{record_string.squeeze(' ')}"
    ::IO.write(output, new_content)
    true
  end

  def record_exists?
    output_exists? || create_output
    output        = @opts[:output]
    record_string = @opts[:output_string]
    ::IO.foreach(output) do |line|
      return true if line.chomp == record_string.chomp
    end
    false
  end

  protected

  def output_exists?
    exists = ::File.exist?(@opts[:output])
    puts "=> Check output existence: #{@opts[:output]} exists? #{exists}"
    exists
  end

  def create_output
    output = @opts[:output]
    Chef::Resource::Template.new(output, @run_context).tap do |t|
      t.path       output
      t.source     'hosts_file.erb'
      t.cookbook   'first_cookbook'
      t.run_action :create
    end
  end
end

# Subclass to handle api-based records
class ApiRecordManager < RecordManager
  DnsRubyOptsDefault = {
    key_name:   'dnsupdate_key_name',
    key:        'dnsupdate_key',
    zone:       'zone',
    nameserver: 'dns_server'
  }.freeze

  def initialize(record, opts = {})
    @record          = record
    @opts            = opts
    @dnsruby_options = {}
  end

  def add_record
  end

  def delete_record
  end

  def record_exists?
  end

  protected

  def api_exists?
  end
end

# Subclass to handle hosts-file-style records
class HostsRecordManager < FileRecordManager
  def initialize(record, opts = {})
    super
    @opts[:output]        = @node['first_cookbook']['hosts_file']
    @opts[:output_string] = format(
      "%-30s %30s\n", @record.origin, @record.domain_name
    )
  end
end

# Subclass to handle bind-style records
class BindRecordManager < FileRecordManager
  def initialize(record, opts = {})
    super
    @opts[:output]        = @node['first_cookbook']['bind_file']
    @opts[:output_string] = generate_record_string
  end

  def generate_record_string
    format(
      "%-30s %10s %10s %10s %20s\n",
      @record.domain_name,
      'IN',
      @record.bind_record_type,
      @record.mx_weight,
      @record.origin
    )
  end
end
