# -*- encoding: utf-8 -*-
# To change this template, choose Tools | Templates
# and open the template in the editor.

class String
  
  #
  # ===アンダースコア⇒キャメル変換
  # @return:: キャメル変換後の文字列（先頭小文字）
  #
  def mdk_camelize
    return self if self.size < 1

    result = false
    self.split("_").collect do |phrase|
      if result
        phrase = phrase.capitalize
      end
      result = true
      phrase
    end.join
  end

  #
  # ===キャメル⇒アンダースコア変換
  # @return:: アンダースコア変換後の文字列
  #
  def mdk_underscore
    return self if self.size < 1
    
    self.gsub(/\b\w/){|word| word.downcase}.gsub(/[A-Z]/){|word|"_" + word.downcase}
  end

end