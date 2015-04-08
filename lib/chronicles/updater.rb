# encoding: utf-8

module Chronicles

  # Reloads object method
  #
  # @private
  class Updater

    def initialize(object, name, code = nil)
      @object = object
      @name   = name
      @code   = code
      type
    end

    attr_reader :object, :name, :code

    def type
      @type ||= %w(public private protected).detect do |item|
        object.public_send("#{ item }_methods").include? name
      end
    end

    def klass
      object.singleton_class
    end

    def run
      redefine_method
      protect_method
    end

    private

    def redefine_method
      code = code()
      klass.__send__ :define_method, name do |*args|
        instance_eval(code) if code
        super(*args)
      end
    end

    def protect_method
      klass.instance_eval "#{ type } :#{ name }"
    end

  end # class Updater

end # module Chronicles
