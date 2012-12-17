module Magneto

  class KramdownFilter < Filter

    def name
      'kramdown'
    end

    def apply(content, ivars)
      begin
        require 'kramdown'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use kramdown. Try running:"
        $stderr.puts '  $ [sudo] gem install kramdown'
        raise 'Missing dependency: kramdown'
      end

      Kramdown::Document.new(content, (ivars[:kramdown].symbolize_keys rescue {})).to_html
    end
  end
end
