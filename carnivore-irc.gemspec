$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'carnivore-irc/version'
Gem::Specification.new do |s|
  s.name = 'carnivore-irc'
  s.version = Carnivore::Irc::VERSION.version
  s.summary = 'Message processing helper'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/carnivore-rb/carnivore-irc'
  s.description = 'Carnivore IRC source'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_dependency 'carnivore', '>= 0.1.8'
  s.add_dependency 'celluloid-io'
  s.add_dependency 'messagefactory'
  s.add_dependency 'baseirc'
  s.files = Dir['**/*']
end
