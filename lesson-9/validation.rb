module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validators

    def validate attr, validation_type, param = nil
      @validators ||= []
      @validators << { attr: attr, validation_type: validation_type, param: param }
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
      self.class.validators.each do |v|
        send "_validate_#{v[:validation_type]}",
             v[:attr],
             instance_variable_get("@#{v[:attr]}"),
             v[:param]
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