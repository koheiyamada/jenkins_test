# coding:utf-8

=begin
  postal_codesテーブルからデータを読んで標準出力に出力する。
  ファイル形式はCSV、文字コードはUTF-8。
=end

PostalCode.scoped.find_each do |postal_code|
  puts "#{postal_code.postal_code},#{postal_code.area_code},#{postal_code.prefecture},#{postal_code.city},#{postal_code.town}"
end
