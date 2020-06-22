print 'Как Вас зовут? '
name = gets.chomp

print 'Введите ваш рост (в сантиметрах): '
height = gets.chomp

ideal_weight = (height.to_f - 110) * 1.15

if ideal_weight >= 0
  puts "#{name}, Ваш идеальный вес: #{ideal_weight} кг."
else
  puts 'Ваш вес уже оптимальный'
end
