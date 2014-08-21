住所データの更新方法
=================


0. 更新用データを作成する（aid-dataリポジトリで作成する）
1. データベースのpostal_codesテーブルを全入れ替えする。
2. 複数のエリアコードが割り当てられている郵便番号のエリアコードを確定する。
3. 各郵便番号のエリアコード数を更新する。


# 住所データ更新

```
$ bundle exec rails runner script/addresses/update_addresses.rb db/data/postal_codes/addresses.csv
$ bundle exec rails runner script/addresses/area_code_select.rb db/data/postal_codes/aid-ken-all-trimmed.csv
$ bundle exec rails runner script/addresses/reset_area_codes_count.rb
```


# 郵便番号テーブルも作り直すなら

上の住所データ更新シーケンスを実行する*前*に以下の処理を実行する。

```
$ bundle exec rails runner script/addresses/clear_all_postal_codes.rb
$ bundle exec rails runner db/seeds-heavy/zip_codes.rb
$ bundle exec rails runner db/seeds-heavy/area_codes.rb
```

ここでやっているのは次のことである。

- postal_codesテーブルとzip_codesテーブルを削除
- zip_codesテーブルにデータを入れる
