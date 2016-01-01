class CfScript::Target < CfScript::Object
  attr_reader   :api_endpoint
  attr_reader   :user
  attr_reader   :org

  attr_accessor :space

  def initialize(api_endpoint = '', org = '', space = '', user = nil)
    @api_endpoint = api_endpoint
    @org          = org
    @space        = space
    @user         = user
  end

  def to_options
    options = {}

    options[:o] = @org   if @org and not @org.empty?
    options[:s] = @space if @space and not @space.empty?

    options
  end
end
