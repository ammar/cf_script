module CfScript::Utils
  module_function

  def symbolize(name)
    return name if name.is_a?(Symbol)

    name.downcase.gsub(/[ .-]/, '_').to_sym
  end

  def symbolize_keys(hash)
    out = {}

    hash.each do |key, value|
      out[symbolize(key)] = value
    end

    out
  end
end
