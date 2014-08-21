# coding:utf-8

module SearchUtils
  extend self

  def normalize_key(key)
    key.tr '　', ' '
  end
end