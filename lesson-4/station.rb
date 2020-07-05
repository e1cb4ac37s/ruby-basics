class Station
  attr_reader :trains, :name

  def self.stringify_stations(stations)
    return 'Список станций пуст.' if stations.empty?

    stations.inject('') do |acc, station|
      "#{acc}Название: #{station.name}. Поезда: #{Train.stringify_trains(station.trains)}.\n"
    end
  end

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def cargo_trains
    selection = trains.select { |t| t.type == 'cargo' }
    {
      trains: selection,
      count: selection.size
    }
  end

  def passenger_trains
    selection = trains.select { |t| t.type == 'passenger' }
    {
      trains: selection,
      count: selection.size
    }
  end
end
