$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'magneto'

Gem::Specification.new do |s|
  s.name              = 'magneto'
  s.version           = Magneto::VERSION
  s.summary           = 'A static site generator.'
  s.description       = 'Magneto is a static site generator.'
  s.authors           = ['Don Melton']
  s.email             = 'don@blivet.com'
  s.homepage          = 'https://github.com/donmelton/magneto'
  s.files             = Dir['{bin,lib}/**/*'] + Dir['[A-Z]*'] + ['magneto.gemspec']
  s.executables       = ['magneto']
  s.extra_rdoc_files  = ['LICENSE']
  s.require_paths     = ['lib']
end
