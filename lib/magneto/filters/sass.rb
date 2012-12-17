module Magneto

  class SassFilter < Filter

    def name
      'sass'
    end

    def apply(content, ivars)
      begin
        require 'sass'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Sass. Try running:"
        $stderr.puts '  $ [sudo] gem install sass'
        raise 'Missing dependency: sass'
      end

      Sass::Engine.new(content, (ivars[:sass].symbolize_keys rescue {})).render
    end
  end
end
