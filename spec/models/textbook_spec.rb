# coding:utf-8
require 'spec_helper'

describe Textbook do
  let(:dir){Rails.root.join('spec/fixtures/textbook/book1')}
  let(:empty_dir){Rails.root.join('spec/fixtures/textbook/empty_book')}
  subject{FactoryGirl.create(:textbook, dir: dir)}

  describe '.create' do
    it 'テキストと画像ディレクトリがあればOK' do
      subject.should be_valid
    end

    it '画像ディレクトリが要る' do
      textbook = FactoryGirl.build(:textbook, dir: nil)
      textbook.should_not be_valid
    end

    it '存在しないディレクトリじゃないとだめ' do
      FactoryGirl.build(:textbook, dir: '/non/existent/dir').should_not be_valid
    end

    it 'ディレクトリには画像が要る' do
      textbook = FactoryGirl.build(:textbook, dir: empty_dir)
      textbook.should_not be_valid
      textbook.errors[:dir].should be_present
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
