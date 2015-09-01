Gem::Specification.new do |s|
  s.name = 'qqpush'
  s.version = '0.0.5'
  s.date = '2015-08-31'
  s.summary = 'Tencent XG Push'
  s.description = 'App push service by Tencent XG'
  s.authors = ['Chao Li']
  s.email = 'chaoli46@yahoo.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/chaoli46/qqpush'
  s.license = 'MIT'

  s.require_paths = ['lib']
  s.add_runtime_dependency 'rest-client', '~> 1.7'
  s.add_development_dependency 'rspec', '~> 3.3'
end
