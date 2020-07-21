module Accessors
  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      raise TypeError.new('Attribute must be a symbol.') unless attr.is_a?(Symbol)

      attr_history = "@#{attr}_history"

      define_method(attr) do
        instance_variable_get("@#{attr}")
      end

      define_method("#{attr}=") do |v|
        history = instance_variable_get(attr_history)
        history.nil? ? instance_variable_set(attr_history, []) : history << instance_variable_get("@#{attr}")

        instance_variable_set("@#{attr}", v)
      end

      define_method("#{attr}_history") do
        instance_variable_get(attr_history)
      end
    end
  end

  def strong_attr_accessor(attr, attr_class)
    raise TypeError.new('Attribute must be a symbol.') unless attr.is_a?(Symbol)

    define_method(attr) do
      instance_variable_get("@#{attr}")
    end

    define_method("#{attr}=") do |v|
      raise TypeError.new("Value must be of type: #{attr_class}") unless v.is_a?(attr_class)

      instance_variable_set("@#{attr}", v)
    end
  end
end