module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validators

    def validate attr, validation_type, param = nil
      @validators ||= {}
      @validators[attr] ||= []
      @validators[attr] << [validation_type, param]
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate!
      validators = self.class.validators
      validators.each do |attr, validations|
        validations.each { |v| self.send "_validate_#{v[0]}", attr, instance_variable_get("@#{attr}"), v[1] }
      end
    end

    def _validate_presence(attr, value, _ = nil)
      raise "#{attr} can not be empty." if value.nil? || (value.is_a?(String) && value.empty?)
    end

    def _validate_type(attr, value, type)
      raise "#{attr} must be of type #{type}." unless value.is_a?(type)
    end

    def _validate_format(attr, value, regex)
      raise "@#{attr} must match format #{regex}" unless value.to_s =~ regex
    end
  end
end