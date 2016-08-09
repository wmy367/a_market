require "rubygems"
# require "activesupport"
require 'active_record'
require 'yaml'

ROOT = File.join(File.expand_path(File.dirname(__FILE__)),'')

['/lib','/db'].each do |folder|
    $: << File.join(ROOT,folder)
end

LogFile = File.join(ROOT,'/log/debug.log')
YmlFile = File.join(ROOT,'/config/database.yml')

cfg_hash = YAML::load(File.open(YmlFile))
puts cfg_hash
# ActiveRecord::Base.configurations = YAML::load(IO.read(YmlFile))

task :default => :migrate

task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(cfg_hash["default"])
end
