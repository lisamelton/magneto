module Magneto

  class RDiscountFilter < Filter

    def name
      'rdiscount'
    end

    def apply(content, ivars)
      begin
        require 'rdiscount'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use RDiscount. Try running:"
        $stderr.puts '  $ [sudo] gem install rdiscount'
        raise 'Missing dependency: rdiscount'
      end

      RDiscount.new(content, *((ivars[:rdiscount].symbolize_keys rescue {})[:extensions] || [])).to_html
    end
  end
end
