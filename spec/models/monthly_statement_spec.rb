# coding:utf-8
require 'spec_helper'

describe MonthlyStatement do
  let(:parent) {FactoryGirl.create(:active_parent)}
  let(:student) {FactoryGirl.create(:active_student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:today) {Date.today}

  describe "作成" do
    it "owner, year, monthがあれば作成できる" do
      expect {
        MonthlyStatement.create!(owner:student, year:today.year, month:today.month)
      }.to change(MonthlyStatement, :count).by(1)
    end

    it "ownerが要る" do
      MonthlyStatement.new(owner:nil, year:today.year, month:today.month).should be_invalid
    end

    it "yearが要る" do
      MonthlyStatement.new(owner:student, year:nil, month:today.month).should be_invalid
    end

    it "monthが要る" do
      MonthlyStatement.new(owner:student, year:today.year, month:nil).should be_invalid
    end
  end

  describe "#calculate 月の結果を集計する" do
    subject{MonthlyStatement.create!(owner:student, year:today.year, month:today.month)}

    context "料金発生イベントが何もない" do
      before(:each) do
        student
        Student.any_instance.stub(:created_at){-2.months.from_now} # ID管理費は入会翌月から
      end

      it "毎月の料金がある" do
        subject.calculate
        subject.items.should_not be_empty
      end
    end

    context "オプションレッスンがある場合" do
      before(:each) do
        now = Time.now
        subject = FactoryGirl.create(:subject)
        Time.stub(:now).and_return(now.change(:day => 1))
        lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject,
                                     students: [student], start_time: 1.hour.from_now,
                                     units: 1)
        lesson.establish
        lesson.journalize!
      end

      it "オプションレッスン受講料の項目ができる" do
        expect {
          subject.calculate
        }.to change{MonthlyStatement.find(subject.id).items.of_type(Account::OptionalLessonFee).count}
      end
    end

    context "ベーシックレッスンがある場合" do
      before(:each) do
        now = Time.now
        Time.stub(:now).and_return(now.change(:day => 1))
        course = FactoryGirl.create(:basic_lesson_info, tutor:tutor, students:[student])
        t = 1.month.since(now).change(day: SystemSettings.cutoff_date) # 今月のベーシックレッスン料は来月授業分
        lesson = FactoryGirl.create(:basic_lesson, course:course, start_time: t)
        lesson.establish
        lesson.should be_established
        lesson.journalize!
      end

      it "計算をすると項目数が増える" do
        expect {
          subject.calculate
        }.to change{MonthlyStatement.find(subject.id).items.count}.from(0)
      end
    end
  end

  describe "::calculate_for_all" do
    it 'MonthlyStatementCalculationを作成する' do
      expect {
        MonthlyStatement.calculate_for_all(today.year, today.month)
      }.to change(MonthlyStatementCalculation, :count).by(1)
    end

    it 'MonthlyStatementCalculation#executeを実行する' do
      MonthlyStatementCalculation.any_instance.should_receive(:execute)

      MonthlyStatement.calculate_for_all(today.year, today.month)
    end
  end

  describe "::calculate_for_all_and_charge_the_payment_of_all_students" do
    it "は::calculate_for_allと::charge_the_payment_of_all_studentsが呼び出される" do
      year = Date.today.year
      month = Date.today.month
      MonthlyStatement.should_receive(:calculate_for_all).with(year, month)
      MonthlyStatement.should_receive(:charge_the_payment_of_all_students).with(year, month)
      MonthlyStatement.calculate_for_all_and_charge_the_payment_of_all_students(year, month)
    end
  end

  describe "::charge_the_payment_of_all_students" do
    context "が引数なしで呼び出された場合" do
      it "は::charge_the_payment_of_all_dependent_studentsと::charge_the_payment_of_all_independent_studentsが呼び出される" do
        MonthlyStatement.should_receive(:charge_the_payment_of_all_dependent_students).with(today.year, today.month)
        MonthlyStatement.should_receive(:charge_the_payment_of_all_independent_students).with(today.year, today.month)
        MonthlyStatement.charge_the_payment_of_all_students(today.year, today.month)
      end
    end

    context "が引数ありで呼び出された場合" do
      let(:year) { rand(2013..2020) }
      let(:month) { rand(1..12) }

      it "は::charge_the_payment_of_all_dependent_studentsと::charge_the_payment_of_all_independent_studentsが引数付きで呼び出される" do
        MonthlyStatement.should_receive(:charge_the_payment_of_all_dependent_students).with(year, month)
        MonthlyStatement.should_receive(:charge_the_payment_of_all_independent_students).with(year, month)
        MonthlyStatement.charge_the_payment_of_all_students(year, month)
      end
    end
  end

  describe "::charge_the_payment_of_all_dependent_students" do
    before(:each) do
      parents_number = 3

      @parents = parents_number.times.map do |index|
        FactoryGirl.create(:parent, active:true) do |parent|
          (index + 1).times do
            FactoryGirl.create(:active_student, parent:parent, active:true)
          end
        end
      end

      def @parents.find_each(&block)
        each(&block)
      end

      @independent_student = FactoryGirl.create(:active_student, active:true)
      Parent.stub(:only_active) { @parents }
    end

    pending "月次集計の前に退会した場合、activeではなくなる？その場合課金も走らないのでは"

    context "が引数なしで呼び出された場合" do
      it "は親のいる**支払い済みでない**生徒の料金支払いを実行する" do
        @parents.each do |parent|
          expect_value = 0
          parent.reload.students.each do |student|
            amount = rand(100..100000)
            expect_value += amount
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:today.year, month:today.month, paid:false,
              amount_of_payment:amount,
            })
            student.should_not_receive(:payment)
          end
          parent.should_receive(:payment).with(expect_value)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:today.year, month:today.month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(today.year, today.month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:false, year:today.year,
                                             month:today.month).should be_empty
          end
        end
      end

      it "は親のいる**支払い済みの**生徒の料金支払いは実行しない" do
        @parents.each do |parent|
          parent.students.each do |student|
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:today.year, month:today.month, paid:true,
              amount_of_payment:rand(100..100000),
            })
            student.should_not_receive(:payment)
          end
          parent.should_not_receive(:payment)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:today.year, month:today.month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(today.year, today.month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:false, year:today.year,
                                             month:today.month).should be_empty
          end
        end
      end

      it "は今月のものでない料金支払いは実行しない" do
        months = (1..12).to_a.delete_if {|x| x == today.month}
        @parents.each do |parent|
          amount = rand(100..100000)
          parent.students.each do |student|
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:today.year, month:months.sample, paid:false,
              amount_of_payment:amount,
            })
            student.should_not_receive(:payment)
          end
          parent.should_not_receive(:payment).with(amount)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:today.year, month:today.month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(today.year, today.month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        # 支払い済みになっていないことのテスト
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:true, year:today.year,
                                             month:today.month).should be_empty
          end
        end

        pa = @parents[0]
        st = pa.reload.students.first
        amount = rand(100..100000)
        FactoryGirl.create(:monthly_statement, {
          owner:st, year:today.year, month:today.month,
          paid:false, amount_of_payment:amount,
        })
        # 支払いが実行されているテスト
        pa.should_receive(:payment).with(amount)
        expect {
          MonthlyStatement.charge_the_payment_of_all_dependent_students(today.year, today.month)
        }.to change{
          st.monthly_statements.find_by_year_and_month(today.year, today.month).paid
        }.from(false).to(true)
      end
    end

    context "が引数ありで呼び出された場合" do
      let(:year) { rand(2013..2020) }
      let(:month) { rand(1..12) }

      it "は親のいる**支払い済みでない**生徒の料金支払いを実行する" do
        @parents.each do |parent|
          expect_value = 0
          parent.reload.students.each do |student|
            amount = rand(100..100000)
            expect_value += amount
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:year, month:month, paid:false,
              amount_of_payment:amount,
            })
            student.should_not_receive(:payment)
          end
          parent.should_receive(:payment).with(expect_value)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:year, month:month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(year, month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:false, year:year,
                                             month:month).should be_empty
          end
        end
      end

      it "は親のいる**支払い済みの**生徒の料金支払いは実行しない" do
        @parents.each do |parent|
          parent.students.each do |student|
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:year, month:month, paid:true,
              amount_of_payment:rand(100..100000),
            })
            student.should_not_receive(:payment)
          end
          parent.should_not_receive(:payment)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:year, month:month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(year, month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:false, year:year,
                                             month:month).should be_empty
          end
        end
      end

      it "は引数で渡された年月のものでない料金支払いは実行しない" do
        months = (1..12).to_a.delete_if {|x| x == month}
        @parents.each do |parent|
          amount = rand(100..100000)
          parent.students.each do |student|
            FactoryGirl.create(:monthly_statement, {
              owner:student, year:year, month:months.sample, paid:false,
              amount_of_payment:amount,
            })
            student.should_not_receive(:payment)
          end
          parent.should_not_receive(:payment).with(amount)
        end
        FactoryGirl.create(:monthly_statement, {
          owner:@independent_student, year:year, month:month,
          paid:false, amount_of_payment:rand(1000..100000),
        })
        @independent_student.should_not_receive(:payment)
        parent.should_not_receive(:payment)

        # tests
        MonthlyStatement.charge_the_payment_of_all_dependent_students(year, month)
        @independent_student.monthly_statements.find_by_paid(true).should be_blank
        # 支払い済みになっていないことのテスト
        @parents.each do |parent|
          parent.students.each do |student|
            student.monthly_statements.where(paid:true, year:year,
                                             month:month).should be_empty
          end
        end

        pa = @parents[0]
        st = pa.reload.students.first
        amount = rand(100..100000)
        FactoryGirl.create(:monthly_statement, {
          owner:st, year:year, month:month,
          paid:false, amount_of_payment:amount,
        })
        # 支払いが実行されているテスト
        pa.should_receive(:payment).with(amount)
        expect {
          MonthlyStatement.charge_the_payment_of_all_dependent_students(year, month)
        }.to change{
          st.monthly_statements.find_by_year_and_month(year, month).paid
        }.from(false).to(true)
      end
    end
  end

  describe "::charge_the_payment_of_all_independent_students" do
    before(:each) do
      FactoryGirl.create(:parent, active:true) do |parent|
        @dependent_students = 3.times.map do
          student = FactoryGirl.create(:active_student, parent:parent, active:true)
          student.should_not_receive(:payment)
          student
        end
        parent.should_not_receive(:payment)
      end

      @independent_students = 3.times.map {
        FactoryGirl.create(:active_student, active:true)
      }

      students = @dependent_students + @independent_students
      def students.find_each(&block)
        each(&block)
      end

      Student.stub(:only_active) { students }
    end

    context "が引数なしで呼び出された場合" do
      it "は**親のいない支払い済みでない生徒**の料金支払いを実行する" do
        @independent_students.each do |student|
          amount = rand(100..100000)
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:today.month, paid:false,
            amount_of_payment:amount,
          })
          student.should_receive(:payment).with(amount)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:today.month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(today.year, today.month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:false, year:today.year,
                               month:today.month).should be_empty
      end

      it "は**親のいない支払い済みの生徒**の料金支払いは実行しない" do
        @independent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:today.month, paid:true,
            amount_of_payment:rand(100..100000),
          })
          student.should_not_receive(:payment)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:today.month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(today.year, today.month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:false, year:today.year,
                               month:today.month).should be_empty
      end

      it "は今月のものでない料金支払いは実行しない" do
        months = (1..12).to_a.delete_if {|x| x == today.month}
        amount = rand(100..100000)
        @independent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:months.sample, paid:false,
            amount_of_payment:amount,
          })
          student.should_not_receive(:payment).with(amount)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:today.year, month:today.month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(today.year, today.month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:true, year:today.year,
                               month:today.month).should be_empty

        st = @independent_students[0]
        amount = rand(100..100000)
        FactoryGirl.create(:monthly_statement, {
          owner:st, year:today.year, month:today.month,
          paid:false, amount_of_payment:amount,
        })
        # 支払いが実行されているテスト
        st.should_receive(:payment).with(amount)
        expect {
          MonthlyStatement.charge_the_payment_of_all_independent_students(today.year, today.month)
        }.to change{
          st.monthly_statements.find_by_year_and_month(today.year, today.month).paid
        }.from(false).to(true)
      end
    end

    context "が引数ありで呼び出された場合" do
      let(:year) { rand(2013..2020) }
      let(:month) { rand(1..12) }

      it "は**親のいない支払い済みでない生徒**の料金支払いを実行する" do
        @independent_students.each do |student|
          amount = rand(100..100000)
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:month, paid:false,
            amount_of_payment:amount,
          })
          student.should_receive(:payment).with(amount)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(year, month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:false, year:year,
                               month:month).should be_empty
      end

      it "は**親のいない支払い済みの生徒**の料金支払いは実行しない" do
        @independent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:month, paid:true,
            amount_of_payment:rand(100..100000),
          })
          student.should_not_receive(:payment)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(year, month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:false, year:year,
                               month:month).should be_empty
      end

      it "は今月のものでない料金支払いは実行しない" do
        months = (1..12).to_a.delete_if {|x| x == month}
        amount = rand(100..100000)
        @independent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:months.sample, paid:false,
            amount_of_payment:amount,
          })
          student.should_not_receive(:payment).with(amount)
        end
        @dependent_students.each do |student|
          FactoryGirl.create(:monthly_statement, {
            owner:student, year:year, month:month,
            paid:false, amount_of_payment:rand(1000..100000),
          })
          student.should_not_receive(:payment)
        end

        # tests
        MonthlyStatement.charge_the_payment_of_all_independent_students(year, month)
        MonthlyStatement.where(owner_id:@dependent_students.map(&:id), paid:true).should be_empty
        MonthlyStatement.where(owner_id:@independent_students.map(&:id),
                               paid:true, year:year,
                               month:month).should be_empty

        st = @independent_students[0]
        amount = rand(100..100000)
        FactoryGirl.create(:monthly_statement, {
          owner:st, year:year, month:month,
          paid:false, amount_of_payment:amount,
        })
        # 支払いが実行されているテスト
        st.should_receive(:payment).with(amount)
        expect {
          MonthlyStatement.charge_the_payment_of_all_independent_students(year, month)
        }.to change{
          st.monthly_statements.find_by_year_and_month(year, month).paid
        }.from(false).to(true)
      end
    end
  end

  describe '.settle' do
    let(:dir) {Rails.root.join('public', 'yucho_accounts')}

    before(:each) do
      @year = Date.today.year
      @month = Date.today.month
      YuchoAccountService.any_instance.stub(:directory_of_month){dir}
    end

    around(:each) do |test|
      FileUtils.remove_dir(dir) if File.exist?(dir)
      test.call()
      FileUtils.remove_dir(dir) if File.exist?(dir)
    end

    it 'calculate_for_all_and_charge_the_payment_of_all_studentsとprint_yucho_dealsを呼ぶ' do
      MonthlyStatement.should_receive(:calculate_for_all_and_charge_the_payment_of_all_students)
      YuchoAccountService.any_instance.should_receive(:compile_billings_and_payments_files)

      MonthlyStatement.settle
    end

    it '２つのCSVファイルを出力する' do
       expect {
        MonthlyStatement.settle
      }.to change{File.exist?(dir)}.from(false).to(true)
    end
  end
end
