class CfScript::AppList < CfScript::Object
  extend Forwardable
  include Enumerable

  def initialize(list = [])
    @list = list
  end

  def_delegators :@list, :<<, :[], :clear, :length, :each, :select

  def select!(options)
    if options[:starting_with]
      @list.reject! { |app_info| app_info.name !~ /\A#{options[:starting_with]}/ }
    end

    if options[:state]
      @list.reject! { |app_info| app_info.requested_state !~ /\A#{options[:state]}\z/ }
    end

    if options[:ending_with]
      @list.reject! { |app_info| app_info.name !~ /#{options[:ending_with]}\z/ }
    end
  end
end
