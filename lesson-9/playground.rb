require './accessors'
require './validation'

class MyClass
  include Validation
  extend Accessors

  validate :a, :presence
  validate :b, :type, Numeric
  validate :a, :format, /^\d+$/

  attr_accessor_with_history :a
  strong_attr_accessor :b, Numeric

  def initialize(a, b)
    puts 'initialization'
    self.a = a
    self.b = b
    validate!
  end
end

o = MyClass.new 1, 'hello'
puts o.a
o.a = 2
o.a = 3
puts o.inspect
puts o.b
o.b = 3
o.b = 4
puts o.inspect
