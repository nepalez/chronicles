# encoding: utf-8

module Chronicles

  # Injects the code to object methods selected by options
  #
  # @private
  class Injector

    attr_reader :object, :code, :list

    def initialize(object, code = nil, **options)
      @object = object
      @code   = code
      @list   = Methods.new(object, options)
    end

    def updaters
      list.map { |name| Updater.new(object, name, code) }
    end

    def run
      updaters.each(&:run)
    end

  end # class Injector

end # module Chronicles
