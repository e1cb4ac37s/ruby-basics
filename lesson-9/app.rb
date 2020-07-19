# frozen_string_literal: true

class App
  MAIN_MENU = { '1' => :stations_menu, '2' => :trains_menu, '3' => :routes_menu }.freeze

  STATIONS_MENU = { '1' => :list_stations, '2' => :create_stations_menu, '3' => :list_stations_2 }.freeze

  ROUTES_MENU = { '1' => :list_routes, '2' => :create_route, '3' => :select_route_and_call_route_menu }.freeze

  ROUTE_MENU = { '1' => :add_station_to_route, '2' => :remove_station_from_route, '3' => :assign_route_to_train }.freeze

  TRAINS_MENU = { '1' => :list_trains, '2' => :create_trains_menu, '3' => :select_train_and_call_train_menu }.freeze

  TRAIN_MENU = { '1' => :wagon_menu, '2' => :train_route_menu }.freeze

  WAGON_MENU = {
    '1' => :print_wagons,
    '2' => :hitch_wagon,
    '3' => :uncouple_wagon,
    '4' => :load_wagon
  }.freeze

  TRAIN_ROUTE_MENU = { '1' => :train_accept_route, '2' => :train_to_next, '3' => :train_to_prev }.freeze

  def initialize
    @trains   = []
    @stations = []
    @routes   = []
  end

  def start
    main_menu
  end

  private

  def main_menu
    loop do
      puts  '--- Главное меню ---'
      puts  'Вызовите меню, введя соотв. число.'
      puts  '(выход из программы при любом другом запросе)'
      print 'Меню: станций (1), поездов (2), маршрутов (3) -> '
      chosen_menu = gets.chomp
      method = MAIN_MENU[chosen_menu]
      method ? send(method) : break
    end
  end

  def stations_menu
    loop do
      puts  '--- Меню станций ---'
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат в главное меню при любом другом запросе)'
      print 'Действия: посмотреть список станций (1), создать станции (2), список станций (другой формат) (3) -> '
      action = gets.chomp
      method = STATIONS_MENU[action]
      method ? send(method) : break
    end
  end

  def list_stations
    puts Station.stringify_stations(@stations)
  end

  def list_stations_2
    @stations.each do |s|
      puts "Название: #{s.name}"
      puts 'Поезда:'
      s.each_train { |t| puts "\tНомер: #{t.number}, тип: #{t.type}, кол-во вагонов: #{t.wagons.size}" }
    end
  end

  def create_stations_menu
    print 'Введите названия станций через пробел -> '
    station_names = gets.chomp.split
    new_stations = create_stations station_names
    @stations.push(*new_stations)
    create_stations_feedback new_stations
  end

  def create_stations(station_names)
    station_names.map do |name|
      Station.new(name)
    rescue StandardError => e
      puts e.message
    end.compact
  end

  def create_stations_feedback(new_stations)
    return puts 'Список новых станций пуст.' if new_stations.empty?

    puts 'Созданы станции:'
    puts Station.stringify_stations(new_stations)
  end

  def routes_menu
    loop do
      puts  '--- Меню маршрутов ---'
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат в главное меню при любом другом запросе)'
      print 'Действия: показать маршруты (1), создать маршрут (2), выбрать маршрут (3) -> '
      action = gets.chomp
      method = ROUTES_MENU[action]
      method ? send(method) : break
    end
  end

  def list_routes
    puts "Маршруты: #{Route.stringify_routes(@routes)}"
  end

  def select_route_and_call_route_menu
    route = select_route
    route_menu(route) if route
  end

  def create_route
    return puts 'Для создания маршрута необходимо минимум 2 станции.' if @stations.size < 2

    puts 'Создаем маршрут, выберите начальную станцию.'
    start_station = select_station(@stations)
    end_station = select_station(@stations.reject { |s| s == start_station })
    return puts 'Не выбрана стартовая/конечная станция, маршрут не будет создан.' unless start_station && end_station

    @routes << Route.new(start_station, end_station)
  end

  def select_route
    puts 'Выберите маршрут из существующих:'
    @routes.each.with_index(1) { |r, i| puts "(#{i}) - #{r}" }
    selected_index = gets.chomp.to_i
    @routes[selected_index - 1] if selected_index.between?(1, @routes.size)
  end

  def route_menu(route)
    loop do
      puts  "--- Меню маршрута [#{route}] ---"
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат в назад при любом другом запросе)'
      print 'Добавить станцию (1), удалить станцию (2), назначить поезду (3) -> '
      action = gets.chomp
      method = ROUTE_MENU[action]
      method ? send(method, route) : break
    end
  end

  def add_station_to_route(route)
    station = select_station(@stations, route.stations)
    route.add_station station
  end

  def remove_station_from_route(route)
    return puts 'У маршрута нет промежуточных станций, которые можно удалить.' if route.stations.size == 2

    route.remove_station(select_station(route.stations[1...-1])) # exclude start/end stations, those are route's core
  end

  def assign_route_to_train(route)
    train = select_train
    return unless train

    train.accept_route(route)
    puts "Поезду: #{train} назначен маршрут #{route}."
  end

  def select_station(from, except = [])
    puts 'Выберите станцию:'
    stations_slice = from.reject { |s| except.include?(s) }
    stations_slice.each.with_index(1) { |s, i| puts "(#{i}) - #{s.name}" }
    selected_index = gets.chomp.to_i
    selected_index.between?(1, stations_slice.size) ? stations_slice[selected_index - 1] : nil
  end

  def trains_menu
    loop do
      puts  '--- Меню поездов ---'
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат в главное меню при любом другом запросе)'
      print 'Действия: показать все поезда (1), создать поезда (2), выбрать поезд (3) -> '
      action = gets.chomp
      method = TRAINS_MENU[action]
      method ? send(method) : break
    end
  end

  def list_trains
    puts "Поезда: #{Train.stringify_trains(@trains)}"
  end

  def select_train_and_call_train_menu
    train = select_train
    train_menu(train) if train
  end

  def create_trains_menu
    print 'Выберите тип поездов: (1) Пассажирские, (2) Грузовые (возврат назад при любом другом запросе) -> '
    input = gets.chomp
    train_types_hash = { '1' => 'passenger', '2' => 'cargo' }
    type = train_types_hash[input]
    return if type.nil?

    numbers = request_new_train_numbers
    new_trains = create_trains(numbers, type)
    @trains.push(*new_trains) unless new_trains.empty?
    create_trains_feedback(new_trains)
  end

  def request_new_train_numbers
    print 'Введите номера создаваемых поездов через пробел -> '
    gets.chomp.split
  end

  def create_trains(numbers, type)
    train_class = type == 'cargo' ? CargoTrain : PassengerTrain
    numbers.map do |number|
      train_class.new number
    rescue StandardError => e
      puts e.message
    end.compact
  end

  def create_trains_feedback(new_trains)
    return puts 'Новых поездов нет.' if new_trains.empty?

    puts "Созданы поезда: #{Train.stringify_trains(new_trains)}"
  end

  def select_train
    puts 'Выберите поезд из существующих:'
    @trains.each.with_index(1) { |t, i| puts "(#{i}) - #{t}" }
    selected_index = gets.chomp.to_i
    @trains[selected_index - 1] if selected_index.between?(1, @trains.size)
  end

  def train_menu(train)
    loop do
      puts  "--- Поезд - #{train} ---"
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат назад при любом другом запросе)'
      print 'Меню вагона (1), маршрут (2) -> '
      action = gets.chomp
      method = TRAIN_MENU[action]
      method ? send(method, train) : break
    end
  end

  def wagon_menu(train)
    loop do
      puts "--- Вагон поезда #{train} ---"
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат назад при любом другом запросе)'
      print 'Вывести cписок вагонов (1), прицепить вагон (2), отцепить вагон (3), заполнить вагон (4) -> '
      action = gets.chomp
      method = WAGON_MENU[action]
      method ? send(method, train) : break
    end
  end

  def print_wagons(train)
    if train.cargo?
      train.each_wagon { |w| puts "Тип: #{w.type}, загружен: #{w.occupied_volume}, свободно: #{w.available_volume}." }
    else
      train.each_wagon { |w| puts "Тип: #{w.type}, занято: #{w.passengers}, свободно: #{w.free_seats}." }
    end
  end

  def hitch_wagon(train)
    if train.cargo?
      print 'Введите объем грузового вагона -> '
    else
      print 'Введите вместимость пассажирского вагона -> '
    end
    capacity = gets.chomp.to_i
    train.hitch_wagon(train.cargo? ? CargoWagon.new(capacity) : PassengerWagon.new(capacity))
  end

  def uncouple_wagon(train)
    train.uncouple_wagon
  end

  def load_wagon(train)
    selected_wagon = select_wagon(train)
    if train.cargo?
      print 'Введите объем -> '
      volume = gets.chomp.to_i
      selected_wagon.load volume
    else
      selected_wagon.occupy_seat
    end
  end

  def select_wagon(train)
    puts 'Выберите вагон из существующих:'
    train.wagons.each.with_index(1) { |w, i| puts "(#{i}) - #{w}" }
    selected_index = gets.chomp.to_i
    train.wagons[selected_index - 1] if selected_index.between?(1, train.wagons.size)
  end

  def train_route_menu(train)
    loop do
      puts  "--- Поезд - #{train} ---"
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат назад при любом другом запросе)'
      print 'Назначить маршрут (1), переместить по маршруту вперед (2), переместить по маршруту назад (3) -> '
      action = gets.chomp
      method = TRAIN_ROUTE_MENU[action]
      method ? send(method, train) : break
    end
  end

  def train_accept_route(train)
    route = select_route
    return nil unless route

    train.accept_route route
    puts "Поезд перемещен на станцию: #{train.current_station}"
  end

  def train_to_next(train)
    train.move_to_next
    puts "Поезд перемещен на станцию: #{train.current_station}"
  rescue StandardError => e
    puts e.message
  end

  def train_to_prev(train)
    train.move_to_prev
    puts "Поезд перемещен на станцию: #{train.current_station}"
  rescue StandardError => e
    puts e.message
  end
end
