puts 'Введите 3 стороны треугольника:'
sides = []
3.times do |side|
  sides.push(gets.chomp.to_f)
end

squares = sides.map { |s| s ** 2 }

max = squares.max

if max == squares.min
  puts 'Треугольник является равносторонним и равнобедренным.'
  exit
end

lesserSquares = squares.select { |s| s != max }
isRight = lesserSquares.inject { |a, ls| a + ls } == max
isIsosceles = lesserSquares.uniq.size == 1

if isRight && isIsosceles
  puts 'Треугольник является прямоугольным и равнобедренным'
elsif isRight
  puts 'Треугольник является прямоугольным, но не равнобедренным'
elsif isIsosceles
  puts 'Треугольник является равнобедренным'
else
  puts 'Обычный треугольник'
end
