require './manufacturer'
require './instance_counter'
require './station'
require './route'
require './train'
require './passenger_train'
require './cargo_train'
require './wagon'
require './cargo_wagon'
require './passenger_wagon'

trains = 5.times.map { |i| Train.new i }
13.times { |i| CargoTrain.new i + 5 }
42.times { |i| PassengerTrain.new i + 18 }

puts Train.instances # => 5
puts CargoTrain.instances # => 13
puts PassengerTrain.instances # => 42

trains[0].manufacturer = 'Honda'
puts trains[0].manufacturer
