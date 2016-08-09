require "open-uri"

class SinaStock
    URL = 'http://hq.sinajs.cn/'
    CURR_DATA_REP = //

    attr_reader :stock_date,:stock_name

    def initialize(serial_num='sh600389',rel=nil)
        @serial_num = serial_num
        if rel
            curr_data = rel
        else
            curr_data = open(URL+'list='+serial_num){|f| f.read.encode('utf-8') }
        end
        parse_curr_data(curr_data)
    end

    def var_list
        [
            @stock_name,    #0 股票名字
            @today_open_price,  #1  今日开盘价
            @yesterday_closing_price,   #2 昨日收盘价
            @curr_price,    #3 当前价格
            @today_top,    #4 今日最高价
            @today_bottow,  #5 今日最低价
            @v6,            #6 竞买价，即“买一”报价
            @v7,            #7 竞卖价，即“卖一”报价
            @vol,    #8 成交的股票数
            @gmv,    #9 成交金额
            @v10,    #10 “买一”申请
            @v11,   #11 “买一”报价
            @v12    #12
        ]
    end

    def parse_curr_data(curr_data)
        if eff_data = curr_data.scan(/"(.*)"/)
            eff_data    = eff_data[0][0]
        else
            return nil
        end

rdata_list = eff_data.split(',')
        return nil if data_list.empty?

        ## data
        @stock_name             = data_list[0]    #0 股票名字
        @today_open_price       = data_list[1]  #1  今日开盘价
        @yesterday_closing_price= data_list[2]   #2 昨日收盘价
        @curr_price             = data_list[3]    #3 当前价格
        @today_top              = data_list[4]    #4 今日最高价
        @today_bottow           = data_list[5]  #5 今日最低价
        @vol                    = data_list[8]  #8 成交的股票数
        @gmv                    = data_list[9]  #9 成交金额
        ## data

        @stock_date = data_list[30]
        @stock_time = data_list[31]
    end

end

class TestSinaStock

    def test0
        puts "normal serial number "
        puts SinaStock.new('sh600389').var_list
        puts "false serial number "
        puts SinaStock.new('sh69').var_list
    end
end

TestSinaStock.new.test0
