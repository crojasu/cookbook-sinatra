class Recipe
  # STATE
  attr_reader :name, :description, :duration
  def initialize(name, description, duration = nil)
    @name = name
    @description = description
    @duration = duration
  end
end
