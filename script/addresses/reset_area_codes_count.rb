# coding:utf-8

=begin
郵便番号事のエリアコード数を更新する。
=end

count = 0
ZipCode.scoped.find_each do |z|
  ZipCode.reset_counters z.id, :area_codes
  count += 1
  if count % 500 == 0
    puts "#{count} records updated."
  end
end
