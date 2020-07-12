class App
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
      case chosen_menu
      when '1' then stations_menu
      when '2' then trains_menu
      when '3' then routes_menu
      else
        break
      end
    end
  end

  def stations_menu
    loop do
      puts  '--- Меню станций ---'
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат в главное меню при любом другом запросе)'
      print 'Действия: посмотреть список станций (1), создать станции (2), список станций (другой формат) (3) -> '
      action = gets.chomp
      case action
      when '1' then puts Station.stringify_stations(@stations)
      when '2' then create_stations_menu
      when '3'
        @stations.each do |s|
          puts "Название: #{s.name}"
          puts 'Поезда:'
          s.each_train { |t| puts "\tНомер: #{t.number}, тип: #{t.type}, кол-во вагонов: #{t.wagons.size}" }
        end
      else
        break
      end
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
    rescue Exception => e
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
      case action
      when '1' then puts "Маршруты: #{Route.stringify_routes(@routes)}"
      when '2' then create_route
      when '3'
        route = select_route
        route_menu(route) if route
      else
        break
      end
    end
  end

  def create_route
    if @stations.size < 2
      puts 'Для создания маршрута необходимо минимум 2 станции.'
      return
    end

    puts 'Создаем маршрут, выберите начальную станцию.'
    start_station = select_station(@stations)
    end_station = select_station(@stations.reject { |s| s == start_station })
    if !start_station || !end_station
      puts 'Вы не выбрали стартовую или конечную станцию (или обе), маршрут не будет создан...'
      return
    end
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
      case action
      when '1'
        station = select_station(@stations, route.stations)
        route.add_station station
      when '2'
        if route.stations.size == 2
          puts 'У маршрута нет промежуточных станций, которые можно удалить.'
        else
          station = select_station(route.stations[1...-1]) # we don't touch start/end stations, those are core of route
          route.remove_station station
        end
      when '3'
        train = select_train
        if train
          train.accept_route route
          puts "Поезду: #{train} назначен маршрут #{route}."
        end
      else
        break
      end
    end
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
      case action
      when '1' then puts "Поезда: #{Train.stringify_trains(@trains)}"
      when '2' then create_trains_menu
      when '3'
        train = select_train
        train_menu(train) if train
      else
        break
      end
    end
  end

  def create_trains_menu
    print 'Выберите тип поездов: (1) Пассажирские, (2) Грузовые (возврат назад при любом другом запросе) -> '
    type = gets.chomp
    new_trains = []
    case type
    when '1'
      numbers = request_new_train_numbers
      new_trains = create_trains numbers, 'passenger'
    when '2'
      numbers = request_new_train_numbers
      new_trains = create_trains numbers, 'cargo'
    end
    @trains.push(*new_trains) unless new_trains.empty?
    create_trains_feedback new_trains
  end

  def request_new_train_numbers
    print 'Введите номера создаваемых поездов через пробел -> '
    gets.chomp.split
  end

  def create_trains(numbers, type)
    train_class = type == 'cargo' ? CargoTrain : PassengerTrain
    numbers.map do |number|
      train_class.new number
    rescue Exception => e
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
      case action
      when '1' then wagon_menu train
      when '2' then train_route_menu(train)
      else
        break
      end
    end
  end

  def wagon_menu(train)
    is_passenger = train.type == 'passenger'
    loop do
      puts "--- Вагон поезда #{train} ---"
      puts  'Выберите действие, введя соотв. число.'
      puts  '(возврат назад при любом другом запросе)'
      print 'Вывести cписок вагонов (1), прицепить вагон (2), отцепить вагон (3), заполнить вагон (4) -> '
      action = gets.chomp
      case action
      when '1'
        if is_passenger
          train.each_wagon { |w| puts "Тип: #{w.type}, занято: #{w.passengers}, свободно: #{w.free_seats}." }
        else
          train.each_wagon { |w| puts "Тип: #{w.type}, загружен: #{w.occupied_volume}, свободно: #{w.available_volume}." }
        end
      when '2'
        if is_passenger
          print 'Введите вместимость пассажирского вагона -> '
        else
          print 'Введите объем грузового вагона -> '
        end
        capacity = gets.chomp.to_i
        train.hitch_wagon(train.type == 'cargo' ? CargoWagon.new(capacity) : PassengerWagon.new(capacity))
      when '3' then train.uncouple_wagon
      when '4'
        selected_wagon = select_wagon(train)
        if is_passenger
          selected_wagon.occupy_seat
        else
          print 'Введите объем -> '
          volume = gets.chomp.to_i
          selected_wagon.load volume
        end
      else
        break
      end
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
      case action
      when '1'
        route = select_route
        if route
          train.accept_route route
          puts "Поезд перемещен на станцию: #{train.current_station}"
        end
      when '2'
        begin
          train.move_to_next
          puts "Поезд перемещен на станцию: #{train.current_station}"
        rescue Exception => e
          puts e.message
        end
      when '3'
        begin
          train.move_to_prev
          puts "Поезд перемещен на станцию: #{train.current_station}"
        rescue Exception => e
          puts e.message
        end
      else
        break
      end
    end
  end
end
