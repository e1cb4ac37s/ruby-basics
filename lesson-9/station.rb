# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_reader :trains, :name

  NAME_FORMAT = /^[a-zа-я]{3,}$/i.freeze

  validate :name, :format, NAME_FORMAT

  @@stations = []

  def self.all
    @@stations
  end

  def self.stringify_stations(stations)
    return 'Список станций пуст.' if stations.empty?

    stations.inject('') do |acc, station|
      "#{acc}Название: #{station.name}. Поезда: #{Train.stringify_trains(station.trains)}.\n"
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def each_train
    @trains.each { |t| yield t }
  end

  def cargo_trains
    selection = trains.select(&:cargo?)
    {
      trains: selection,
      count: selection.size
    }
  end

  def passenger_trains
    selection = trains.reject(&:cargo?)
    {
      trains: selection,
      count: selection.size
    }
  end
end
