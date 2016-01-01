class CfScript::ApiEndpoint < CfScript::Object
  attr_reader :url
  attr_reader :version

  def initialize(url = nil, version = nil)
    @url     = url
    @version = version
  end
end

