module Magneto

  class ScriptContext < Context

    def initialize(ivars)
      super
      puts 'Evaluating script...'

      begin
        self.instance_eval File.read(@source_path + '/script.rb')
        @site.write
      rescue => ex
        $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{ex.to_s}"
        raise 'Script evaluation failed.'
      end
    end
  end
end
