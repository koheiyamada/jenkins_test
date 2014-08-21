# coding:utf-8

describe 'Skype format' do
  subject {/\A[a-zA-Z][a-zA-Z0-9.,-_]{5,31}\Z/}

  it '６文字から３２文字、先頭は英字、それ以降は英字、数字、.,_-' do
    subject.match('abcdef').should_not be_nil
    subject.match('a-----').should_not be_nil
    subject.match('a00000').should_not be_nil
    subject.match('a,,,,,').should_not be_nil
    subject.match('a_____').should_not be_nil
    subject.match('a.....').should_not be_nil
    subject.match('A.....').should_not be_nil
  end

  it '５文字以下はマッチしない' do
    subject.match('abcde').should be_nil
  end

  it '32文字までしかマッチしない' do
    subject.match('abcdefghabcdefghabcdefghabcdefgha').should be_nil
  end

  it '先頭はアルファベットのみ' do
    subject.match('0abcdef').should be_nil
    subject.match('.abcdef').should be_nil
    subject.match(',abcdef').should be_nil
    subject.match('-abcdef').should be_nil
    subject.match('_abcdef').should be_nil
  end
end