def get_products_list
  i = 1
  hash = {}
  puts 'Введите список купленных товаров (введите "стоп" для прекращения) в формате "название цена количество":'
  loop do
    print "#{i}: "
    input = gets.chomp
    break if input == 'стоп'
    name, price, quantity = input.split(' ')
    price, quantity = price.to_f, quantity.to_f
    hash[name] = { price => quantity }
    i += 1
  end
  hash
end

def total_by_product products
  products.inject ({}) do |acc, (k, v)|
    acc[k] = v.inject (1) {|acc, (k, v)| acc = (k * v).round(2) }
    acc
  end
end

def total products
  total_by_product(products).inject (0) { |acc, (k, v)| acc += v }
end