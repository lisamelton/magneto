module Magneto

  module Readable

    def metadata?
      not @metadata.nil? || @metadata.empty?
    end

    def metadata
      read if @metadata.nil?
      @metadata || {}
    end

    def metadata=(metadata)
      @metadata = metadata || {}
    end

    def content?
      not @content.nil? || @content.empty?
    end

    def content
      read if @content.nil?
      @content || ''
    end

    alias to_s content

    def content=(content)
      @content = content || ''
    end

    # Adapted from `jekyll/convertible.rb` with thanks to Tom Preston-Werner.
    def read
      @metadata = {}
      @content = File.read(path)

      if @content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @content = $POSTMATCH

        begin
          @metadata = YAML.load($1)
          raise unless @metadata.is_a? Hash
        rescue => ex
          $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
          $stderr.puts "WARNING: Couldn't load metadata."
          @metadata = {}
        end

        @metadata.symbolize_keys!
        import_metadata
      end
    end
  end
end
