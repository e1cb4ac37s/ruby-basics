require './months'

def leap_year? year
  case 0
  when year % 400
    return true
  when year % 100
    return false
  end
  year % 4 == 0
end

def yday day, month, year
  months = get_months(leap_year?(year))
    .inject ([]) { |months_arr, (k, v)| months_arr << v }
  months_days_sum = month.
    times.
    inject (0) { |months_days_sum, i| months_days_sum + months[i] }
  months_days_sum - (months[month - 1] - day)
end
