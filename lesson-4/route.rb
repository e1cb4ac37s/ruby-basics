class Route
  attr_reader :start_station, :end_station
  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @intermediates = []
  end

  def add_station(station)
    @intermediates << station
  end

  def remove_station(station)
    @intermediates.delete(station)
  end

  def stations
    [@start_station, *@intermediates, @end_station]
  end
end
