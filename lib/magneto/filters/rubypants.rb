module Magneto

  class RubyPantsFilter < Filter

    def name
      'rubypants'
    end

    def apply(content, ivars)
      begin
        require 'rubypants'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use RubyPants. Try running:"
        $stderr.puts '  $ [sudo] gem install rubypants'
        raise 'Missing dependency: rubypants'
      end

      RubyPants.new(content, *((ivars[:rubypants].symbolize_keys rescue {})[:options] || [])).to_html
    end
  end
end
