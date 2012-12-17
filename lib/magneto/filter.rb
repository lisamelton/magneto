module Magneto

  # Adapted from `jekyll/plugin.rb` with thanks to Tom Preston-Werner.
  class Filter

    class << self

      def inherited(subclass)
        subclasses << subclass
      end

      def subclasses
        @subclasses ||= []
      end
    end

    def initialize(config)
      @config = config
    end
  end
end
