def get_fibonaccis max
  fibonaccis = [1, 1]
  loop do
    last = fibonaccis[-2] + fibonaccis[-1]
    break if last > 100
    fibonaccis << last
  end
  fibonaccis
end