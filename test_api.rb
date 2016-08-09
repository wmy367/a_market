require "open-uri"

def test_api
    data =  open('http://hq.sinajs.cn/list=sh600389,sh600390'){|f| f.read}
    puts data.encode('utf-8','gbk')
end

test_api
