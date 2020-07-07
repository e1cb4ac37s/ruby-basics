class Route
  include InstanceCounter

  attr_reader :start_station, :end_station

  def self.stringify_routes(routes)
    routes.map(&:to_s).join(', ')
  end

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @intermediates = []
    register_instance
  end

  def add_station(station)
    @intermediates << station if station
  end

  def remove_station(station)
    @intermediates.delete(station) if station
  end

  def stations
    [@start_station, *@intermediates, @end_station]
  end

  def to_s
    stations.empty? ? '[]' : "[#{stations.map(&:name).join(', ')}]"
  end
end
