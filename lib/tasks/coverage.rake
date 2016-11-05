desc 'Analyze code test coverage'
task :coverage do
  require 'launchy'

  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
  Launchy.open 'coverage/index.html'
end
