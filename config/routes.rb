Aid::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/sign_in', :to => 'devise/sessions#new', :as => 'sign_in'
  end

  def monthly_statements_resources
    resources :monthly_statements do
      member do
        post :calculate
        get :bill
        get :payment
      end
      resources :journal_entries, :controller => 'monthly_statements/journal_entries'
    end
  end

  ########################################################### Headquarter

  namespace :hq do
    get '/' => 'home#index', :as => :root

    resources :bss do
      collection do
        get :left
      end

      member do
        get :resign
        get :leave
        post :leave
        post :activate
      end

      resources :bs_users, :controller => 'bss/bs_users' do
        member do
          match :change_password
        end
      end

      resources :students, :controller => 'bs_students', :only => [:index]

      resources :monthly_statements, :controller => 'bss/monthly_statements', :except => [:update, :destroy] do
        post 'calculate', :on => :member
        resources :adjusting_entries, :controller => 'bss/monthly_statements/adjusting_entries'
        resources :journal_entries, :controller => 'bss/monthly_statements/journal_entries', :only => [:index, :show]
      end

      resource :bank_account, :controller => 'bss/bank_accounts' do
        member do
          get :complete
        end
      end

    end
    resources :bs_users
    resources :users
    resources :tutors do
      collection do
        get :left
        get :absent
        post :create_from_app_form
      end
      member do
        match :leave
        post :come_back
        post :become_regular
        post :become_beginner
        get :change_password
        put :change_password
      end

      resource :special, :controller => :tutor_specials, :only => [:show, :update]

      resource :membership_cancellation, :controller => :tutor_membership_cancellations, :path_names => {:new => :form}

      resources :monthly_statements, :controller => 'tutors/monthly_statements' do
        post 'calculate', :on => :member
        resources :adjusting_entries, :controller => 'tutors/monthly_statements/adjusting_entries'
        resources :journal_entries, :controller => 'tutors/monthly_statements/journal_entries', :only => [:index, :show]
      end

      resources :teaching_subjects, :controller => 'tutors/teaching_subjects' do
        collection do
          put '/', action: 'update'
          get :edit
        end
      end

      resource :type, controller: :tutor_types

      resource :bank_account, :controller => 'tutors/bank_accounts'
    end

    resources :my_students, :only => :index

    resources :students do
      collection do
        get :left
        get :billing
      end
      member do
        get :history
        match :leave
        post :come_back
        get :change_password
        put :change_password
      end

      resource :membership_cancellation, :controller => :student_membership_cancellations, :path_names => {:new => :form}

      resource :address, :controller => 'students/addresses'

      resources :basic_lesson_infos, :controller => 'students/basic_lesson_infos' do
        member do
          post :extend
          post :turn_off_auto_extension
          post :turn_on_auto_extension
          post :supply
        end
        resources :lessons, :controller => 'students/basic_lesson_infos/lessons', :only => [:index, :show]
      end

      resources :optional_lessons, :controller => 'students/optional_lessons'

      resources :journal_entries, :controller => 'students/journal_entries' do
        get ':year/:month', :action => :month, :as => :month, :on => :collection
      end
      resources :ledgers, :controller => 'students/ledgers', :only => [:index] do
        collection do
          post ':year/:month/calculate', :action => :calculate
          get ':year/:month', :action => :month, :as => :month
          get ':year', :action => :year, :as => :year
        end
      end
      resources :monthly_statements, :controller => 'students/monthly_statements', :only => [:index, :show, :create, :edit] do
        member do
          post :calculate
        end
        resources :adjusting_entries, :controller => 'students/monthly_statements/adjusting_entries'
        resources :journal_entries, :controller => 'students/monthly_statements/journal_entries', :only => [:index, :show]
      end

      resources :monthly_usages, :controller => 'students/monthly_usages', :only => [:index, :show] do
        get ':year/:month', action: 'year_month', :on => :collection
        post :calculate, :on => :member
      end

      resource :coach, :controller => :student_coaches, :only => [:show]
    end

    resources :trial_students do
      member do
        get :change_password
        put :change_password
      end

      resources :lessons, :controller => :trial_student_lessons
    end

    resources :trial_lessons do
      resources :forms, :controller => :trial_lesson_forms do
        member do
          post :cancel
        end
      end
    end

    resources :parents do
      collection do
        get :left
      end
      member do
        match :leave
        get :activate
        post :activate
        get :change_password
        put :change_password
      end

      resource :membership_cancellation, :controller => :parent_membership_cancellations, :path_names => {:new => :form}
    end

    resources :coaches do
      collection do
        get :left
      end
      member do
        post :deactivate
        post :activate
        get :change_password
        put :change_password
      end
    end

    resources :tutor_interviews

    resources :lessons do
      collection do
        get :calendar
        get :under_request
        get :history
        get :pending
        get :not_started
      end
      member do
        match :cancel, :via => [:get, :post]
        get :room_as_tutor
        get :room_as_student
        get :room
        match :change_schedule
        post :cancel_request
        get :accounting
        get :updated_at
      end

      get :materials, :controller => :lesson_materials, :action => :lesson
    end

    resources :basic_lesson_infos do
      collection do
        get :pending
        get :rejected
        get :shared
        get :closed
      end
      member do
        match :stop
        post :turn_off_auto_extension
        post :turn_on_auto_extension
        post :cancel_request
        get  :close
        post :close
        get  :status
      end
      resources :forms, :controller => 'basic_lesson_infos/forms' do
        post :cancel, :on => :member
      end
      resources :lessons, :controller => 'basic_lesson_infos/lessons' do
        collection do
          post :supply
          post :cancel_selected
        end
        member do
          get :room_as_tutor
          get :room_as_student
          post :cancel
          match :change_schedule
        end
      end

      resources :students, :controller => 'basic_lesson_infos/students', :path_names => {:new => 'add'}
    end

    resources :optional_lessons do
      resources :forms, :controller => 'optional_lessons/forms' do
        member do
          post :cancel
        end
      end
    end

    resources :awards

    resources :tutor_app_forms do
      collection do
        get :processed
      end
      member do
        post :create_tutor
        get :account_created
        post :reject
      end
      resource :tutor, :controller => 'tutor_app_forms/tutors'
    end

    resources :bs_app_forms do
      collection do
        get :processed
      end
      member do
        post :create_user
        post :reject
        get  :registered
      end
      resource :bs, :controller => 'bs_app_forms/bss' do
        resource :bs_user, :controller => 'bs_app_forms/bss/bs_users', :only => [:show, :new, :create]
      end
    end

    resources :document_cameras do
      collection do
        get :yearly
        get :monthly
        get :daily
        get :file
      end
    end
    resources :messages do
      member do
        get :reply
      end
      resources :replies, controller: :message_replies
    end
    resources :my_messages do
      resources :files, controller: :my_message_files
    end
    resources :all_messages, :only => [:index, :show]

    resources :lesson_reports do
      member do
        get :prev
        get :next
      end
    end
    resources :cs_sheets
    resources :exams, :only => :index do
      collection do
        get ':grade_id/:subject_id/:year/:month/new', :action => :new
        get ':grade_id/:subject_id/:year/:month/file', :action => :file
        get ':grade_id/:subject_id/:year/:month/:paper_id', :action => :paper
        get ':grade_id/:subject_id/:year/:month', :action => :show
        post ':grade_id/:subject_id/:year/:month', :action => :create
        get ':grade_id/:subject_id/:year', :action => :year
        get ':grade_id/:subject_id', :action => :subject
        get ':grade_id', :action => :grade
      end
    end

    get :settings, :controller => :settings, :action => :index
    resource :system_settings
    resource :lesson_settings, :only => [:show, :edit, :create]
    resource :free_mode_settings
    resources :switching_payment_method_users
    resources :charge_settings

    match 'calendar(/:year(/:month))' => 'calendars#lessons', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    resources :textbooks do
      member do
        get :image
      end
      resource :answer_book, :controller => 'textbooks/answer_books'
    end
    resources :users do
      member do
        match :change_password
      end
    end
    resources :subjects
    resources :journal_entries

    resources :monthly_statements do
      member do
        post :calculate_all
        post :calculate
        get  :yucho
      end
      resources :journal_entries, :controller => 'monthly_statements/journal_entries'
    end

    resources :monthly_statement_calculations
    resources :yucho_accounts, :only => [:index] do
      collection do
        get 'payments/:year/:month', :action => :payments, :as => :payments
        get 'receipts/:year/:month', :action => :receipts, :as => :receipts
        get 'billings/:year/:month', :action => :billings, :as => :billings
        get :students
        get :tutors
        get :bss
        get :monthly
      end
    end

    resources :yucho_billings, :only => [:index] do
      collection do
        get ':year/:month', :action => :monthly, :as => :monthly
        post :calculate
        get :file
      end
    end

    resources :yucho_payments, :only => [:index] do
      collection do
        get ':year/:month', :action => :monthly, :as => :monthly
        post :calculate
        get :file
      end
    end

    resources :hq_users do
      member do
        get :switch_admin_right
        get :change_password
        put :change_password
      end
      resource :access_authority, :controller => 'hq_users/access_authorities'
    end
    resources :grade_groups do
      resources :subjects, controller: :grade_group_subjects do
        resources :levels, controller: :grade_group_subject_levels
      end
    end

    resource :profile do
      member do
        get :change_password
        put :change_password
        get :change_email
        post :change_email
        get :email_confirmation
      end
    end

    resources :meetings do
      collection do
        get :scheduling
        get :done
      end

      member do
        get :room
        post :close
      end

      resources :forms, :controller => 'meetings/forms'
      resources :forms2, :controller => 'special_tutor_meeting_forms'

      resources :schedules, :controller => 'meetings/schedules' do
        member do
          post :select
        end
      end

      resource :report, :controller => 'meetings/reports'
    end

    resources :membership_cancellations
    resources :membership_applications do
      collection do
        get :parents
        get :students
        get :requests
      end

      member do
        post :accept
        post :reject
      end
    end

    resources :yucho_account_applications do
      member do
        post :accept
        post :reject
      end
    end

    resources :lesson_materials, :only => [:index, :show]

    resources :banks
  end

  ########################################################### BS

  namespace :bs do
    get '/' => 'home#index', :as => :root

    resources :students, :only => [:index, :show] do
      collection do
        get :left
      end
      resources :basic_lessons, :controller => :student_basic_lessons, :only => [:index, :show]
      resources :optional_lessons, :controller => :student_optional_lessons
      resources :lesson_reports, :controller => :student_lesson_reports

      resources :basic_lesson_infos, :controller => 'students/basic_lesson_infos' do
        member do
          match :stop
          post :turn_off_auto_extension
          post :turn_on_auto_extension
        end
        resources :lessons, :controller => 'students/basic_lesson_infos/lessons', :only => [:index, :show]
      end

      resource :coach, :controller => :student_coaches, :only => [:new, :show, :edit, :create, :update]

      resources :exams, :controller => 'students/exams', :only => [:index, :show] do
        collection do
          get :edit
          post :update
        end
      end

      resources :messages, controller: :student_messages, only: [:index, :show]
      resources :received_messages, controller: :student_received_messages, only: [:index, :show]
      resources :sent_messages, controller: :student_sent_messages, only: [:index, :show]
    end

    resources :all_student_messages, only: [:index, :show]

    resources :parents, :only => [:index, :show] do
      collection do
        get :left
      end
    end
    resources :tutors, :only => [:index, :show] do
      collection do
        get :left
      end
      match 'calendars/lessons/(/:year(/:month))' => 'tutors/calendars#lessons', :as => :lessons_calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
      match 'calendars/available_times/(/:year(/:month))' => 'tutors/calendars#available_times', :as => :available_times_calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    end

    resources :coaches, :only => [:index, :show, :edit, :update, :destroy] do
      collection do
        get :left
      end
      member do
        post :deactivate
        post :activate
      end

      resources :messages, controller: :coach_messages, only: [:index, :show]
    end

    resources :all_coach_messages, controller: :all_coach_messages, only: [:index, :show]


    resources :lessons do
      collection do
        get :pending
        get :history
        get :not_started
      end
      member do
        match :cancel, :via => [:get, :post]
        get :room_as_tutor
        get :room_as_student
        get :room
        match :change_schedule
        get :updated_at
      end
    end
    resources :basic_lessons

    resources :basic_lesson_infos do
      collection do
        get :pending
        get :rejected
        get :closed
        get :new_shared_lesson
        get :new_friends_lesson
        get :shared
      end
      member do
        match :stop
        post :turn_off_auto_extension
        post :turn_on_auto_extension
        post :cancel
        get  :close
        post :close
        get  :status
      end
      resources :forms, :controller => 'basic_lesson_infos/forms' do
        member do
          post :cancel
        end
      end
      resources :lessons, :controller => 'basic_lesson_infos/lessons' do
        collection do
          post :supply
          post :cancel_selected
        end
        member do
          get :room_as_tutor
          get :room_as_student
          post :cancel
          match :change_schedule
        end
      end

      resources :students, :controller => 'basic_lesson_infos/students', :path_names => {:new => 'add'}
    end

    resources :optional_lessons do
      resources :forms, :controller => 'optional_lessons/forms' do
        member do
          post :cancel
        end
      end
      match 'calendars/available_times/(/:year(/:month))' => 'tutors/calendars#available_times', :as => :available_times_calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    end

    resources :lesson_reports, :only => [:index, :show] do
      member do
        get :prev
        get :next
      end
    end

    resources :cs_sheets
    resources :messages do
      collection do
        get :coaches
      end
      member do
        get :coach
        get :reply
      end
      resources :replies, controller: :message_replies
    end
    resources :my_messages
    resource  :profile do
      member do
        get :change_password
        put :change_password
        get :change_email
        post :change_email
        get :email_confirmation
      end
    end
    resource  :bs do
      member do
        get :leave
      end
    end
    resources :interviews do
      member do
        post :quit
        post :done
      end
    end

    resources :monthly_results, :only => [:index, :show] do
      post :calculate, :on => :member
    end

    resources :meetings do
      collection do
        get :scheduling
        get :done
      end

      member do
        get :room
        post :close
      end

      resource :report, :controller => 'meetings/reports'

      resources :forms, :controller => 'meetings/forms'

      resources :forms2, :controller => 'special_tutor_meeting_forms'

      resources :schedules, :controller => 'meetings/schedules' do
        member do
          post :select
        end
      end
    end

    match 'calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

    resource :bank_account

    monthly_statements_resources
  end

  ########################################################### Tutor

  namespace :tu do
    get '/' => 'home#index', :as => :root

    resources :basic_lesson_infos, :only => [:index, :show] do
      collection do
        get :pending
        get :rejected
      end
      member do
        post :accept
        post :reject
      end

      resources :students, :controller => 'basic_lesson_infos/students', :only => [:index, :show] do
        resources :lesson_reports, :controller => 'basic_lesson_infos/students/lesson_reports', :only => [:index, :show] do
          member do
            get :prev
            get :next
          end
        end
      end
    end

    resources :lessons do
      collection do
        get :history
        get :unreported
        get :not_started
      end

      member do
        get :room
        post :cancel
        post :check_in
        post :open
        post :close
        post :accept_cancellation
        get  :extendable
        get  :extendability
        get  :time_schedule
        match :change_schedule
        get :updated_at
      end

      resource :extension, :controller => 'lessons/extensions'
      resources :extension_requests, :controller => 'lessons/extension_requests' do
        collection do
          get :complete
        end
      end

      resources :lesson_reports, :controller => :lesson_lesson_reports, :only => [:new, :create, :show]

      resources :students, :controller => 'lessons/students', :only => [:index, :show] do
        collection do
          get :in_room
        end

        resource :dropout, :controller => 'lessons/students/dropouts'

        resources :lesson_reports, :controller => 'lessons/students/lesson_reports', :only => [:index, :show] do
          member do
            get :prev
            get :next
          end
        end
      end

      resources :materials, :controller => :lesson_materials

      resource :cancellation, :controller => :lesson_cancellations, :only => [:new, :create]
    end

    resources :lesson_requests do
      member do
        post :accept
        post :reject
      end

      resources :students, :controller => 'lesson_requests/students', :only => [:index, :show]

      resource :rejection, :controller => :lesson_request_rejections, :only => [:new, :create]
    end

    resources :lesson_reports, :except => [:new, :create] do
      collection do
        get :unwritten
      end
      member do
        get :prev
        get :next
      end
    end
    resources :cs_sheets
    resource  :profile do
      member do
        get :change_password
        put :change_password
        get :change_email
        post :change_email
        get :email_confirmation
      end
    end
    resource  :bank_account
    resources :messages do
      member do
        get :reply
      end
      resources :replies, controller: :message_replies
    end
    resources :my_messages
    resources :textbooks, :only => [:index, :show] do
      member do
        get :image
      end
      resource :answer_book, :controller => 'textbooks/answer_books'
    end

    resources :meetings, :only => [:index, :show] do
      collection do
        get :scheduling
        get :done
      end

      member do
        get :room
      end

      resources :schedules, :controller => 'meeting_schedules', :only => [:show] do
        collection do
          post :select_other
        end
        member do
          post :select
        end
      end
    end

    resources :teaching_subjects do
      collection do
        put '/', action: 'update'
        get :edit
      end
    end
    resources :subjects do
      collection do
        get :all
        get :my
      end
      member do
        post :select
        post :deselect
      end
    end
    resources :available_times do
      collection do
        get :wdays
      end
    end

    monthly_statements_resources

    namespace :settings do
      resources :weekday_schedules
      resources :unavailable_days
    end

    resources :daily_available_times do
      collection do
        get :edit
        get :dates
        post :update_all
        get ':year/:month/:date', action: :date, constraints: {year: /\d\d\d\d/, month: /\d\d?/, date: /\d\d?/}
        post ':year/:month/:date', action: :create, constraints: {year: /\d\d\d\d/, month: /\d\d?/, date: /\d\d?/}
        get ':year/:month', action: :month, constraints: {year: /\d\d\d\d/, month: /\d\d?/}
      end
    end

    match 'calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

    resource :income_of_this_month, controller: :income_of_this_month do
      post :calculate
    end

    resources :rewards, :controller => :rewards, :only => [:index]
  end


  ########################################################### Parent

  namespace :pa do
    get '/' => 'home#index', :as => :root
    resources :students do
      collection do
        post :send_email_to_student_from_parent
        get :mail_certification
      end
      member do
        get :home
        get :change_password
        put :change_password
      end

      resource :membership_cancellation, :controller => :student_membership_cancellations, :path_names => {:new => :form}

      resource :charge, :controller => :student_charges
      resources :lessons, :controller => :student_lessons do
        collection do
          get :history
          get :not_started
          #match 'calendar(/:year(/:month))' => :calendar, :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
        end
      end
      resources :lesson_reports, :controller => :student_lesson_reports
      resources :messages, :controller => :student_messages, :only => [:index, :show]
      resources :sent_messages, :controller => 'students/sent_messages', :only => [:index, :show]
      match 'calendar(/:year(/:month))' => 'student_calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
      resources :monthly_usages, :controller => 'students/monthly_usages', :only => [:index, :show] do
        get ':year/:month', action: 'year_month', :on => :collection
        post :calculate, :on => :member
      end
      resource :bs, :controller => 'students/bss'

      resources :monthly_statements, :controller => 'students/monthly_statements', :only => [:index, :show] do
        member do
          post :calculate
          get :bill
        end
        resources :journal_entries, :controller => 'students/monthly_statements/journal_entries'
      end
    end

    resource  :profile do
      get :change_password
      put :change_password
      get :change_email
      post :change_email
      get :email_confirmation
    end

    resource :membership_cancellation, :path_names => {:new => :form}

    resources :interviews
    resources :bss
    resources :messages do
      member do
        get :reply
      end
      resources :replies, controller: :message_replies
    end
    resources :my_messages

    resource :credit_card do
      member do
        match :register, :via => [:get, :post]
        get :registered
      end
    end

    resource :bank_account do
      member do
        get :complete
      end
    end
    #resource :payment

    resource :temp_yucho_account do
      member do
        get :complete
      end
    end

    resources :payments do
      collection do
        get :show
        get :entry_fee_confirmation
        post :process_entry_fee_confirmation
        get :confirmation
        get :confirmation_credit
        get :confirmation_yucho
        post :process_confirmation
        get :select_payment_method
        #post :add_credit_card
        #get :add_credit_card
        #post :add_yubin_chokin
        #get :add_yubin_chokin
      end
    end

    resource :free_registration do
      collection do
        post :new
        get :complete
      end
    end

    resource :payment_method do
      member do
        get :current
        post :payment_method_change
      end
    end

    resource :membership_application do
      member do
        get :complete
        get :entry_fee
      end
    end

    resources :meetings, :only => [:index, :show] do
      collection do
        get :scheduling
        get :done
      end

      member do
        get :room
      end

      resources :schedules, :controller => 'meetings/schedules', :only => [:show] do
        collection do
          post :select_other
        end
        member do
          post :select
        end
      end
    end
  end


  ########################################################### Student

  namespace :st do
    get '/' => 'home#index', :as => :root
    resources :lessons do
      collection do
        get :reserve
        get :history
        get :requests
        get :group
        get :no_cs_sheet
        get :invited
        get :not_started
      end
      member do
        post :cancel
        #post :abort
        post :leave
        post :check_in
        get  :left
        get  :room
        get  :time_schedule
        get  :invited, :action => :invited_lesson
        post :accept_invitation
        post :reject_invitation
        match :change_schedule
        get  :extendability
        get :updated_at
      end
      resource :extension_request, :controller => 'lessons/extension_requests'
      resource :cs_sheet, :controller => :lesson_cs_sheets
      resources :materials, :controller => 'lessons/materials'

      resource :cancellation, :controller => :lesson_cancellations, :only => [:new, :create]
    end

    resources :lesson_invitations, :only => [:index, :show] do
      member do
        post :accept
        post :reject
      end
    end

    resources :group_lessons, :only => [:index, :show] do
      post :join, :on => :member
    end

    resources :optional_lessons do
      resources :forms, :controller => 'optional_lessons/forms' do
        collection do
          post :cancel
        end
      end
    end

    resources :textbooks do
      member do
        get :image
      end
      resource :answer_book, :controller => :textbook_answer_books
    end

    resources :cs_sheets

    resources :tutors do
      collection do
        get :favorites
        get :prof_search
        get :cs
        get :cs_recent
        get :lesson
      end
      member do
        post :add_to_favorites
        post :remove_from_favorites
        get :new_optional_lesson
      end
      resources :optional_lessons, :controller => 'tutors/optional_lessons'
    end

    resource :profile do
      get :change_password
      put :change_password
      get :change_email
      post :change_email
      get :email_confirmation
    end

    resource :membership_cancellation, :path_names => {:new => :form}

    resources :handouts

    resources :exams, :only => :index do
      collection do
        get ':subject_id/:year/:month/room', :action => :room
        get ':subject_id/:year/:month/:paper_id', :action => :paper
        get ':subject_id/:year/:month', :action => :show
        post ':subject_id/:year/:month', :action => :create
        get ':subject_id/:year', :action => :year
        get ':subject_id', :action => :subject
      end
    end

    resources :lesson_reports, :only => [:index, :show] do
      member do
        get :prev
        get :next
      end
    end

    resources :messages do
      collection do
        get :sent
      end
      member do
        get :reply
      end
      resources :replies, controller: :message_replies
    end

    resources :my_messages

    monthly_statements_resources

    resource :settings
    resource :charge_settings
    match 'calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

    resources :payments do
      collection do
        get :show
        get :edit
        get :confirmation
        post :confirmation
        get :entry_fee_confirmation
        post :process_entry_fee_confirmation
        get :confirmation_credit
        get :confirmation_yucho
        post :process_confirmation
        get :select_payment_method
        #post :add_credit_card
        #get :add_credit_card
        #post :add_yubin_chokin
        #get :add_yubin_chokin
      end
    end

    resource :free_registration do
      collection do
        post :new
        get :complete
      end
    end

    resource :bs
    resources :monthly_usages, :only => [:index, :show] do
      get ':year/:month', action: 'year_month', :on => :collection
      post :calculate, :on => :member
    end

    resource :credit_card do
      member do
        match :register, :via => [:get, :post]
        get :registered
      end
    end

    resource :bank_account do
      member do
        get :complete
      end
    end

    resource :temp_yucho_account do
      member do
        get :complete
      end
    end

    resource :payment_method do
      member do
        get :current
        post :payment_method_change
      end
    end

    resource :membership_application do
      member do
        get :complete
        get :entry_fee
      end
    end

    resources :meetings, :only => [:index, :show] do
      collection do
        get :scheduling
        get :done
      end

      member do
        get :room
      end

      resources :schedules, :controller => 'meetings/schedules', :only => [:show] do
        collection do
          post :select_other
        end
        member do
          post :select
        end
      end
    end
  end

  namespace :ts do
    get '/' => 'home#index', :as => :root
    resources :lessons do
      collection do
        get :history
      end
      member do
        post :cancel
        post :leave
        post :check_in
        get  :left
        get  :room
        get  :time_schedule
        get  :invited, :action => :invited_lesson
        post :accept_invitation
        post :reject_invitation
        match :change_schedule
        get  :extendability
        get :updated_at
      end
      resource :extension_request, :controller => :lesson_extension_requests
      resource :cs_sheet, :controller => :lesson_cs_sheets
      resources :materials, :controller => :lesson_materials
      resource :cancellation, :controller => :lesson_cancellations, :only => [:new, :create]
    end

    resources :textbooks do
      member do
        get :image
      end
      resource :answer_book, :controller => :textbook_answer_books
    end

    resources :tutors
    resource :profile do
      get :change_password
      put :change_password
      get :change_email
      post :change_email
      get :email_confirmation
    end

    resource :settings
    match 'calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    resource :bs
  end

  ########################################################### Admin

  namespace :admin do
    get '/' => 'home#index', :as => :root

    resources :jobs do
      collection do
        get :stat
        get :failed
      end
    end

    get 'widget_test' => 'widgets#test'

    resources :lesson_materials, :only => [:index, :show]
    resources :operating_systems
    resource :lesson_settings, :only => [:show, :edit, :update]
  end

  ########################################################### Guest

  namespace :gu do
    get '/' => 'home#index', :as => :root
    get 'web_camera' => 'widgets#videos', :as => :web_camera
    resources :widgets do
      collection do
        get :video_subscriber
        get :document_camera_subscriber
      end
    end
    resources :tutors
  end


  ########################################################### Registration

  resources :tutor_app_forms, :except => [:destroy] do
    collection do
      get :first
      post :agree
      post :disagree
    end
    member do
      post :confirm
      get :accepted
    end
  end

  resources :bs_app_forms, :except => [:destroy] do
    collection do
      get :first
      post :agree
      post :disagree
    end
    member do
      post :confirm
      get  :accepted
    end
  end

  scope 'registration' do
    resources :parents, :controller => :registration_parents do
      collection do
        get :confirm
        get :register_credit_card
        get :credit_card_registered
        get :complete
        get :used
      end

      member do
        get :accepted
        get :finish
      end
    end
    resources :students, :controller => :registration_students do
      collection do
        post :complete_registering_minor_student
        get :register_minor_student
        get :confirm
        get :register_credit_card
        get :credit_card_registered
        get :complete
        get :used
      end
      member do
        get :accepted
        get :finish
      end
    end
    get '/' => 'home#registration', :as => :registration
  end

  #resources :banks

  resources :tutors do
    resources :daily_available_times, controller: :tutor_daily_available_times, only: [:index] do
      collection do
        get ':year/:month/:date', action: :date, constraints: {year: /\d\d\d\d/, month: /\d\d?/, date: /\d\d?/}
        #post ':year/:month/:date', action: :create, constraints: {year: /\d\d\d\d/, month: /\d\d?/, date: /\d\d?/}
      end
    end
    resources :available_dates, controller: :tutor_available_dates, only: [:index]
  end

  resources :lessons, :only=>[] do
    resources :materials, :controller => :lesson_materials, :only => [:index, :show]
    resources :members, :controller => :lesson_members, :only => [:index] do
      resources :materials, :controller => :lesson_member_materials, :only => [:index, :show]
    end
  end

  resources :grades, :only => [:index, :show] do
    resources :subjects, :controller => :grade_subjects, :only => [:index, :show]
  end

  resources :subjects, :only => [:index, :show] do
    resources :levels, :controller => :subject_levels, :only => [:index, :show]
  end


  resources :textbooks, :only => [:index, :show] do
    member do
      get :image
      get :images
    end

    resource :answer_book, :controller => 'textbooks/answer_books', :only => [:show] do
      member do
        get :images
        get :image
        get :lesson_mode
      end
    end
  end

  resources :my_messages, only: [:show] do
    resources :files, controller: :my_message_files
  end
  resources :message_files

  resources :guides, :only => [:index, :show]

  resources :widgets, :only => [:index] do
    collection do
      get :video
      get :video_subscriber
      get :document_camera
      get :document_camera_subscriber
      get :videos
    end
  end

  namespace :tasks do
    constraints(ip: /\A127.0.0.1\Z/) do
      post :basic_lesson_extension
      post :calculate_monthly_statements
      post :calculate_next_monthly_statements
      post :notify_monthly_payment_fixed
      post :monthly_calculation
      post :lesson_cancellation_count
      post :tutor_lesson_skip_clear
      post :skipped_meetings
      post :sweep_ignored_lesson_requests
      post :yucho_account_payments_and_receipts
      post :charge_entry_fee
      post :process_monthly_statement_update_requests
    end
  end

  namespace :license do
    resources :monthly_charging_users, only: [:index] do
      collection do
        get ':year/:month', action: :month
        post ':year/:month/calculate', action: :calculate
        get  ':year/:month/job', action: :job
      end
    end

    resources :no_charging_users
  end

  namespace :dev do
    resources :cs_sheets
    resources :lesson_reports
    resources :lessons do
      member do
        get :room
        get :updated_at
      end
    end
  end

  get '/addresses/:postal_code' => 'addresses#search'

  get '/left' => 'home#left'

  get '/version' => 'home#version'

  get  :confirmation1,          controller: :registration
  post :process_confirmation1, controller: :registration
  get  :confirmation2,         controller: :registration
  post :process_confirmation2, controller: :registration
  get  'mail-certification',   controller: :registration, action: :mail_certification
  post 'process_mail-certification', controller: :registration, action: :process_mail_certification
  get  :mail_certification_complete, controller: :registration

  root :to => 'home#index'

  unless Rails.application.config.consider_all_requests_local
    match '*path', :controller => :errors, :action => :error_404
  end
end
