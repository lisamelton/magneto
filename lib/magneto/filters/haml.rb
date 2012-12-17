module Magneto

  class HamlFilter < Filter

    def name
      'haml'
    end

    def apply(content, ivars)
      begin
        require 'haml'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Haml. Try running:"
        $stderr.puts '  $ [sudo] gem install haml'
        raise 'Missing dependency: haml'
      end

      # Adapted from "nanoc/filters/haml.rb" with thanks to Denis Defreyne and contributors.
      context = RenderContext.new(ivars)
      proc = ivars[:content] ? lambda { ivars[:content] } : lambda {}

      Haml::Engine.new(content, (ivars[:haml].symbolize_keys rescue {})).render(context, ivars, &proc)
    end
  end
end
