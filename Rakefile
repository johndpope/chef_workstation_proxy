require "./chef_workstation_proxy"
require 'rake/testtask'
Dir.glob('lib/tasks/*.rake').each { |r| load r}
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
