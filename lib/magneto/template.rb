module Magneto

  class Template
    include Readable

    attr_reader :site, :path, :name, :filter

    def initialize(site, path, name)
      super()
      @site = site
      @path = path
      @name = name
      @filter = nil
      @metadata = nil
      @content = nil
    end

    def use_filter(filter_name)
      @filter = @site.filters[filter_name.to_sym]

      if @filter.nil?
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        raise "Couldn't find filter: '#{filter_name.to_s}'"
      end
    end

    def import_metadata
      @filter = use_filter(@metadata[:filter]) unless @metadata.nil? || @metadata[:filter].nil?
    end
  end
end
