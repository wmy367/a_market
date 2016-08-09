require 'rubygems'
require 'active_record'
require 'yaml'

ROOT = File.join(File.expand_path(File.dirname(__FILE__)),'')

SUB_ROOT = (Dir::entries(ROOT)-%w{. ..}).select {|f| File.directory? File.join(ROOT,f) }

SUB_ROOT.each do |folder|
    $: << File.join(ROOT,folder)
end

LogFile = File.join(ROOT,'/log/debug.log')
YmlFile = File.join(ROOT,'/config/database.yml')
ModelFile = File.join(ROOT,'/model/models.rb')

## connect to database
dbconfig = YAML::load(File.open(YmlFile))
ActiveRecord::Base.establish_connection(dbconfig["default"])

## load models

class EnvInitial
    YMLFILE = File.join(ROOT,'/config/database.yml')
    DBCONFIG = YAML::load(File.open(YMLFILE))
    ROOT = File.join(File.expand_path(File.dirname(__FILE__)),'')

    def self.load_test_database
        puts "load test database"
        ActiveRecord::Base.establish_connection(DBCONFIG["test"])
    end

    def self.clear_test_database
        tmp = File.join(ROOT,".tmp")
        system("rm -f #{tmp}")
        system("rm -f #{DBCONFIG["test"]["database"]}")

        system("sqlite3 #{DBCONFIG["default"]["database"]} .schema >> #{tmp}")
        db = SQLite3::Database.new(DBCONFIG["test"]["database"])
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
    end
end

require ModelFile
