task default: %w(test)

desc 'test'
task :spec, :spec_name, :examples do |_t, args|
  require 'rspec/core/rake_task'
  execute_spec = lambda do |function_name|
    RSpec::Core::RakeTask.new do |st|
      st.rspec_opts = "--format d --color #{@example}"
      st.pattern = "spec/#{function_name}_spec.rb" if function_name
    end
  end
  if args.spec_name
    if args.examples
      @example = ''
      example_array = args.examples.split(' ')
      example_array.each { |e| @example += "--example '#{e}' " }
    end
    execute_spec.call(args.spec_name)
  else
    execute_spec.call(nil)
  end
end

desc 'generate settings.yml'
task :init do
  require 'yaml'
  file = File.open('settings.yml', 'w+')
  settings = { access_id: nil, secret_key: nil }.to_yaml
  file.puts '# http://developer.xg.qq.com/index.php/Rest_API'
  file.puts settings
  file.close
  puts './settings.yml created.'
end

desc 'build gem'
task :build do
  Dir.glob('*push-*.gem').each { |f| File.delete(f) }
  puts `bundle exec gem build qqpush.gemspec`
end

desc 'publish gem'
task :push do
  files = Dir.glob('*push-*.gem')
  if files.size == 1
    gem_file = files[0]
    puts `bundle exec gem push #{gem_file}`
  else
    if files.size == 0
      puts "No gem file. Run 'bundle exec rake build' at first."
    else
      puts 'Too many gem files:'
      puts files
    end
  end
end
