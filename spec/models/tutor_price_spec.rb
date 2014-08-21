# encoding:utf-8
require 'spec_helper'

describe TutorPrice do
  let(:student) {FactoryGirl.create(:student)}

  describe '.lesson_fee_from_hourly_wage' do
    it '時給が1350円なら1コマの授業料は1800円' do
      TutorPrice.lesson_fee_from_hourly_wage(1350).should == 1800
    end

    it '時給が1824円なら1コマの授業料は2400円' do
      TutorPrice.lesson_fee_from_hourly_wage(1824).should == 2400
    end

    it '時給が1824円なら1コマの授業料は2450円' do
      TutorPrice.lesson_fee_from_hourly_wage(1825).should == 2450
    end
  end

  describe '.ceil 50円単位での切り上げ計算' do
    it '1001は1050になる' do
      TutorPrice.ceil(1001).should == 1050
    end

    it '1050は1050のまま' do
      TutorPrice.ceil(1050).should == 1050
    end
  end

  describe '#lesson_extension_fee' do
    it '1コマ1500円のレッスン料なら延長料金は1000円' do
      price = TutorPrice.create!(hourly_wage:1350)
      price.stub(:lesson_unit_fee){1500}
      price.lesson_extension_fee(student).should == 1000
    end
  end

  describe '#lesson_unit_fee' do
    let(:tutor) {mock_model(Tutor)}

    context 'チューターが仮登録の場合' do
      before(:each) do
        TutorPriceHistory.stub(:create!)
        TutorPrice.any_instance.stub(:tutor){tutor}
        tutor.stub(:beginner?){true}
      end

      context 'チューターが現役学生の場合' do
        before(:each) do
          tutor.stub(:graduated?).and_return(false)
          @price = TutorPrice.create!(hourly_wage: 900)
        end

        it '受講者の学年割増がゼロ円なら1155円' do
          student.stub(:grade_premium){0}
          @price.lesson_unit_fee(student).should == 1155
        end

        it '受講者の学年割増が100円なら1260円' do
          student.stub(:grade_premium){100}
          @price.lesson_unit_fee(student).should == 1260
        end

        it '受講者の学年割増が50円なら1225円' do
          student.stub(:grade_premium){50}
          @price.lesson_unit_fee(student).should == 1225
        end

        it '受講者の学年割増が200円なら1365円' do
          student.stub(:grade_premium){200}
          @price.lesson_unit_fee(student).should == 1365
        end
      end

      context 'チューターが既卒の場合' do
        before(:each) do
          tutor.stub(:graduated?).and_return(true)
          @price = TutorPrice.create!(hourly_wage: 900)
        end

        it '受講者の学年割増がゼロ円なら1435円' do
          student.stub(:grade_premium){0}
          @price.lesson_unit_fee(student).should == 1435
        end

        it '受講者の学年割増が50円なら1505円' do
          student.stub(:grade_premium){50}
          @price.lesson_unit_fee(student).should == 1505
        end

        it '受講者の学年割増が100円なら1540円' do
          student.stub(:grade_premium){100}
          @price.lesson_unit_fee(student).should == 1540
        end

        it '受講者の学年割増が200円なら1645円' do
          student.stub(:grade_premium){200}
          @price.lesson_unit_fee(student).should == 1645
        end
      end
    end

    context 'チューターが本登録の場合' do
      before(:each) do
        TutorPriceHistory.stub(:create!)
        TutorPrice.any_instance.stub_chain('tutor.beginner?'){false}
        TutorPrice.any_instance.stub_chain('tutor.regular?'){true}
        TutorPrice.any_instance.stub_chain('tutor.graduated?'){true}
      end

      context '時給が1250円の場合' do
        before(:each) do
          @price = TutorPrice.create!(hourly_wage: 1250)
        end

        it '受講者の学年割増がゼロ円なら1650円' do
          student.stub(:grade_premium){0}
          @price.lesson_unit_fee(student).should == 1650
        end

        it '受講者の学年割増が100円なら1800円' do
          student.stub(:grade_premium){100}
          @price.lesson_unit_fee(student).should == 1800
        end

        it '受講者の学年割増が50円なら1750円' do
          student.stub(:grade_premium){50}
          @price.lesson_unit_fee(student).should == 1750
        end

        it '受講者の学年割増が200円なら950円' do
          student.stub(:grade_premium){200}
          @price.lesson_unit_fee(student).should == 1950
        end
      end
    end
  end

  describe '時給を変更する' do
    let(:tutor) {FactoryGirl.create(:tutor)}
    subject {tutor.price}

    it '#init_lesson_fee_tableが呼ばれる' do
      hourly_wage = subject.hourly_wage
      subject.should_receive(:init_lesson_fee_table)

      subject.update_attribute(:hourly_wage, hourly_wage + 100)
    end

    context 'チューターが本登録の場合' do
      before(:each) do
        Tutor.any_instance.stub(:beginner?){false}
      end

      it 'レッスン料金が変化する' do
        hourly_wage = subject.hourly_wage

        expect {
          subject.hourly_wage = hourly_wage + 100
          subject.save!
        }.to change{subject.reload.lesson_fee_0}
      end
    end
  end
end
