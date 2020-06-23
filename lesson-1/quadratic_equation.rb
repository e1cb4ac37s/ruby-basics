puts 'Введите коэффициенты квадратного уравнения:'

print 'a: '
a = gets.chomp.to_f

if a == 0
  puts 'Уравнение не является квадратным'
  exit
end

print 'b: '
b = gets.chomp.to_f

print 'c: '
c = gets.chomp.to_f

d = b ** 2 - 4 * a * c

puts "Дискриминант: #{d}"
if d < 0
  puts 'Корней нет'
elsif d == 0
  puts "Корень один, и он равен #{-b / (2 * a)}"
else
  puts 'Корни этого уравнения:'
  puts "1) #{(-b + Math.sqrt(d)) / (2 * a)}"
  puts "2) #{(-b - Math.sqrt(d)) / (2 * a)}"
end
