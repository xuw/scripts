1.upto 49 do |file|

fileObj = File.new("/Users/xuw/big_data_course/#{file}.html", "r")
  while (line = fileObj.gets)

    if (line =~ /data-mp4-source="([^"]*)"/)
      p $1
    end

    # if (line =~ /data-sub="([^"]*)"/)
    #   p $1
    # end

  end
fileObj.close

end