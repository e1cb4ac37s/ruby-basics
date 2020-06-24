# frozen_string_literal: true

require './months'

def leap_year?(year)
  return true if (year % 400).zero?
  return false if (year % 100).zero?

  (year % 4).zero?
end

def yday(day, month, year)
  months = get_months(leap_year?(year))
           .inject([]) { |months_arr, (_, v)| months_arr << v }
  months_days_sum = month.times.inject(0) { |sum, i| sum + months[i] }
  months_days_sum - (months[month - 1] - day)
end
