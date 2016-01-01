class CfScript::AppList < CfScript::Object
  extend Forwardable
  include Enumerable

  def initialize(list = [])
    @list = list
  end

  def_delegators :@list, :<<, :[], :clear, :length, :each, :select

  def select!(options)
    if options[:prefix]
      @list.reject! { |app_info| app_info.name !~ /\A#{options[:prefix]}/ }
    end

    if options[:state]
      @list.reject! { |app_info| app_info.requested_state !~ /\A#{options[:state]}\z/ }
    end

    if options[:suffix]
      @list.reject! { |app_info| app_info.name !~ /#{options[:suffix]}\z/ }
    end
  end
end
