require "rubygems"
# require "activesupport"
require 'active_record'
require 'yaml'
require "sqlite3"
require "dbi"

ROOT = File.join(File.expand_path(File.dirname(__FILE__)),'')

['/lib','/db'].each do |folder|
    $: << File.join(ROOT,folder)
end

LogFile = File.join(ROOT,'/log/debug.log')
YmlFile = File.join(ROOT,'/config/database.yml')

cfg_hash = YAML::load(File.open(YmlFile))

####=============================
tmp = File.join(ROOT,".tmp")
system("rm -f #{tmp}")
system("rm -f #{cfg_hash["test"]["database"]}")

system("sqlite3 #{cfg_hash["default"]["database"]} .schema >> #{tmp}")
db = SQLite3::Database.new(cfg_hash["test"]["database"])
# puts db.methods
# puts db.schema_cookie
# puts db.database_list
# puts db.table_info("num")
# db.collation
lines = []
File.open(tmp){|f| lines = f.readlines }
lines.each do |l|
    db.execute(l)
end
system("rm -f #{tmp }")

db.close


# ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
# ActiveRecord::Base.establish_connection(cfg_hash["test"])

# db = DBI::connect("dbi:SQLite3:database=#{cfg_hash["test"]["database"]};host=localhost")
# db.disconnect
