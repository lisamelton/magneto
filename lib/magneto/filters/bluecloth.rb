module Magneto

  class BlueClothFilter < Filter

    def name
      'bluecloth'
    end

    def apply(content, ivars)
      begin
        require 'bluecloth'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use BlueCloth. Try running:"
        $stderr.puts '  $ [sudo] gem install bluecloth'
        raise 'Missing dependency: bluecloth'
      end

      BlueCloth.new(content, (ivars[:bluecloth].symbolize_keys rescue {})).to_html
    end
  end
end
