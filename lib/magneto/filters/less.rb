module Magneto

  class LessFilter < Filter

    def name
      'less'
    end

    def apply(content, ivars)
      begin
        require 'less'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Less. Try running:"
        $stderr.puts '  $ [sudo] gem install less'
        raise 'Missing dependency: less'
      end

      args = ivars[:less].symbolize_keys rescue {}
      Less::Parser.new(args).parse(content).to_css(args)
    end
  end
end
