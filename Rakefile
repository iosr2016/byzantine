Dir.glob('lib/tasks/*.rake').each { |r| load r }

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

task default: [:rubocop, :spec]
