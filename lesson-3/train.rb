class Train
  attr_reader :number, :type, :speed, :wagons, :prev_station, :current_station, :next_station

  def initialize(number, type, wagons)
    @speed = 0
    @number = number
    @type = type
    @wagons = wagons
  end

  def speed_up(diff)
    @speed += diff if diff.positive?
  end

  def stop
    @speed = 0
  end

  def hitch_wagon
    if speed.zero?
      @wagons += 1
    else
      puts 'Stop the train before hitching any wagons!'
    end
  end

  def uncouple_wagon
    if speed.zero? && @wagons >= 1
      @wagons -= 1
    else
      puts 'Stop the train before uncoupling any wagons! Or maybe train has not any wagons...'
    end
  end

  def accept_route(route)
    @route = route
    @current_station_index = 0
    @prev_station = nil
    @current_station = route.stations[@current_station_index]
    @current_station.accept_train(self)
    @next_station = route.stations[@current_station_index + 1]
  end

  def move_to_next
    return 'You are already at end station' unless @next_station

    @current_station.send_train(self)

    @current_station_index += 1
    @prev_station = @current_station

    @current_station = @next_station
    @current_station.accept_train(self)

    @next_station = @route.stations[@current_station_index + 1]
  end

  def move_to_prev
    return 'You are already at start station' unless @prev_station

    @current_station.send_train(self)

    @current_station_index -= 1
    @next_station = @current_station

    @current_station = @prev_station
    @current_station.accept_train(self)

    @prev_station = @current_station_index.zero? ? nil : @route.stations[@current_station_index - 1]
  end
end
