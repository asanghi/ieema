# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

desc 'Load the seed data from db/seeds.rb'
task :seed => :environment do
  seed_file = File.join(Rails.root, 'db', 'seeds.rb')
  load(seed_file) if File.exist?(seed_file)
end
