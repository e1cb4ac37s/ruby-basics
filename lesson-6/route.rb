class Route
  include InstanceCounter

  attr_reader :start_station, :end_station

  def self.stringify_routes(routes)
    routes.map(&:to_s).join(', ')
  end

  def initialize(start_station, end_station)
    validate start_station, end_station

    @start_station = start_station
    @end_station = end_station
    @intermediates = []
    register_instance
  end

  def add_station(station)
    @intermediates << station unless stations.include? station
  end

  def remove_station(station)
    @intermediates.delete(station)
  end

  def stations
    [@start_station, *@intermediates, @end_station]
  end

  def to_s
    "[#{stations.map(&:name).join(', ')}]"
  end

  private

  def validate(start_station, end_station)
    raise 'Требуется наличие начальной и конечной станции!' if start_station.nil? || end_station.nil?
    raise 'Начальная и конечная станция не могут совпадать!' if start_station == end_station
  end
end
