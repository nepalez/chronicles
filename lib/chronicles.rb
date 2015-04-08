# encoding: utf-8

require_relative "chronicles/version"
require_relative "chronicles/methods"
require_relative "chronicles/updater"
require_relative "chronicles/injector"

# The module adds features to keep chronicles of object's methods calls
module Chronicles

  # @!attribute [r] chronicles
  # Returns the array of object methods having been called
  #
  # @return [Array<Symbol>]
  def chronicles
    @chronicles ||= []
  end

  # Starts registation of calls of the selected methods of the object
  #
  # @example
  #   class Test
  #     include Chronicles
  #   end
  #
  #   test = Test.new
  #   test.start_chronicles only: :foo
  #   test.foo
  #   test.bar
  #   test.baz
  #   test.foo
  #   test.chronicles # => [:foo, :foo]
  #
  # @param [Hash] options
  #   describes the selection of methods to include to chronicles
  # @option options [Boolean] :public (true)
  #   whether public methods should be looked after
  # @option options [Boolean] :protected (true)
  #   whether protected methods should be looked after
  # @option options [Boolean] :private (true)
  #   whether private methods should be looked after
  # @option options [Array<#to_sym>] :except ([])
  #   the whitelist of methods that shouldn't be looked after
  # @option options [Array<#to_sym>] :only ([])
  #   the whitelist of methods that should be looked after
  #
  # @return [undefined]
  def start_chronicles(**options)
    Injector.new(self, "chronicles << __method__", options).run
  end

  # Stops registation of calls of the selected methods of the object
  #
  # @example
  #   class Test
  #     include Chronicles
  #   end
  #
  #   test = Test.new
  #   test.start_chronicles
  #   test.foo
  #   test.bar
  #   test.baz
  #   test.chronicles # => [:foo, :bar, :baz]
  #
  #   test.stop_chronicles except: :foo
  #   test.foo
  #   test.bar
  #   test.baz
  #   test.chronicles # => [:foo, :bar, :baz, :foo]
  #
  # @param  (see #start_chronicles)
  # @option (see #start_chronicles)
  #
  # @return [undefined]
  def stop_chronicles(**options)
    Injector.new(self, options).run
  end

end # module Chronicles
