module Magneto

  class Site

    attr_reader :config, :filters, :items_path, :items, :templates

    def initialize(config, filters)
      super()
      @config = config
      @filters = filters
      @items_path = @config[:source_path] + '/items'
      @items_path.freeze
      reset
    end

    def generate
      find_items
      find_templates
      find_existing_output

      ScriptContext.new(@config.deep_merge({
        :config => @config,
        :site => self
      }))

      reset
    end

    def write
      return if @written

      puts 'Writing output...'
      @written = true
      output = Set.new unless @existing_output.empty?

      @items.each do |item|
        item.write

        unless @existing_output.empty?
          next if item.abandoned?
          path = item.destination_path

          while path.start_with? @config[:output_path] do
            output << path
            path = File.dirname(path)
          end
        end
      end

      unless @existing_output.empty?
        obsolete_output = @existing_output - output
  
        unless obsolete_output.empty?
          if @config[:remove_obsolete]
            puts 'Removing obsolete output...'

            obsolete_output.to_a.sort.reverse.each do |path|
              if File.directory? path
                FileUtils.rmdir path
              else
                FileUtils.rm path
              end
            end
          else
            puts 'Listing obsolete output...'
            puts obsolete_output.to_a.sort.reverse
          end
        end
      end

      puts 'Site generation succeeded.'
    end

    private

    def reset
      @items = []
      @templates = {}
      @existing_output = Set.new
      @written = false
    end

    def find_items
      puts 'Finding items...'

      if File.directory? @items_path
        Dir.chdir @items_path do
          Dir[@config[:hidden_files] ? '**/{.[^.],}*' : '**/*'].each do |path|
            unless File.directory? path
              @items << Item.new(self, '/' + path)
            end
          end
        end
      end
    end

    def find_templates
      puts 'Finding templates...'

      Dir[@config[:source_path] + '/templates/*.*'].each do |path|
        unless File.directory? path
          name = File.basename(path).split('.')[0..-2].join('.')
          @templates[name.to_sym] = Template.new(self, path, name)
        end
      end
    end

    def find_existing_output
      puts 'Finding existing output...'

      Dir[@config[:output_path] + '/**/{.[^.],}*'].each do |path|
        @existing_output << path
      end
    end
  end
end
