# frozen_string_literal: true

def get_fibonaccis(max)
  fibonaccis = [1, 1]

  while (last = fibonaccis[-2] + fibonaccis[-1]) < max do fibonaccis << last end

  fibonaccis
end
