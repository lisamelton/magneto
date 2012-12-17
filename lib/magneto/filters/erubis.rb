module Magneto

  class ErubisFilter < Filter

    def name
      'erubis'
    end

    def apply(content, ivars)
      begin
        require 'erubis'
        require 'erubis/engine/enhanced'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Erubis. Try running:"
        $stderr.puts '  $ [sudo] gem install erubis'
        raise 'Missing dependency: erubis'
      end

      # Adapted from "nanoc/filters/erubis.rb" with thanks to Denis Defreyne and contributors.
      context = RenderContext.new(ivars)
      proc = ivars[:content] ? lambda { ivars[:content] } : lambda {}
      b = context.get_binding(&proc)

      Erubis::ErboutEruby.new(content, (ivars[:erubis].symbolize_keys rescue {})).result b
    end
  end
end
