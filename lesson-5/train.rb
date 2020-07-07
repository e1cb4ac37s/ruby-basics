class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :speed, :prev_station, :current_station, :next_station

  @@trains = {}

  def self.stringify_trains(trains)
    "[#{trains.inject { |string, t| "#{string}, #{t}" }}]"
  end

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @speed = 0
    @number = number
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def to_s
    "#{@number} (#{@type})-#{wagons_string}"
  end

  def speed_up(diff)
    @speed += diff if diff.positive?
  end

  def stop
    @speed = 0
  end

  def hitch_wagon(wagon)
    if wagon.type != @type
      puts 'Тип вагона не соответствует типу поезда...'
      return
    end

    if speed.zero?
      @wagons << wagon
    else
      puts 'Остановите поезд, прежде чем прицеплять вагоны...'
    end
  end

  def uncouple_wagon
    if speed.zero? && @wagons.any?
      @wagons.pop
    else
      puts 'Остановите поезд, прежде чем отцеплять вагоны. Или вагонов нет...'
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
    unless @route
      puts 'Поезд не привязан к маршруту.'
      return
    end
    unless @next_station
      puts 'Поезд уже на конечной станции.'
      return
    end

    @current_station.send_train(self)

    @current_station_index += 1
    @prev_station = @current_station

    @current_station = @next_station
    @current_station.accept_train(self)

    @next_station = @route.stations[@current_station_index + 1]
  end

  def move_to_prev
    unless @route
      puts 'Поезд не привязан к маршруту.'
      return
    end
    unless @next_station
      puts 'Поезд уже на начальной станции.'
      return
    end

    @current_station.send_train(self)

    @current_station_index -= 1
    @next_station = @current_station

    @current_station = @prev_station
    @current_station.accept_train(self)

    @prev_station = @current_station_index.zero? ? nil : @route.stations[@current_station_index - 1]
  end

  private

  def wagons_string
    @wagons.empty? ? '[]' : "[#{@wagons.map { |_| '.' }.join}]"
  end
end
