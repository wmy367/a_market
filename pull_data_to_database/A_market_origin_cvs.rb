require_relative './../env_initial'
require "csv"
require "company"

def gen_hash(keys,values)
    a = []
    if keys.size > values.size
        kv = values
    else
        kv = keys
    end

    kv.each_index do |i|
        a << keys[i]
        a << values[i]
    end

    Hash[*a]
end


def gen_companies_db(origin_csv)
    kk = 0
    file_cvs = CSV.open(origin_csv,options={col_sep:";",headers: true})
    file_cvs.each do |row|
        # next if row[0] !~  /^\d+$/
        hash_cate = {
            :am_stock_serial_num    => row[0],
            :short_name => row[1],
            :full_name  => row[2],
            :english_name => row[3],
            :location => row[4],
            :am_stock_name => row[6],
            :public_date => parse_date(row[7]),
            :all_shares => row[8].gsub(',','').to_i,
            :tradable_shares    => row[9].gsub(',','').to_i,
            :area   => row[15],
            :province   => row[16],
            :city       => row[17],
            :industry   => row[18],
            :url        => row[19]
        }

        if curr_cmp = Company.find_by(am_stock_serial_num: row[0])
            curr_cmp.update(hash_cate)
        else
            Company.create(hash_cate)
        end

    end
    file_cvs.close
end

def parse_date(d="1991-04-04")
    if md = /(?<year>\d+)-(?<mouth>\d+)-(?<day>\d+)/.match(d)
        Time.new(md[:year],md[:mouth],md[:day])
    end
end

# CSV::DEFAULT_OPTIONS[:col_rep] = ';'

gen_companies_db('上市公司列表.csv')
