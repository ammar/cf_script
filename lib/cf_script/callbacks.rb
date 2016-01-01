module CfScript::Callbacks
  def callbacks
    @callbacks ||= { before: {}, after: {} }
  end

  def before(step, &block)
    callbacks[:before][step] ||= []
    callbacks[:before][step] << block
  end

  def after(step, &block)
    callbacks[:after][step] ||= []
    callbacks[:after][step] << block
  end

  def callbacks_for(type, step)
    return [] unless callbacks.key?(type) && callbacks[type].key?(step)

    callbacks[type][step]
  end

  def run_callbacks(type, step)
    return unless callbacks[type].key?(step)

    callbacks[type][step].each do |callback|
      instance_eval(&callback)
    end
  end

  def run_before(step)
    run_callbacks(:before, step)
  end

  def run_after(step)
    run_callbacks(:after, step)
  end

  def run_around(step, &block)
    run_before(step)
    yield
    run_after(step)
  end
end
