# frozen_string_literal: true

def get_months(is_leap_year = false)
  {
    январь: 31,
    февраль: is_leap_year ? 29 : 28,
    март: 31,
    апрель: 30,
    май: 31,
    июнь: 30,
    июль: 31,
    август: 31,
    сентябрь: 30,
    октябрь: 31,
    ноябрь: 30,
    декабрь: 31
  }
end
