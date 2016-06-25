class ModelWizard
  attr_reader :object

  def initialize(object_or_class, session, params = nil, object_params = nil)
    @object_or_class, @session = object_or_class, session
    @params, @object_params = params, object_params
    @param_key = ActiveModel::Naming.param_key(object_or_class)
    @session_params = "#{@param_key}_params".to_sym
  end

  def start
    @session[@session_params] = {}
    @object = load_object
    @object.current_step = @params[:step].to_i
    self
  end

  def continue
    @session[@session_params].deep_merge!(@object_params) if @object_params
    @object = load_object
    @object.assign_attributes(@session[@session_params]) unless class?
    self
  end

  def save
    if @params[:back_button]
      @object.step_back
    elsif @object.current_step_valid?
      return process_save
    end
    false
  end

private

  def load_object
    class? ? @object_or_class.new(@session[@session_params]): @object_or_class
  end

  def class?
    @object_or_class.is_a?(Class)
  end

  def process_save
    if @object.last_step?
      if @object.all_steps_valid?
        success = @object.save
        @session[@session_param] = nil
        return success
      end
    else
      @object.step_forward
    end
    false
  end

end