require './station'
require './route'
require './train'

stations = (1..6).map { |n| Station.new("Station ##{n}") }

routes = (0..4).map { |n| Route.new(stations[n], stations[n + 1]) }

trains = []
trains << Train.new('123pepe', 'freight', 11)
trains << Train.new('234joca', 'passenger', 23)
trains << Train.new('345boca', 'freight', 13)
trains << Train.new('456quokka', 'passenger', 3)
trains << Train.new('567bekka', 'passenger', 7)

puts 'Stations: --------'
p stations.map(&:name)
puts '------------------'

puts 'Routes: ----------'
p routes.map(&:stations)
puts '------------------'

puts 'Trains: ----------'
p trains.map(&:number)
puts '------------------'

puts 'Test stations:'
test_station = stations[0]
puts "First station before accepting trains: #{test_station.trains.map(&:number)}"
test_station.accept_train(trains[0])
test_station.accept_train(trains[1])
test_station.accept_train(trains[4])
puts "First station after accepting trains: #{test_station.trains.map(&:number)}"
puts "Freight trains: #{test_station.freight_trains}"
puts "Passenger trains: #{test_station.passenger_trains}"
test_station.send_train(trains[0])
test_station.send_train(trains[1])
test_station.send_train(trains[4])
puts "First station sent all trains: #{test_station.trains.map(&:number)}"

puts 'Test routes:'
test_route = routes[0]
puts "Start station: #{test_route.start_station}"
puts "End station: #{test_route.end_station}"
puts "Stations: #{test_route.stations.map(&:name)}"
test_route.add_station(stations[4])
puts "Stations: #{test_route.stations.map(&:name)}"
test_route.remove_station(stations[4])
puts "Stations: #{test_route.stations.map(&:name)}"

puts 'Test trains:'
test_train = trains[0]
puts "Number: #{test_train.number}"
puts "Type: #{test_train.type}"
puts "Wagons count: #{test_train.wagons}"
puts "Speed: #{test_train.speed}"
puts 'Spead up 20 mph...'
test_train.speed_up(20)
puts "Speed: #{test_train.speed}"
test_train.hitch_wagon
puts 'Hitch additional wagon... (should fail)'
puts "Wagons count: #{test_train.wagons}"
puts 'Stop the train...'
test_train.stop
puts "Speed: #{test_train.speed}"
puts 'Hitch additional wagon... (should not fail)'
test_train.hitch_wagon
puts "Wagons count: #{test_train.wagons}"
test_route.add_station(stations[4])
test_route.add_station(stations[3])
puts "Test route, again: #{test_route.stations.map(&:name)}. Accept it to test train..."
test_train.accept_route(test_route)
puts "Test train current station: #{test_train.current_station.name}"
3.times do
  puts 'Go to next...'
  test_train.move_to_next
  puts "Test train current station: #{test_train.current_station.name}"
end

3.times do
  puts 'Go to prev...'
  test_train.move_to_prev
  puts "Test train current station: #{test_train.current_station.name}"
end

puts "Prev: #{test_train.prev_station}"
puts "Current: #{test_train.current_station.name}"
puts "Next: #{test_train.next_station.name}"
puts 'Go to next...'
test_train.move_to_next
puts "Prev: #{test_train.prev_station.name}"
puts "Current: #{test_train.current_station.name}"
puts "Next: #{test_train.next_station.name}"
puts 'Go to next...'
test_train.move_to_next
puts "Prev: #{test_train.prev_station.name}"
puts "Current: #{test_train.current_station.name}"
puts "Next: #{test_train.next_station.name}"
puts 'Go to next...'
test_train.move_to_next
puts "Prev: #{test_train.prev_station.name}"
puts "Current: #{test_train.current_station.name}"
puts "Next: #{test_train.next_station}"
puts 'Go to prev...'
test_train.move_to_prev
puts "Prev: #{test_train.prev_station.name}"
puts "Current: #{test_train.current_station.name}"
puts "Next: #{test_train.next_station.name}"
puts stations[3].trains[0].number == test_train.number
