require_relative './../env_initial'
require "open-uri"
require "csv"
require "timeout"
require "yahoo_date"
require "company"

class YahooTable

    def initialize(serial_num,begin_time=Time.now-(60*60*24*60),end_time=Time.now)
        if serial_num.is_a? Company
            @serial_num = serial_num.am_stock_serial_num
            @curr_company = serial_num
        else
            @serial_num = serial_num
            @curr_company = Company.find_by(am_stock_serial_num: @serial_num)
        end
        @uri_path = "http://ichart.finance.yahoo.com/table.csv?s=#{@serial_num}.sz&d=#{end_time.mon-1}&e=#{end_time.day}&f=#{end_time.year}&a=#{begin_time.mon-1}&b=#{begin_time.day}&c=#{begin_time.year}"

        # puts @uri_path
    end

    def parse_uri_csv
        csv = nil
        Timeout::timeout(5) do
            csv = open(@uri_path){|f| f.read }
        end

        CSV::parse(csv,headers: true) do |row|
            unless  @curr_company.yahoo_dates.find_by(:date => row[0])
                @curr_company.yahoo_dates << YahooDate.create(date:row[0],open:row[1],high:row[2],low:row[3],close:row[4],vol:row[5],adj_close:row[6])
            end
        end
    rescue Timeout::Error
        i = 0 unless i
        if i < 5
            i += 1;
            retry
        else
            puts "False URL #{@uri_path}"
            return nil
        end
    rescue OpenURI::HTTPError
        i = 0 unless i
        if i < 5
            i += 1;
            retry
        else
            puts "CAN'T CONNECT URL #{@uri_path}"
            return nil
        end
    end

    def self.sync_all_stocks
        total = Company.count
        i = 1
        Company.find_each do |c|
            puts "#{i}/#{total} ::: synchro #{c.full_name} yahoo 60 days data"
            YahooTable.new(c).parse_uri_csv
            i += 1
        end
    end

    def self.sync_leaved_stocks
        total = Company.count
        i = 1
        Company.find_each do |c|
            if c.yahoo_dates.count < 30
                puts "#{i}/#{total} ::: synchro #{c.full_name} yahoo 60 days data"
                YahooTable.new(c).parse_uri_csv
            end
            i += 1
        end
    end

end


class TestYahooTable

    def test_0
        serial_num = "300072"
        EnvInitial::clear_test_database
        curr_company = Company.find_by(am_stock_serial_num:serial_num)
        EnvInitial::load_test_database
        Company.create(curr_company.attributes)

        yt = YahooTable.new(serial_num,Time.new(2016,7,3),Time.new(2016,8,3))
        yt.parse_uri_csv
    end

    def test_1
        serial_num = "300072"
        # EnvInitial::clear_test_database
        EnvInitial::load_test_database
        # curr_company = Company.find_by(am_stock_serial_num:serial_num)
        # Company.create(curr_company.attributes)

        yt = YahooTable.new(serial_num)
        yt.parse_uri_csv
    end

    def test_2
        serial_nums = %w{300073 300070 300075}
        curr_companies = []
        EnvInitial::clear_test_database
        serial_nums.each do |s|
            curr_companies << Company.find_by(am_stock_serial_num:s)
        end
        EnvInitial::load_test_database
        curr_companies.each do |curr_company|
            Company.create(curr_company.attributes)
        end

        YahooTable.sync_all_stocks
    end


end

if ARGV[0] == "test_0"
    TestYahooTable.new.test_0
elsif ARGV[0] == "test_1"
    TestYahooTable.new.test_1
elsif ARGV[0] == "test_2"
    TestYahooTable.new.test_2
elsif ARGV[0] == "sync_all"
    YahooTable.sync_all_stocks
elsif ARGV[0] == "sync_leaved"
    YahooTable.sync_leaved_stocks
end
