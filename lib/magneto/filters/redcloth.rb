module Magneto

  class RedClothFilter < Filter

    def name
      'redcloth'
    end

    def apply(content, ivars)
      begin
        require 'redcloth'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use RedCloth. Try running:"
        $stderr.puts '  $ [sudo] gem install RedCloth'
        raise 'Missing dependency: RedCloth'
      end

      textile_doc = RedCloth.new(content)
      ivars[:redcloth].each { |rule, value| textile_doc.send((rule.to_s + '=').to_sym, value) }
      textile_doc.to_html
    end
  end
end
