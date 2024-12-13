module Magneto

  # Adapted from `nanoc/helpers/rendering.rb` and `nanoc/helpers/capturing.rb`
  # with thanks to Denis Defreyne and contributors.
  class RenderContext < Context

    def render(template_name, args = {}, &block)
      template = @site.templates[template_name.to_sym]

      if template.nil?
        raise "Couldn't find template: '#{template_name.to_s}'"
      end

      if block_given?
        # Get templating system output instance.
        erbout = eval('_erbout', block.binding)

        # Save output length.
        erbout_length = erbout.length

        # Execute block (which may cause recursion).
        block.call

        # Use additional output from block execution as content.
        current_content = erbout[erbout_length..-1]

        # Remove addition from templating system output.
        erbout[erbout_length..-1] = ''
      else
        current_content = nil
      end

      ivars = {}
      self.instance_variables.each { |ivar| ivars[ivar[1..-1].to_sym] = self.instance_variable_get(ivar) }

      result = template.filter.apply(template.content, ivars.deep_merge({
        :content => current_content
      }).deep_merge(template.metadata || {}).deep_merge(args.symbolize_keys))

      if block_given?
        # Append filter result to templating system output and return empty
        # string.
        erbout << result
        ''
      else
        result
      end
    end
  end
end
