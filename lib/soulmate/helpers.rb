# encoding: utf-8
# 
module Soulmate
  module Helpers

    def prefixes_for_phrase(phrase)
      words = normalize_for_load(phrase).split(' ').reject do |w|
        Soulmate.stop_words.include?(w)
      end
      words.map do |w|
        (MIN_COMPLETE-1..(w.length-1)).map{ |l| w[0..l] }
      end.flatten.uniq
    end

    def normalize_for_load(str)

      _str = str.gsub(/[\u200B-\u200D\uFEFF\u008C]/,' ')
      _str = _str.gsub(/[[:space:]]/,' ').strip     
      _str = _str.gsub(/[–!@%&"°-]/,' ').strip

      _str.downcase!

      utf8_to_tis620 = Iconv.new('TIS620', 'UTF-8')
      a = LibThai.brk_line(utf8_to_tis620.iconv(_str))

      tis620_to_utf8 = Iconv.new('UTF-8', 'TIS620')
      o = tis620_to_utf8.iconv(a)

      _str = _str + ' ' +o.split("|").join(" ")
      _str.split(" ").uniq.join(" ")
    end

    def normalize(str)
      # str.downcase.gsub(/[^a-z0-9 ]/i, '').strip
       # keep thai char    
      _str = str.gsub(/[!@%&"°]/,'').strip
      _str.downcase  
    end

  end
end