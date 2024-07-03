$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'magneto'

Gem::Specification.new do |s|
  s.name              = 'magneto'
  s.version           = Magneto::VERSION
  s.summary           = 'A static site generator.'
  s.description       = 'Magneto is a static site generator.'
  s.authors           = ['Lisa Melton']
  s.email             = '115488+lisamelton@users.noreply.github.com'
  s.homepage          = 'https://github.com/lisamelton/magneto'
  s.files             = Dir['{bin,lib}/**/*'] + Dir['[A-Z]*'] + ['magneto.gemspec']
  s.executables       = ['magneto']
  s.extra_rdoc_files  = ['LICENSE']
  s.require_paths     = ['lib']
end
