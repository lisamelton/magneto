module Magneto

  class Application

    attr_reader :config, :filters, :site

    def initialize
      super
      @options = {}
      @config_path = 'config.yaml'
      @config = {
        :source_path        => '.',
        :output_path        => 'output',
        :hidden_files       => false,
        :remove_obsolete    => false,
        :auto_regeneration  => false
      }
      @filters = {}
      @site = nil
    end

    def run
      parse_options
      load_configuration

      @config.deep_merge! @options

      [:source_path, :output_path].each do |path|
        @config[path] = File.expand_path(@config[path])
        @config[path].freeze
      end

      load_plugins
      find_filters

      @site = Site.new(@config, @filters)

      if @config[:auto_regeneration]
        puts 'Automatic regeneration enabled.'

        require 'directory_watcher'

        dw = DirectoryWatcher.new(@config[:source_path])
        dw.glob = [@config[:hidden_files] ? 'items/**/{.[^.],}*' : 'items/**/*', 'templates/*.*', 'script.rb']
        dw.interval = 1
        dw.add_observer { |*args| @site.generate }
        dw.start
        gets
        dw.stop
      else
        @site.generate
      end

      exit
    end

    private

    def parse_options
      begin
        OptionParser.new do |opts|
          opts.banner = "Magneto is a static site generator."
          opts.separator ""
          opts.separator "  Usage: #{File.basename($PROGRAM_NAME)} [OPTION]..."
          opts.separator ""
          opts.separator "  Source file items, their templates and the site controller script"
          opts.separator "  are loaded from the 'items' and 'templates' directories and from the"
          opts.separator "  'script.rb' file, all within the current directory. These are watched"
          opts.separator "  for changes and reloaded when automatic regeneration is enabled."
          opts.separator ""
          opts.separator "  Ruby library files are loaded from the 'plugins' directory only once."
          opts.separator ""
          opts.separator "  The generated site is written to the 'output' directory."
          opts.separator ""
          opts.separator "  Configuration is loaded from 'config.yaml' but can be overriden"
          opts.separator "  using the following options:"
          opts.separator ""

          opts.on('-c', '--config PATH', 'use specific YAML configuration file')  { |cp| @config_path = cp }
          opts.on('-s', '--source PATH', 'use specific source directory')         { |sp| @options[:source_path] = sp }
          opts.on('-o', '--output PATH', 'use specific output directory')         { |op| @options[:output_path] = op }

          opts.separator ""

          opts.on('--[no-]hidden', 'include [exclude] hidden source files')       { |hf| @options[:hidden_files] = hf }
          opts.on('--[no-]remove', 'remove [keep] obsolete output')               { |ro| @options[:remove_obsolete] = ro }
          opts.on('--[no-]auto', 'enable [disable] automatic regeneration')       { |ar| @options[:auto_regeneration] = ar }

          opts.separator ""

          opts.on_tail('-h', '--help', 'display this help and exit') do
            puts opts
            exit
          end

          opts.on_tail '--version', 'output version information and exit' do
            puts <<VERSION_HERE
#{File.basename($PROGRAM_NAME)} #{VERSION}
Copyright (c) 2012 Don Melton
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
VERSION_HERE
            exit
          end
        end.parse!
      rescue => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        usage
      end

      if ARGV.size > 0
        $stderr.print "#{File.basename($PROGRAM_NAME)}: unknown argument(s):"
        ARGV.each { |a| $stderr.print " #{a}" }
        $stderr.puts
        usage
      end
    end

    def usage
      $stderr.puts "Try '#{File.basename($PROGRAM_NAME)} --help' for more information."
      exit false
    end

    def load_configuration
      puts 'Loading configuration...'

      begin
        configuration = YAML.load_file(@config_path)
        raise unless configuration.is_a? Hash
      rescue => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        $stderr.puts "WARNING: Couldn't load configuration. Using defaults (and options)."
        configuration = {}
      end

      @config.deep_merge! configuration.symbolize_keys
    end

    def load_plugins
      puts 'Loading plugins...'
      Dir[@config[:source_path] + '/plugins/**/*.rb'].each { |plugin| require plugin unless File.directory? plugin }
    end

    def find_filters
      puts 'Finding filters...'

      Magneto::Filter.subclasses.each do |subclass|
        filter = subclass.new(@config)
        @filters[filter.name.to_sym] = filter
      end
    end
  end
end
