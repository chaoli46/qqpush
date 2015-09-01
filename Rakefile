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

desc 'build gem'
task :build do
  `bundle exec gem build xgpush.gemspec`
end
