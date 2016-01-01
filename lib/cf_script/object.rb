require 'ostruct'
require 'forwardable'

class CfScript::Object
  class << self
    attr_reader :_cf_script_object_count
  end

  def initialize
    @@_cf_script_object_count += 1
  end
end

require 'cf_script/object/attribute'
require 'cf_script/object/attribute_list'

require 'cf_script/object/api_endpoint'
require 'cf_script/object/app_spec'
require 'cf_script/object/app_info'
require 'cf_script/object/app_list'
require 'cf_script/object/instance_status'
require 'cf_script/object/space'
require 'cf_script/object/target'
require 'cf_script/object/route_info'
