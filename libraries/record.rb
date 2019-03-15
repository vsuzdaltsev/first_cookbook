#!/usr/bin/env ruby

# Record class stores attributes of the resource
class Record < Abstract::Object
  @attrs = [
    :api_type,
    :origin,
    :domain_name,
    :mx_weight,
    :bind_record_type
  ]
end

# Builder class for Record object
class RecordBuilder < Abstract::Builder
  @build_class = 'Record'
end
