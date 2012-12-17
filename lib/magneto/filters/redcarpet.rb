module Magneto

  class RedcarpetFilter < Filter

    def name
      'redcarpet'
    end

    def apply(content, ivars)
      begin
        require 'redcarpet'
      rescue LoadError => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "You're missing a library required to use Redcarpet. Try running:"
        $stderr.puts '  $ [sudo] gem install redcarpet'
        raise 'Missing dependency: redcarpet'
      end

      args = ivars[:redcarpet].symbolize_keys rescue {}
      renderer_class = Kernel.const_get(args[:renderer_name]) rescue args[:renderer_class] || Redcarpet::Render::HTML
      args.delete(:renderer_name)
      args.delete(:renderer_class)
      renderer_options = args[:renderer_options].symbolize_keys rescue {}
      args.delete(:renderer_options)

      Redcarpet::Markdown.new(renderer_class.new(renderer_options), args).render(content)
    end
  end
end
