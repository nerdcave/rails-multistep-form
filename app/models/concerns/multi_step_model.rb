module MultiStepModel
  attr_accessor :current_step

  def current_step
    @current_step.to_i + 1
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
    @current_step = @current_step.to_i + 1
  end

  def step_back
    @current_step = @current_step.to_i - 1
  end

  def step?(step)
    @current_step.nil? || current_step == step
  end

  def last_step?
    step?(self.class.total_steps)
  end

  def first_step?
    step?(1)
  end

end