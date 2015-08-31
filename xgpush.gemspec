Gem::Specification.new do |s|
  s.name = 'xgpush'
  s.version = '0.0.1'
  s.date = '2015-08-31'
  s.summary = 'XG Push'
  s.description = 'App push service by Tencent XG'
  s.authors = ['Chao Li']
  s.email = 'chaoli46@yahoo.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/chaoli46/xgpush'
  s.license = 'MIT'

  s.require_paths = ['lib']
  s.add_runtime_dependency 'rest-client', '~> 1.8'
end
