# encoding:utf-8
require 'spec_helper'

describe Student do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  subject {FactoryGirl.create(:active_student)}

  describe ".create" do
    it "必要なパラメータが揃っていればOK" do
      FactoryGirl.build(:student).should be_valid
    end

    it "住所が必要" do
      FactoryGirl.build(:student, address:nil).should_not be_valid
    end

    it "emailが必要" do
      FactoryGirl.build(:student, email:nil).should_not be_valid
    end

    it 'emailはgmail/yahooメールでなくてよい' do
      FactoryGirl.build(:student, email: 'shimokawa@docomo.ne.jp').should be_valid
    end

    it "電話番号が必要" do
      FactoryGirl.build(:student, phone_number:nil).should_not be_valid
    end

    it "姓・名が必要" do
      FactoryGirl.build(:student, first_name:nil).should_not be_valid
      FactoryGirl.build(:student, last_name:nil).should_not be_valid
    end

    it "ユーザーIDが必要" do
      FactoryGirl.build(:student, user_name:nil).should_not be_valid
    end

    it "パスワードが必要" do
      FactoryGirl.build(:student, password:nil).should_not be_valid
    end

    it "パスワードの確認が必要" do
      FactoryGirl.build(:student, password_confirmation:"").should_not be_valid
    end

    it "呼称が必要" do
      FactoryGirl.build(:student, nickname:nil).should_not be_valid
    end

    it '重複するニックネームはダメ' do
      FactoryGirl.create(:student, nickname: 'hoge').should be_valid
      student = FactoryGirl.build(:student, nickname: 'hoge')
      student.should_not be_valid
      student.errors.full_messages.should == ['呼称（ニックネーム）は既に使用されているため、別のニックネームをご指定ください。']
    end

    it "生年月日が必要" do
      FactoryGirl.build(:student, birthday:nil).should_not be_valid
    end

    it "設定情報を持つ" do
      student = FactoryGirl.create(:student)
      Student.find(student.id).settings.should be_a(StudentSettings)
    end

    it "StudentInfoを持つ" do
      student = FactoryGirl.create(:student)
      student.student_info.should be_present
    end

    it "紹介者IDをセットするとひもづけられる" do
      student2 = FactoryGirl.create(:student, user_name:"student2")
      student = FactoryGirl.create(:student, reference_user_name:student2.user_name)
      student.reference.should == student2
    end

    describe 'BSのひもづけ' do
      before(:each) do
        @postal_code = FactoryGirl.create(:postal_code)
        @bs = FactoryGirl.create(:bs, area_code: @postal_code.area_code.code)
        @bs_user = FactoryGirl.create(:bs_user)
        @bs.set_representative(@bs_user)
      end

      context '住所に合致するBSがいない' do
        it '本部に所属する' do
          address = FactoryGirl.create(:non_existent_address)
          student = FactoryGirl.create(:student, address: address, organization:nil)
          student.organization.should == Headquarter.instance
        end
      end

      context '住所に合致するBSがいる' do
        before(:each) do
          z = @postal_code.zip_code
          @address = FactoryGirl.create(:address, postal_code1: z.code1, postal_code2: z.code2)
        end

        it '該当するBSに所属する' do
          student = FactoryGirl.create(:student, address:@address)
          student.organization.should == @bs
        end

        it '該当するBSの代表者が担当教育コーチとなる' do
          student = FactoryGirl.create(:student, address:@address)
          student.organization.should == @bs
          student.coach.should == @bs.representative
        end
      end
    end

    it 'ノートカメラデータが作られる' do
      expect {
        FactoryGirl.create(:student)
      }.to change(DocumentCamera, :count).by(1)
    end

    it '保護者がいない場合、enrolled_atはnull' do
      s = FactoryGirl.create(:student)
      s.parent.should be_nil
      s.enrolled_at.should be_nil
    end
  end

  describe "favorite tutors" do
    it "お気に入りのチューターを登録する" do
      student = FactoryGirl.create(:student)

      student.favorite_tutors << tutor

      Student.find(student.id).favorite_tutors.should == [tutor]
    end
  end

  describe "#join_lesson" do
    let(:student) {FactoryGirl.create(:student)}
    let(:subject) {FactoryGirl.create(:subject)}
    let(:friend)  {FactoryGirl.create(:student)}

    before(:each) do
      @t = 1.hour.from_now
    end

    context "参加者が限定されていない授業の場合" do
      it "授業に参加できる" do
        lesson = FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
        friend.join_lesson(lesson).should be_true
      end
    end

    context "参加者が自分以外の生徒に限定されている場合" do
      it "授業に参加できない" do
        another_friend = FactoryGirl.create(:student)
        lesson = FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
        lesson.invite(another_friend).should be_persisted
        friend.join_lesson(lesson).should be_false
      end
    end

    context "参加者が自分に限定されている" do
      it "授業に参加できる" do
        lesson = FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
        lesson.invite(friend).should be_persisted
        friend.join_lesson(lesson).should be_true
      end

      it "授業の参加者が一人増える" do
        lesson = FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
        lesson.invite(friend).should be_persisted
        expect {
          friend.join_lesson(lesson)
        }.to change{Lesson.find(lesson.id).students.count}.from(1).to(2)
      end
    end
  end

  describe "#make_referral_to 他の生徒を紹介する" do
    let(:student) {FactoryGirl.create(:student)}
    it "別の生徒を紹介する" do
      student2 = FactoryGirl.create(:student, user_name:"student2")
      student.make_referral_to(student2)
      student2.reload.reference.should == student
    end

    it "紹介料が発生する" do
      student2 = FactoryGirl.create(:student, user_name:"student2")
      expect {
        student.make_referral_to(student2)
      }.to change(Account::StudentReferralFee, :count).by(1)
    end
  end

  describe '#enroll 入会する' do
    let(:student) {FactoryGirl.create(:student)}

    it '時刻が記録される' do
      student.enrolled_at.should be_nil
      student.enroll
      student.enrolled_at.should_not be_nil
    end

    it '入会金は課金されない' do
      student.entry_fee.should be_nil
      student.enroll
      student.reload.entry_fee.should be_nil
    end
  end

  describe "#revive! アカウントを復活する" do
    let(:student) {FactoryGirl.create(:student)}
    before(:each) do
      student.leave!
    end

    it "アクティブ化する" do
      expect {
        student.revive!
      }.to change{Student.find(student.id).active?}.from(false).to(true)
    end

    context '保護者が退会中' do
      it '復活できない' do
        parent = FactoryGirl.create(:parent)
        parent.students << student
        student.reload.parent.should == parent
        parent.leave.should be_true
        expect {
          student.reload.revive.errors.any?.should be_true
        }.not_to change{student.reload.active?}.from(false)
      end
    end
  end

  describe "予算" do
    let(:student) {FactoryGirl.create(:student)}

    describe "限度額" do
      context "予算がチューターの授業料に足りない" do
        before(:each) do
          student.stub(:remaining_budget_of_month).and_return(tutor.lesson_fee_for_student(student) - 1)
        end

        it "授業を登録できない" do
          student.afford_to_take_lesson_from?(tutor, Date.today).should be_false
        end
      end

      context "予算がチューターの授業料よりも多い" do
        before(:each) do
          student.stub(:remaining_budget_of_month).and_return(tutor.lesson_fee_for_student(student))
        end

        it "授業を登録できる" do
          student.afford_to_take_lesson_from?(tutor, Date.today).should be_true
        end
      end
    end

    describe "レッスンを登録する" do
      it "登録したレッスンの支払月の利用可能額が減る" do
        t = Time.now.next_month.change(day: SystemSettings.cutoff_date)
        d = tutor.lesson_fee_for_student(student)
        expect {
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:t)
        }.to change{student.remaining_budget_of_month(t.year, t.month)}.by(-d)
      end
    end
  end

  describe ".to_be_charged 課金対象の受講者を取得する" do
    before(:each) do
      @student = FactoryGirl.create(:active_student)
      @month = Date.today.change(day:SystemSettings.cutoff_date)
      @now = Time.now
    end

    it "アクティブな人を含む" do
      students = Student.to_be_charged(@month.year, @month.month)
      students.should have(1).item
    end

    it "今月辞めた人を含む" do
      t = @now.prev_month.change(day: SystemSettings.cutoff_date + 1)
      Time.stub(:now).and_return(t)
      @student.leave!

      students = Student.to_be_charged(@month.year, @month.month)
      students.should have(1).item
    end

    it "先月辞めた人は含まない" do
      t = @now.prev_month.change(day: SystemSettings.cutoff_date)
      Time.stub(:now).and_return(t)
      @student.leave!

      students = Student.to_be_charged(@month.year, @month.month)
      students.should be_empty
    end
  end

  describe '#cancel_lesson 生徒がレッスンをキャンセルする' do
    let(:student) {FactoryGirl.create(:student)}
    let(:student2) {FactoryGirl.create(:student)}

    describe '通常レッスンの場合' do
      before(:each) do
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])
        @student = @lesson.students.first
      end

      context "レッスン成立前の場合" do
        before(:each) do
          @lesson.should be_new
        end

        it '生徒はいつでもキャンセルできる' do
          @student.cancel_lesson(@lesson).should be_true
        end

        it 'LessonCancelオブジェクトが増える' do
          expect {
            @student.cancel_lesson(@lesson)
          }.to change(LessonCancellation, :count).by(1)
        end

        it 'すべての生徒がキャンセルするとレッスン自体もキャンセル扱いとなる' do
          expect{
            @student.cancel_lesson(@lesson)
          }.to change{Lesson.find(@lesson.id).cancelled?}.from(false).to(true)
        end
      end

      context "レッスン成立後の場合" do
        before(:each) do
          @lesson.accept!
        end

        it "60分前まではキャンセル可能" do
          Time.stub(:now).and_return(61.minutes.ago(@lesson.start_time))
          expect{
            @student.cancel_lesson(@lesson).should be_persisted
          }.to change{@lesson.reload.cancelled?}.from(false).to(true)
        end

        context '開始前10分を切った状態の場合' do
          before(:each) do
            Time.stub(:now).and_return(9.minutes.ago(@lesson.start_time))
          end

          context 'レッスンがまだ開始されていない場合' do
            it 'キャセルできる' do
              @student.cancel_lesson(@lesson).should be_persisted
            end
          end

          context 'レッスンがすでに開始している場合' do
            before(:each) do
              @lesson.class.any_instance.stub(:new?){false}
              @lesson.class.any_instance.stub(:accepted?){false}
              @lesson.class.any_instance.stub(:started?){true}
            end

            it 'キャンセルできない' do
              cancellation = @student.cancel_lesson(@lesson)
              cancellation.should_not be_persisted
            end
          end
        end

        it "validation=falseをつけると60分以内でもキャンセルできる" do
          Time.stub(:now).and_return(59.minutes.ago(@lesson.start_time))
          @student.cancel_lesson(@lesson, validation: false).should be_persisted
        end

        it "オプションレッスンがある月のキャンセル回数にカウントされる" do
          expect {
            @student.cancel_lesson(@lesson).should be_persisted
          }.to change{Student.find(@student.id).monthly_stats_for(@lesson.start_time.year, @lesson.start_time.month).optional_lesson_cancellation_count}.by(1)
        end
      end
    end

    describe '同時レッスンをキャンセルする' do
      before(:each) do
        @lesson = FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student, student2])
        @lesson.should be_group_lesson
      end

      it '生徒が一人になる' do
        expect {
          student.cancel_lesson(@lesson).should be_persisted
        }.to change{LessonStudent.where(lesson_id:@lesson.id).remaining.count}.from(2).to(1)
      end

      it 'レッスンの状態は変わらない' do
        expect {
          #@lesson.cancel_by_student(student)
          student.cancel_lesson(@lesson).should be_persisted
        }.not_to change{@lesson.reload.status}
      end

      it '同時レッスンでなくなる' do
        expect {
          student.cancel_lesson(@lesson).should be_persisted
        }.to change{@lesson.group_lesson?}.from(true).to(false)
      end

      it '同時レッスン割引がなくなる' do
        expect {
          student.cancel_lesson(@lesson).should be_persisted
        }.to change{@lesson.total_fee(student)}.from(@lesson.fee(student) - @lesson.group_lesson_discount(student)).to(@lesson.fee(student))
      end
    end
  end

  describe '#drop_out_from_lesson' do
    let(:student) {FactoryGirl.create(:active_student)}

    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept.should be_persisted
    end

    context 'レッスン開催中' do
      before(:each) do
        @lesson.student_attended student
        @lesson.tutor_attended
        @lesson.should be_started
      end

      it 'LessonDropoutが増える' do
        expect {
          student.drop_out_from_lesson @lesson
        }.to change(LessonDropout, :count).by(1)
      end

      it 'lesson#student_left?がtrueになる' do
        expect {
          student.drop_out_from_lesson @lesson
        }.to change{Lesson.find(@lesson.id).student_left?(student)}.from(false).to(true)
      end

      it '受講者はレッスンに参加できなくなる' do
        Time.stub(:current).and_return(4.minutes.ago(@lesson.start_time))
        @lesson.class.any_instance.stub(:started_at).and_return(5.minutes.ago(@lesson.start_time))
        expect {
          drop_out = student.drop_out_from_lesson @lesson
        }.to change{student.can_enter_lesson?(@lesson)}.from(true).to(false)
      end

      it 'レッスンの参加者がゼロになるとレッスンは中止する' do
        expect {
          student.drop_out_from_lesson @lesson
        }.to change{Lesson.find(@lesson.id).aborted?}.from(false).to(true)
      end

      context '入室制限時刻を過ぎている' do
        before(:each) do
          t = 1.second.since @lesson.entry_end_time_for(student)
          Time.stub(:now){ t }
        end

        it '取止にできない' do
          student.drop_out_from_lesson(@lesson).should_not be_valid
        end

        it ':lesson属性にエラーが有る' do
          dropout = student.drop_out_from_lesson(@lesson)
          dropout.errors[:lesson].should be_present
        end
      end

      context '入室制限時刻のギリギリ直前の場合' do
        before(:each) do
          t = 1.second.ago @lesson.dropout_closing_time
          Time.stub(:now){ t }
        end

        it '取止にできる' do
          student.drop_out_from_lesson(@lesson).should be_valid
        end
      end
    end
  end

  describe '#in_lesson' do
    let(:student) {FactoryGirl.create(:student)}

    it '授業中がなければfalseを返す' do
      student.should_not be_in_lesson
    end

    it '授業中であればtrueを返す' do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:61.minutes.from_now, units:1)
      lesson.accept!
      Time.stub(:now){10.minutes.since(lesson.start_time)}

      student.should be_in_lesson
    end
  end

  describe '#destroy' do
    it 'DocumentCameraが消える' do
      student = FactoryGirl.create(:student)
      expect {
        student.destroy
      }.to change(DocumentCamera, :count).by(-1)
    end

    it '面談の予定がある場合、それらは削除される' do
      meeting = FactoryGirl.create(:meeting, members: [hq_user, subject], datetime: 1.hour.from_now)
      subject.meetings.should have(1).item

      expect {
        subject.reload.destroy
      }.to change(Meeting, :count).by(-1)
    end
  end
end
