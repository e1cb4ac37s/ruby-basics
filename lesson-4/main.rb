require './station'
require './route'
require './train'
require './passenger_train'
require './cargo_train'
require './wagon'
require './cargo_wagon'
require './passenger_wagon'
require './app'

cancel = 'отмена'

trains = []

# puts 'Добро пожаловать в поездатую песочницу!'
# loop do
#   puts "
#   Что делаем дальше? (номер соответствует действию, выход из программы при любом другом запросе)
#   (1) Создать станции
#   (2) Создать поезда
#   (3) Создать маршруты и управлять станциями в нем (добавлять, удалять)
#   (4) Назначать маршрут поезду
#   (5) Добавлять вагоны к поезду
#   (6) Отцеплять вагоны от поезда
#   (7) Перемещать поезд по маршруту вперед и назад
#   (8) Просматривать список станций и список поездов на станции
#   "
#   choice = gets.chomp
#   case choice
#   when '1'
#     print 'Введите названия создаваемых станций через пробел, или введите (отмена) чтобы вернуться назад: '
#     input = gets.chomp
#     continue if input == cancel

#     stations = input.split.map { |name| Station.new(name) }
#     p stations
#   when '2'
#     print 'Какой тип поездов мы создаем? (1) Пассажирские, (2) Грузовые, (отмена) чтобы вернуться назад: '
#     input = gets.chomp
#     continue if input == cancel

#     case input
#     when '1'
#       print 'Введите номера создаваемых пассажирских поездов через пробел, или введите (отмена) чтобы вернуться назад: '
#       input = gets.chomp
#       continue if input == cancel
#       trains.concat(input.split.map { |number| PassengerTrain.new(number) })
#     when '2'
#       print 'Введите номера создаваемых грузовых поездов через пробел, или введите (отмена) чтобы вернуться назад: '
#       input = gets.chomp
#       continue if input == cancel
#       trains.concat(input.split.map { |number| CargoTrain.new(number) })
#     else
#       puts 'Неизвестная опция, возвращаемся в главное меню...'
#       continue
#     end
#     puts Train.stringify_trains(trains)
#   else
#     break
#   end
# end

app = App.new
app.start