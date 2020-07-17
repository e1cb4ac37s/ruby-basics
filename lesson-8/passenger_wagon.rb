# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :passengers

  def initialize(capacity, type = 'passenger')
    super(capacity, type)
    @passengers = 0
  end

  def occupy_seat
    @passengers += 1 if @passengers < @capacity
  end

  def free_seats
    free_space(@passengers)
  end
end
