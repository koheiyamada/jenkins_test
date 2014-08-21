# coding:utf-8
require 'spec_helper'

describe AnswerBook do
  before(:each) do
    @sample_book_dir = Rails.root.join('spec', 'fixtures', 'answer_book', 'book1')
  end

  let(:textbook){FactoryGirl.create(:textbook)}
  subject{FactoryGirl.create(:answer_book, textbook:textbook, dir:@sample_book_dir)}

  describe '.create' do
    it 'テキストと画像ディレクトリがあればOK' do
      textbook = FactoryGirl.create(:textbook)
      AnswerBook.new(textbook:textbook, dir:@sample_book_dir).should be_valid
    end

    it 'テキストが要る' do
      AnswerBook.new(textbook:nil, dir:@sample_book_dir).should_not be_valid
    end

    it '画像ディレクトリが要る' do
      textbook = FactoryGirl.create(:textbook)
      AnswerBook.new(textbook:textbook, dir:nil).should_not be_valid
    end

    it '存在しないディレクトリじゃないとだめ' do
      AnswerBook.new(textbook:textbook, dir: '/non/existent/dir').should_not be_valid
    end

    it 'ディレクトリには画像が要る' do
      empty_dir = Rails.root.join('spec', 'fixtures', 'answer_book', 'empty_book')
      AnswerBook.new(textbook:textbook, dir: empty_dir).should_not be_valid
    end
  end

  #describe 'detect_size' do
  #  it '高さがセットされる' do
  #    expect {
  #      subject.detect_size
  #    }.to change{subject.height}.from(nil)
  #  end
  #
  #  it '幅がセットされる' do
  #    expect {
  #      subject.detect_size
  #    }.to change{subject.height}.from(nil)
  #  end
  #end

  describe '#pages' do
    it 'ページ数（画像数）を返す' do
      subject.pages.should == 3
    end
  end

  describe '#file_path' do
    it '指定したページの画像のパスを返す' do
      path = subject.file_path(1)
      path.should match(/1\.png$/)
    end

    it 'ファイルが存在する' do
      (1 .. subject.pages).each do |page|
        path = subject.file_path(page)
        File.exists?(path).should be_true
      end
    end
  end
end
