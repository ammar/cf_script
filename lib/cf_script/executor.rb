CfScript.const_set(:Executor, Module.new)

require 'cf_script/executor/recorder'
require 'cf_script/executor/simple'
require 'cf_script/executor/non_blocking'
