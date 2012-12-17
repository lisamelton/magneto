module Magneto

  # Adapted from `nanoc/base/context.rb` with thanks to Denis Defreyne and
  # contributors.
  class Context

    def initialize(ivars)
      super()
      eigenclass = class << self ; self ; end

      ivars.each do |symbol, value|
        instance_variable_set('@' + symbol.to_s, value)
        eigenclass.send(:define_method, symbol) { value } unless eigenclass.send(:respond_to?, symbol)
      end
    end

    def get_binding
      binding
    end
  end
end
