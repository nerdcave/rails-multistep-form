module MultiStepModel
  attr_writer :current_step

  def current_step
    @current_step.to_i
  end

  def current_step_valid?
    valid?
  end

  def all_steps_valid?
    (0...self.class.total_steps).all? do |step|
      @current_step = step
      current_step_valid?
    end
  end

  def step_forward
    @current_step = current_step + 1
  end

  def step_back
    @current_step = current_step - 1
  end

  # Returns true if step is not set to ensure ALL validations are executed upon save/validate
  # (state of the object is considered to be on every step if step is not set).
  def step?(step)
    @current_step.nil? || current_step + 1 == step
  end

  def last_step?
    step?(self.class.total_steps)
  end

  def first_step?
    step?(1)
  end

  def method_missing(method_name, *args, &block)
    if /^step(\d+)\?$/ =~ method_name
      step?($1.to_i)
    else
      super
    end
  end

end