require 'English'
require 'fileutils'
require 'optparse'
require 'rubygems'
require 'set'
require 'yaml'

require 'magneto/application'
require 'magneto/context'
require 'magneto/core_ext'
require 'magneto/filter'
require 'magneto/filters'
require 'magneto/item'
require 'magneto/readable'
require 'magneto/render_context'
require 'magneto/script_context'
require 'magneto/site'
require 'magneto/template'

module Magneto

  VERSION = '0.1.0'

  class << self

    def application
      @application ||= Application.new
    end
  end
end
