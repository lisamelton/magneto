require 'magneto/readable'

module Magneto

  class Item
    include Readable

    attr_reader :site, :origin

    INVALID_LOCATION_MATCH_PATTERN = %r{(^[^/].*$|^.*/$)}

    def initialize(site, origin = '')
      super()
      @site = site
      @origin = origin.sub(INVALID_LOCATION_MATCH_PATTERN, '')
      @destination = nil
      @metadata = nil
      @content = nil
      @precomposed_content = nil
    end

    def relocated?
      @origin == ''
    end

    def relocate
      @origin = ''
    end

    def abandoned?
      @destination == ''
    end

    def abandon
      @destination = ''
    end

    def destination
      @destination ||= @origin.dup
      @destination
    end

    def destination=(destination)
      @destination = (destination || '').sub(INVALID_LOCATION_MATCH_PATTERN, '')
    end

    def origin_path
      @site.items_path + @origin
    end

    alias_method :path, :origin_path

    def destination_path
      @site.config[:output_path] + (@destination || @origin)
    end

    def import_metadata
      self.destination = @metadata[:destination] unless @metadata.nil? || @metadata[:destination].nil?
    end

    def precomposed_content
      read if @content.nil?
      @precomposed_content || @content.dup
    end

    def apply_filter(filter_name, args = {})
      filter = @site.filters[filter_name.to_sym]

      if filter.nil?
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        raise "Couldn't find filter: '#{filter_name.to_s}'"
      end

      read if @content.nil?

      @content = filter.apply(@content, @site.config.deep_merge(@metadata || {}).deep_merge({
        :config => @site.config,
        :site => @site,
        :item => self
      }).deep_merge(filter_name.to_sym => args))
    end

    def apply_template(template_name, args = {})
      template = @site.templates[template_name.to_sym]

      if template.nil?
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        raise "Couldn't find template: '#{template_name.to_s}'"
      end

      read if @content.nil?
      @precomposed_content ||= @content.dup

      @content = template.filter.apply(template.content, {
        template.filter.name.to_sym => {}
      }.deep_merge(@site.config).deep_merge(@metadata || {}).deep_merge(template.metadata || {}).deep_merge({
        :config => @site.config,
        :site => @site,
        :item => self,
        :content => @content
      }).deep_merge(args.symbolize_keys))
    end

    def write
      unless abandoned?
        if content?
          FileUtils.mkdir_p File.dirname(destination_path)
          File.open(destination_path, 'w') { |f| f.write content }
        else
          unless relocated?
            FileUtils.mkdir_p File.dirname(destination_path)
            FileUtils.cp origin_path, destination_path
          end
        end
      end
    end
  end
end
