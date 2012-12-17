module Magneto

  class CoffeeScriptFilter < Filter

    def name
      'coffeescript'
    end

    def apply(content, ivars)
      begin
        require 'coffee-script'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use CoffeeScript. Try running:"
        $stderr.puts '  $ [sudo] gem install coffee-script'
        raise 'Missing dependency: coffee-script'
      end

      CoffeeScript.compile(content, (ivars[:coffeescript].symbolize_keys rescue {}))
    end
  end
end
