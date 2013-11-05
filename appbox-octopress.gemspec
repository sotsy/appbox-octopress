Gem::Specification.new do |s|
  s.name        = 'appbox-octopress'
  s.version     = '0.0.2'
  s.date        = '2013-11-04'
  s.summary     = "AppBox Octopress"
  s.description = "Parse and visualize data from AppStore and GooglePlay Store to display it in Octopress or Jekyll posts"
  s.authors     = ["Philipp Jaeckel"]
  s.email       = 'mail@sots.name'
  s.files       = ["lib/appbox_octopress.rb"]
  s.homepage    =
    'https://github.com/sotsy/appbox-octopress/'

  s.files       = Dir.glob('lib/**/*')
  s.files       += Dir.glob('bin/*')
  s.files       += Dir.glob('templates/**/*')
  s.require_path = 'lib'
  s.executables = ['appbox-octopress']

  s.license       = 'MIT'
end