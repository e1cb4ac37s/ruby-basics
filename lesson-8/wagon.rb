# frozen_string_literal: true

class Wagon
  include Manufacturer
  attr_reader :type

  def initialize(capacity, type)
    @type = type
    @capacity = capacity
  end

  protected

  def free_space(occupied)
    @capacity - occupied
  end
end
