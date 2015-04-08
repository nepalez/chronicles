# encoding: utf-8

module Chronicles

  # Array of object methods selected by options
  #
  # @private
  class Methods < Array

    def initialize(object, **options)
      @object  = object
      @options = options
      super(whitelist.empty? ? list : list & whitelist)
    end

    private

    attr_reader :object, :options

    def list
      [public_list, protected_list, private_list].flatten.compact - blacklist
    end

    def whitelist
      Array(options[:only]).map(&:to_sym)
    end

    def blacklist
      Array(options[:except]).map(&:to_sym)
    end

    def public_list
      return if options[:public].equal?(false)
      object.public_methods - Object.public_instance_methods - own_list
    end

    def own_list
      %i(chronicles start_chronicles stop_chronicles)
    end

    def protected_list
      return if options[:protected].equal?(false)
      object.protected_methods
    end

    def private_list
      return if options[:private].equal?(false)
      object.private_methods - Object.private_instance_methods
    end

  end # class Methods

end # module Chronicles
