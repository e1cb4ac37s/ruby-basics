# frozen_string_literal: true

require './months'
require './fibonaccis'
require './yday'
require './products_list'

# 1
puts '#1) Месяцы с 30ю днями:'
p get_months.select { |_, days| days == 30 }.keys
puts '--------------------'
# 2
puts '#2) Массив чисел 10-100 с шагом 5:'
p (10..100).step(5).to_a
puts '--------------------'
# 3
puts '#3) Числа фибоначчи:'
p get_fibonaccis 100
puts '--------------------'
# 4
vowels = %w[a e i o u]
vowels_hash = ('a'..'z').each
                        .with_index(1)
                        .each_with_object({}) { |(letter, i), hash| hash[letter] = i }
                        .select { |letter, _| vowels.include? letter }

puts '#4) Хэш гласных:'
puts vowels_hash
puts '--------------------'
# 5
puts '#4) Порядковый номер дня в году:'
puts yday 24, 6, 2020
puts '--------------------'

# 6
puts '#6) Хэш товаров:'
products = prompt_products_list
puts 'Хэш:'
p products
puts 'Хэш "итого" по товару:'
p total_by_product(products)
puts 'Итого:'
p total(products)
puts '--------------------'
