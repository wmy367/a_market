MODEL_PATH = File.join(File.expand_path(File.dirname(__FILE__)),'')

file_array = Dir::entries(MODEL_PATH)-%w{. .. models.rb}

file_array = file_array.select {|f| File.file?(File.join(MODEL_PATH,f)) }

file_array.each do |f|
    require_relative f
end
