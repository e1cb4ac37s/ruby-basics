module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    private

    # я очень не хотел бы чтоб increment_instances был
    # публичным методом, я хотел чтоб он отрабатывал только
    # при создании экземпляра юзера модуля, и не был в
    # открытом апи. Поэтому register_instance содержит хак
    # который я видел где-то в интернете, который позволяет
    # вызвать приватный метод там, откуда вообще нельзя бы.
    def increment_instances
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    private

    def register_instance
      # комментарий выше
      self.class.send :increment_instances
    end
  end
end