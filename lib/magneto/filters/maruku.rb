module Magneto

  class MarukuFilter < Filter

    def name
      'maruku'
    end

    def apply(content, ivars)
      begin
        require 'maruku'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Maruku. Try running:"
        $stderr.puts '  $ [sudo] gem install maruku'
        raise 'Missing dependency: maruku'
      end

      Maruku.new(content, (ivars[:maruku].symbolize_keys rescue {})).to_html
    end
  end
end
