# coding: utf-8

class RegistrationStudentsController < ApplicationController
  layout 'registration'
  require 'nkf' 

  def confirm
    if params[:token].blank?
      render :confirmation_error
    else
      @student_registration_form = StudentRegistrationForm.find_by_confirmation_token(params[:token])
      if @student_registration_form.present? && @student_registration_form.parent_id.blank?
        if @student_registration_form.student.present?
          render :used
        else
          session[:confirmation_token] = @student_registration_form.confirmation_token
          redirect_to action: 'new'
        end
      else
        render :confirmation_error
      end
    end
  end

  def register_credit_card
    # TODO: redirect to credit card company
    if session[:confirmation_token]
      redirect_to action:"credit_card_registered"
    else
      render action:"register_credit_card_error"
    end
  end

  def credit_card_registered

  end

  def new
    if session[:confirmation_token].blank?
      redirect_to first_students_path
    elsif session[:student_id]
      redirect_to action: :show, id: session[:student_id]
    else
      @student_registration_form = StudentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
      if @student_registration_form.blank?
        redirect_to first_students_path
      elsif @student_registration_form.student.present?
        redirect_to action: 'used'
      else
        @student_entry_form = StudentEntryForm.new
        @student = Student.new(birthday:Date.new(10.years.ago.year)) do |student|
          student.email = @student_registration_form.email
        end

        @student.address = Address.new
        @student.student_info = StudentInfo.new
      end
    end
    question_code = 'reason_to_enroll'
    answer = nil unless defined?(answer)
    answer_options = answer ? answer[:answer_options] : nil
    @question = Question.where(code: question_code).first.answer_options.pluck(:code)
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  #未成年受講者の登録ページ
  def register_minor_student
    params[:token] = session[:confirmation_token] if session[:confirmation_token].present?
    if current_user
      sign_out current_user
    end
    if params[:token].blank? && params[:validation_data].blank?
      redirect_to sign_in_path
    else
      session[:confirmation_token] = params[:token]
      temp_user = StudentRegistrationForm.find_by_confirmation_token(params[:token])
      if temp_user.student.present?
        redirect_to action: 'used'
      end
      @validation_data = params[:validation_data]
      parent_id = temp_user.parent_id
      parent = User.where(id: parent_id)[0]
      session[:parent_id] = parent_id

      @student = Student.new do |student|
        student.email = temp_user.email
        student.birthday = 10.years.ago
        student.phone_number = parent.phone_number
        student.os = OperatingSystem.default
        student.student_info = StudentInfo.new
        student.parent = parent
        student.build_user_operating_system
        if parent.address
          student.address = parent.address.dup
        else
          student.build_address
        end
      end
    end
  end

  def complete_registering_minor_student
    user_data = params[:student]
    @validation_data = validate_params(user_data)
    if @validation_data.present?
      redirect_to action: :register_minor_student, validation_data: @validation_data
      return
    end

    parent_id = session[:parent_id]
    temp_user = StudentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
    parent = User.where(id: parent_id)[0]

    ### parentの保護者がもつ受講者に住所と氏名が同じものがいた場合弾く
    student_info_params = params[:student]
    student_full_name = student_info_params[:last_name] + student_info_params[:first_name]
    student_address_params = params[:address]
    #student_address = student_address_params[:state] + student_address_params[:line1] + student_address_params[:line2]

    # 住所入力で数字が全角入力されている場合は半角に変換する
    line1 = NKF.nkf('-m0Z1 -w', student_address_params[:line1])
    line2 = NKF.nkf('-m0Z1 -w', student_address_params[:line2])
    student_address = line1 + line2

    # 重複を調べる
    students_array = parent.students
    students_array.each do |st|
      adr = st.address
      adr1 = NKF.nkf('-m0Z1 -w', adr.line1)
      adr2 = NKF.nkf('-m0Z1 -w', adr.line2)
      
      if student_address.gsub(/[^0-9]/, '') == (adr1+adr2).gsub(/[^0-9]/, '')
        if student_full_name == st.last_name+st.first_name
          # フォーム再表示用
          @student = Student.new do |student|
            student.user_name = student_info_params[:user_name]
            student.first_name = student_info_params[:first_name]
            student.last_name = student_info_params[:last_name]
            student.first_name_kana = student_info_params[:first_name_kana]
            student.last_name_kana = student_info_params[:last_name_kana]
            student.nickname = student_info_params[:nickname]
            student.sex = student_info_params[:sex]
            student.email = temp_user.email
            student.birthday = 10.years.ago
            student.phone_number = parent.phone_number
            student.os = OperatingSystem.default
            student.student_info = StudentInfo.new
            student.parent = parent
            student.build_user_operating_system
            if parent.address
              student.address = parent.address.dup
            else
              student.build_address
            end
          end
          # エラーメッセージ表示フラグ
          @already_registered = true
          # 監視アドレスにメール送信
          SystemAdminMailer.minor_student_overlap_registing(@student).deliver
          # フォームに戻る
          render :register_minor_student and return
        end
      end
    end
    ### 弾き処理ここまで

    parent_service = ParentService.new(parent)
    password = User.generate_password
    @student = parent_service.create_student(params, password)
    if @student
      session[:confirmation_token] = nil
      sign_in(@student, :bypass => true)
      redirect_to st_root_path
      return
    end
  end

  def create
    @student_registration_form = StudentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
    if @student_registration_form.present?
      if @student_registration_form.student.present?
        session.delete(:confirmation_token)
        render action: 'used'
      else
        logger.debug '------------------------- STUDENT PARAMS'
        logger.debug params
        params[:student_registration_form] ||= @student_registration_form
        @student_entry_form = StudentEntryForm.new(params)
        @student = @student_entry_form.student
        if @student_entry_form.save
          session.delete(:confirmation_token)
          @student = @student_entry_form.student
          sign_in :user, @student
          redirect_to action: :show, id: @student.id
        else
          question_code = 'reason_to_enroll'
          answer = nil unless defined?(answer)
          answer_options = answer ? answer[:answer_options] : nil
          @question = Question.where(code: question_code).first.answer_options.pluck(:code)
          @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
          logger.debug '------------------------- @student_form.errors'
          logger.debug @student_entry_form.errors.full_messages
          render :new
        end
      end
    else
      render :new
    end
  end

  def show
    @student = current_user
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  def edit
    @student = current_user
    @student_entry_form = StudentEntryForm.new(@student)
    question_code = 'reason_to_enroll'
    answer = nil unless defined?(answer)
    answer_options = answer ? answer[:answer_options] : nil
    @question = Question.where(code: question_code).first.answer_options.pluck(:code)
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  def update
    @student = current_user
    @student_entry_form = StudentEntryForm.new(@student)
    if @student_entry_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def finish
      redirect_to new_st_payment_method_path
  end

  private

  def validate_params user_data
    @validation_data = []
    if User.where(user_name: user_data['user_name']).present?
      @validation_data.push("user_name_exist")
    end

    if User.where(nickname: user_data['nickname']).present?
      @validation_data.push('nickname_exist')
    end

    if user_data['sex'].blank?
      @validation_data.push('sex_blank')
    end
    @validation_data
  end
end
