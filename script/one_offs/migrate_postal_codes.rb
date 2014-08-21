# coding: utf-8

=begin
Addressのレコードのうち、postal_code1, postal_code2のフィールドが空のものを、
postal_codeフィールドからデータを作ってpostal_code1, postal_code2を埋める。

処理内容としては
postal_codeにデータがあり、postal_code1, postal_code2がNULLのレコードを取り出す
各レコードに対して：
  postal_codeの中身からハイフンを抜いた半角数字が七桁であれば：
    数字を3桁-4桁に分ける
    3桁の数字をpostal_code1に、4桁の数字をpostal_code2にセットする。
    コールバックが実行されないようにupdate_columnsで保存をする
=end

addresses = Address.where('postal_code IS NOT NULL AND postal_code1 IS NULL AND postal_code2 IS NULL')
puts "#{addresses.count} addresses found"
addresses.each do |address|
  m = /\A(\d\d\d)-?(\d\d\d\d)\Z/.match address.postal_code
  if m
    puts "postal_code1: #{address.postal_code1} => #{m[1]}"
    puts "postal_code2: #{address.postal_code2} => #{m[2]}"
    address.update_column(:postal_code1, m[1])
    address.update_column(:postal_code2, m[2])
  else
    puts "PATTERN NOT MATCHED: id:#{address.id}, postal_code:#{address.postal_code}"
  end
end
