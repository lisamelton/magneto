module Magneto

  class ERBFilter < Filter

    def name
      'erb'
    end

    def apply(content, ivars)
      require 'erb'

      # Adapted from `nanoc/filters/erb.rb` with thanks to Denis Defreyne and
      # contributors.
      context = RenderContext.new(ivars)
      proc = ivars[:content] ? lambda { ivars[:content] } : lambda {}
      b = context.get_binding(&proc)

      args = ivars[:erb].symbolize_keys rescue {}
      ERB.new(content, args[:safe_level], args[:trim_mode]).result b
    end
  end
end
