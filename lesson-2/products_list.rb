# frozen_string_literal: true

def prompt_products_list
  i = 1
  hash = {}
  puts 'Введите список купленных товаров (введите "стоп" для прекращения) в формате "название цена количество":'
  loop do
    print "#{i}: "
    input = gets.chomp
    break if input == 'стоп'

    name, price_prompt, quantity_prompt = input.split(' ')
    price = price_prompt.to_f
    quantity = quantity_prompt.to_f
    hash[name] = { price => quantity }
    i += 1
  end
  hash
end

def total_by_product(products)
  products.each_with_object({}) do |(k, v), acc|
    acc[k] = v.inject(1) { |_, (k, v)| (k * v).round(2) }
  end
end

def total(products)
  total_by_product(products).inject(0) { |acc, (_, v)| acc + v }
end
