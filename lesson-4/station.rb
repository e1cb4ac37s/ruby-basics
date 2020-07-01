class Station
  attr_reader :trains, :name

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

  def freight_trains
    selection = trains.select { |t| t.type == 'freight' }
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
