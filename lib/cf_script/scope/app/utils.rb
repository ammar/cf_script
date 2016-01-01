module CfScript::Scope
  module App::Utils
    def dump
      title name

      app_info.instance_variables.each do |var|
        next if var == :@name or var == :@instance_status
        detail "#{var.to_s.gsub('@', '')}: #{app_info.instance_variable_get(var)}"
      end

      if app_info.instance_status
        title 'Instances', 2

        app_info.instance_status.each do |inst|
          str = inst.show(:index, :state, :cpu, :memory, :disk, :since)

          detail str, 3
        end
      end
    end

    def show(*attrs)
      line = []

      attrs.each do |attr|
        line << "#{attr}: #{self.send(attr)}"
      end

      info line.join(', ')
    end
  end
end
