class Product < ActiveRecord::Base
  validates :name, presence: true, if: "step?(1)"
  validates :quantity, numericality: true, if: "step?(2)"
  validates :tags, presence: true, if: "step?(3)"

  include MultiStepModel

  def self.total_steps
    3
  end

end
