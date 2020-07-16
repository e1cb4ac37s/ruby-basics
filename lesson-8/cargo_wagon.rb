# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :occupied_volume

  def initialize(type = 'cargo', capacity)
    super type, capacity
    @occupied_volume = 0
  end

  def load(volume)
    @occupied_volume = [@occupied_volume + volume, @capacity].min
  end

  def available_volume
    free_space @occupied_volume
  end
end
