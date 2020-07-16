# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :speed, :prev_station, :current_station, :next_station, :wagons

  NUMBER_FORMAT = /^[a-zа-я\d]{3}\-?[a-zа-я\d]{2}$/i.freeze

  @@trains = {}

  def self.stringify_trains(trains)
    "[#{trains.inject { |string, t| "#{string}, #{t}" }}]"
  end

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    validate number

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

  def each_wagon
    @wagons.each { |w| yield w }
  end

  def hitch_wagon(wagon)
    validate_wagon wagon
    @wagons << wagon if speed.zero?
  end

  def uncouple_wagon
    @wagons.pop if speed.zero? && @wagons.any?
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
    validate_route
    validate_has_next

    @current_station.send_train(self)

    @current_station_index += 1
    @prev_station = @current_station

    @current_station = @next_station
    @current_station.accept_train(self)

    @next_station = @route.stations[@current_station_index + 1]
  end

  def move_to_prev
    validate_route
    validate_has_prev

    @current_station.send_train(self)

    @current_station_index -= 1
    @next_station = @current_station

    @current_station = @prev_station
    @current_station.accept_train(self)

    @prev_station = @current_station_index.zero? ? nil : @route.stations[@current_station_index - 1]
  end

  def cargo?
    instance_of? CargoTrain
  end

  private

  def wagons_string
    @wagons.empty? ? '[]' : "[#{@wagons.map { |_| '.' }.join}]"
  end

  def validate(number)
    raise 'Не удалось создать поезд! Номер поезда не может быть пустым!' if number.nil? || !number.size
    raise "Не удалось создать поезд! Номер \"#{number}\" имеет неправильный формат!" if number !~ NUMBER_FORMAT

    true
  end

  def validate_route
    raise 'Поезд не привязан к маршруту!' unless @route
  end

  def validate_has_next
    raise 'Поезд уже на конечной станции!' unless @next_station
  end

  def validate_has_prev
    raise 'Поезд уже на начальной станции!' unless @prev_station
  end

  def validate_wagon(wagon)
    raise 'Тип вагона не соответствует типу поезда!' if wagon.type != @type
  end

  def valid?
    validate
  rescue StandardError
    false
  end
end
