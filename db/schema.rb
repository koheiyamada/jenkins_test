# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140820085635) do

  create_table "access_authorities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "hq_user",         :default => 0
    t.integer  "bs_user",         :default => 0
    t.integer  "tutor",           :default => 0
    t.integer  "parent",          :default => 0
    t.integer  "student",         :default => 0
    t.integer  "accounting",      :default => 0
    t.integer  "cs_sheet",        :default => 0
    t.integer  "lesson_report",   :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "lesson",          :default => 0
    t.integer  "exam",            :default => 0
    t.integer  "message",         :default => 0
    t.integer  "document_camera", :default => 0
    t.integer  "textbook",        :default => 0
    t.integer  "system_settings", :default => 0
    t.integer  "bs_app_form",     :default => 0
    t.integer  "tutor_app_form",  :default => 0
    t.integer  "bs",              :default => 0
    t.integer  "meeting",         :default => 0
    t.integer  "bank",            :default => 0
  end

  add_index "access_authorities", ["user_id"], :name => "index_access_authorities_on_user_id"

  create_table "account_journal_entries", :force => true do |t|
    t.string   "type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "referral_id"
    t.integer  "student_id"
    t.integer  "subject_id"
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "amount_of_payment",        :default => 0
    t.integer  "amount_of_money_received", :default => 0
    t.integer  "client_id"
    t.string   "client_type"
    t.integer  "deal_id"
    t.integer  "organization_id"
    t.integer  "reversal_entry_id"
    t.string   "note"
    t.boolean  "includes_bs_share",        :default => false
    t.integer  "original_lesson_fee",      :default => 0
    t.string   "note2"
  end

  add_index "account_journal_entries", ["client_id", "client_type"], :name => "index_account_journal_entries_on_client_id_and_client_type"
  add_index "account_journal_entries", ["deal_id"], :name => "index_account_journal_entries_on_deal_id"
  add_index "account_journal_entries", ["lesson_id"], :name => "index_account_journal_entries_on_lesson_id"
  add_index "account_journal_entries", ["month"], :name => "index_account_journal_entries_on_month"
  add_index "account_journal_entries", ["organization_id"], :name => "index_account_journal_entries_on_organization_id"
  add_index "account_journal_entries", ["owner_id", "owner_type"], :name => "index_account_journal_entries_on_owner_id_and_owner_type"
  add_index "account_journal_entries", ["referral_id"], :name => "index_account_journal_entries_on_referral_id"
  add_index "account_journal_entries", ["student_id"], :name => "index_account_journal_entries_on_student_id"
  add_index "account_journal_entries", ["subject_id"], :name => "index_account_journal_entries_on_subject_id"
  add_index "account_journal_entries", ["type"], :name => "index_account_journal_entries_on_type"
  add_index "account_journal_entries", ["user_id"], :name => "index_account_journal_entries_on_user_id"
  add_index "account_journal_entries", ["year"], :name => "index_account_journal_entries_on_year"

  create_table "addresses", :force => true do |t|
    t.string   "postal_code"
    t.string   "address"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "type"
    t.string   "postal_code1"
    t.string   "postal_code2"
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"
  add_index "addresses", ["type"], :name => "index_addresses_on_type"

  create_table "answer_books", :force => true do |t|
    t.integer  "textbook_id"
    t.string   "dir"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answer_books", ["textbook_id"], :name => "index_answer_books_on_textbook_id"

  create_table "answer_options", :force => true do |t|
    t.integer  "question_id"
    t.string   "code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answer_options", ["question_id"], :name => "index_answer_options_on_question_id"

  create_table "answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "answer_option_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "answer_option_code", :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "answers", ["answer_option_id"], :name => "index_answers_on_answer_option_id"
  add_index "answers", ["owner_id", "owner_type"], :name => "index_answers_on_owner_id_and_owner_type"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "area_codes", :force => true do |t|
    t.string "code", :null => false
  end

  add_index "area_codes", ["code"], :name => "index_area_codes_on_code"

  create_table "available_times", :force => true do |t|
    t.integer  "tutor_id"
    t.datetime "start_at"
    t.datetime "end_at"
  end

  add_index "available_times", ["tutor_id"], :name => "index_available_times_on_tutor_id"

  create_table "bank_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "account_id"
    t.string   "account_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "bank_id"
  end

  add_index "bank_accounts", ["account_id"], :name => "index_bank_accounts_on_account_id"
  add_index "bank_accounts", ["account_type"], :name => "index_bank_accounts_on_account_type"
  add_index "bank_accounts", ["bank_id"], :name => "index_bank_accounts_on_bank_id"
  add_index "bank_accounts", ["owner_id"], :name => "index_bank_accounts_on_owner_id"
  add_index "bank_accounts", ["owner_type"], :name => "index_bank_accounts_on_owner_type"

  create_table "banks", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "basic_lesson_infos", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "subject_id"
    t.date     "final_day"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "status",              :default => "new", :null => false
    t.integer  "creator_id"
    t.datetime "tutor_changed_at"
    t.datetime "schedule_changed_at"
    t.date     "start_day"
    t.boolean  "auto_extension",      :default => true
    t.datetime "tutor_accepted_at"
    t.datetime "tutor_rejected_at"
    t.string   "type"
  end

  add_index "basic_lesson_infos", ["creator_id"], :name => "index_basic_lesson_infos_on_creator_id"
  add_index "basic_lesson_infos", ["subject_id"], :name => "index_basic_lesson_infos_on_subject_id"
  add_index "basic_lesson_infos", ["tutor_id"], :name => "index_basic_lesson_infos_on_tutor_id"

  create_table "basic_lesson_monthly_stats", :force => true do |t|
    t.integer  "basic_lesson_info_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "tutor_schedule_change_count", :default => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "basic_lesson_monthly_stats", ["basic_lesson_info_id", "year", "month"], :name => "index_basic_lesson_monthly_stats_on_basic_lesson_id_year_month", :unique => true
  add_index "basic_lesson_monthly_stats", ["basic_lesson_info_id"], :name => "index_basic_lesson_monthly_stats_on_basic_lesson_info_id"

  create_table "basic_lesson_possible_students", :force => true do |t|
    t.integer  "basic_lesson_info_id"
    t.integer  "student_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "basic_lesson_possible_students", ["basic_lesson_info_id"], :name => "index_basic_lesson_possible_students_on_basic_lesson_info_id"
  add_index "basic_lesson_possible_students", ["student_id"], :name => "index_basic_lesson_possible_students_on_student_id"

  create_table "basic_lesson_students", :force => true do |t|
    t.integer "basic_lesson_info_id"
    t.integer "student_id"
  end

  add_index "basic_lesson_students", ["basic_lesson_info_id"], :name => "index_basic_lesson_students_on_basic_lesson_info_id"
  add_index "basic_lesson_students", ["student_id"], :name => "index_basic_lesson_students_on_student_id"

  create_table "basic_lesson_weekday_schedules", :force => true do |t|
    t.integer  "basic_lesson_info_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "units"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "basic_lesson_weekday_schedules", ["basic_lesson_info_id"], :name => "index_basic_lesson_weekday_schedules_on_basic_lesson_info_id"

  create_table "bs_app_forms", :force => true do |t|
    t.integer  "bs_user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "corporate_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "skype_id"
    t.string   "pc_spec"
    t.string   "line_speed"
    t.date     "representative_birthday"
    t.string   "representative_sex"
    t.text     "reason_for_applying"
    t.boolean  "confirmed",                      :default => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "status",                         :default => "new"
    t.integer  "bs_id"
    t.string   "photo"
    t.string   "first_name_kana"
    t.string   "last_name_kana"
    t.string   "high_school"
    t.string   "college"
    t.string   "department"
    t.string   "graduate_college"
    t.string   "major"
    t.string   "job_history"
    t.boolean  "use_document_camera",            :default => true
    t.datetime "interview_datetime_1"
    t.datetime "interview_datetime_2"
    t.datetime "interview_datetime_3"
    t.datetime "confirmed_at"
    t.boolean  "adsl",                           :default => false
    t.integer  "os_id"
    t.float    "upload_speed"
    t.float    "download_speed"
    t.float    "windows_experience_index_score"
    t.string   "birth_place"
    t.string   "driver_license_number"
    t.string   "passport_number"
    t.string   "pc_model_number"
    t.string   "has_web_camera",                 :default => "no"
    t.string   "preferred_areas"
    t.string   "custom_os_name"
  end

  add_index "bs_app_forms", ["bs_id"], :name => "index_bs_app_forms_on_bs_id"
  add_index "bs_app_forms", ["bs_user_id"], :name => "index_bs_app_forms_on_bs_user_id"

  create_table "bs_monthly_results", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "lesson_sales_amount",            :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.boolean  "calculated",                     :default => false
    t.integer  "lesson_sales_of_regular_tutors", :default => 0
    t.integer  "bs_share_of_lesson_sales",       :default => 0
  end

  add_index "bs_monthly_results", ["organization_id"], :name => "index_bs_monthly_results_on_organization_id"
  add_index "bs_monthly_results", ["year", "month"], :name => "index_bs_monthly_results_on_year_and_month"

  create_table "charge_settings", :force => true do |t|
    t.string   "name"
    t.integer  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "charge_settings", ["name"], :name => "index_charge_settings_on_name"

  create_table "contact_list_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "contact_list_items", ["contactable_id"], :name => "index_contact_list_items_on_contactable_id"
  add_index "contact_list_items", ["contactable_type"], :name => "index_contact_list_items_on_contactable_type"
  add_index "contact_list_items", ["user_id"], :name => "index_contact_list_items_on_user_id"

  create_table "counters", :force => true do |t|
    t.string   "key"
    t.integer  "count",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "counters", ["key"], :name => "index_counters_on_key"

  create_table "credit_cards", :force => true do |t|
    t.string   "number"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cs_sheets", :force => true do |t|
    t.integer  "author_id"
    t.integer  "lesson_id"
    t.integer  "score"
    t.text     "content"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "handout",              :default => false
    t.boolean  "quiz",                 :default => false
    t.string   "reason_for_low_score"
  end

  add_index "cs_sheets", ["author_id"], :name => "index_cs_sheets_on_author_id"
  add_index "cs_sheets", ["lesson_id"], :name => "index_cs_sheets_on_lesson_id"

  create_table "custom_answers", :force => true do |t|
    t.integer  "answer_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "custom_answers", ["answer_id"], :name => "index_custom_answers_on_answer_id"

  create_table "custom_operating_systems", :force => true do |t|
    t.integer  "user_operating_system_id"
    t.string   "name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "custom_operating_systems", ["user_operating_system_id"], :name => "index_custom_operating_systems_on_user_operating_system_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "delayed_jobs", ["owner_id", "owner_type"], :name => "index_delayed_jobs_on_owner_id_and_owner_type"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dependents", :id => false, :force => true do |t|
    t.integer "parent_id"
    t.integer "student_id"
  end

  add_index "dependents", ["parent_id"], :name => "index_dependents_on_parent_id"
  add_index "dependents", ["student_id"], :name => "index_dependents_on_student_id"

  create_table "document_cameras", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "document_cameras", ["user_id"], :name => "index_document_cameras_on_user_id"

  create_table "error_logs", :force => true do |t|
    t.integer  "lesson_id"
    t.string   "error_code"
    t.string   "message"
    t.datetime "time_of_occurrence"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "exams", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "grade_id"
    t.integer  "subject_id"
    t.date     "month"
    t.string   "file"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.datetime "beginning_of_term"
    t.datetime "end_of_term"
    t.integer  "duration"
  end

  add_index "exams", ["creator_id"], :name => "index_exams_on_creator_id"
  add_index "exams", ["grade_id"], :name => "index_exams_on_grade_id"
  add_index "exams", ["subject_id"], :name => "index_exams_on_subject_id"

  create_table "general_bank_accounts", :force => true do |t|
    t.string   "branch_name"
    t.string   "branch_code"
    t.string   "account_type",             :default => "savings"
    t.string   "account_number"
    t.string   "account_holder_name"
    t.string   "account_holder_name_kana"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "bank_name"
    t.string   "bank_code"
  end

  create_table "grade_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "grade_group_order", :default => 0, :null => false
  end

  create_table "grade_groups_subjects", :force => true do |t|
    t.integer "grade_group_id"
    t.integer "subject_id"
  end

  add_index "grade_groups_subjects", ["grade_group_id"], :name => "index_grade_groups_subjects_on_grade_group_id"
  add_index "grade_groups_subjects", ["subject_id"], :name => "index_grade_groups_subjects_on_subject_id"

  create_table "grades", :force => true do |t|
    t.integer  "next_grade_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "group_id"
    t.string   "code"
    t.integer  "premium",       :default => 0
    t.boolean  "special",       :default => false
    t.integer  "grade_order"
  end

  add_index "grades", ["group_id"], :name => "index_grades_on_group_id"
  add_index "grades", ["next_grade_id"], :name => "index_grades_on_next_grade_id"

  create_table "hq_yucho_payments", :force => true do |t|
    t.integer  "yucho_account_id"
    t.integer  "monthly_statement_id"
    t.integer  "amount",               :default => 0, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "hq_yucho_payments", ["monthly_statement_id"], :name => "index_hq_yucho_payments_on_monthly_statement_id"
  add_index "hq_yucho_payments", ["yucho_account_id"], :name => "index_hq_yucho_payments_on_yucho_account_id"

  create_table "interviews", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "finished_at"
    t.text     "note"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "interviews", ["creator_id"], :name => "index_interviews_on_creator_id"
  add_index "interviews", ["user1_id"], :name => "index_interviews_on_user1_id"
  add_index "interviews", ["user2_id"], :name => "index_interviews_on_user2_id"

  create_table "lesson_cancellations", :force => true do |t|
    t.integer  "lesson_student_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "reason"
  end

  add_index "lesson_cancellations", ["lesson_student_id"], :name => "index_lesson_cancellations_on_lesson_student_id"

  create_table "lesson_charges", :force => true do |t|
    t.integer  "lesson_student_id"
    t.integer  "fee"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "organization_id"
    t.boolean  "contains_bs_share"
    t.boolean  "journalized",                    :default => false
    t.boolean  "contains_group_lesson_discount", :default => false
    t.boolean  "contains_extension_fee",         :default => false
  end

  add_index "lesson_charges", ["lesson_student_id"], :name => "index_lesson_charges_on_lesson_student_id"
  add_index "lesson_charges", ["organization_id"], :name => "index_lesson_charges_on_organization_id"

  create_table "lesson_dropouts", :force => true do |t|
    t.integer  "lesson_student_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "lesson_dropouts", ["lesson_student_id"], :name => "index_lesson_dropouts_on_lesson_student_id"

  create_table "lesson_extendabilities", :force => true do |t|
    t.integer  "lesson_id"
    t.boolean  "extendable", :default => false
    t.string   "reason"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "lesson_extendabilities", ["lesson_id"], :name => "index_lesson_extendabilities_on_lesson_id"

  create_table "lesson_extension_requests", :force => true do |t|
    t.integer  "lesson_student_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "lesson_extension_requests", ["lesson_student_id"], :name => "index_lesson_extension_requests_on_lesson_student_id"

  create_table "lesson_extensions", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "duration",   :default => 30
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "lesson_extensions", ["lesson_id"], :name => "index_lesson_extensions_on_lesson_id"

  create_table "lesson_invitations", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "student_id"
    t.string   "status",     :default => "new"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "lesson_invitations", ["lesson_id"], :name => "index_lesson_invitations_on_lesson_id"
  add_index "lesson_invitations", ["student_id"], :name => "index_lesson_invitations_on_student_id"

  create_table "lesson_materials", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.string   "material"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lesson_materials", ["lesson_id"], :name => "index_lesson_materials_on_lesson_id"
  add_index "lesson_materials", ["user_id"], :name => "index_lesson_materials_on_user_id"

  create_table "lesson_reports", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "author_id"
    t.integer  "student_id"
    t.text     "content"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "lesson_type"
    t.integer  "subject_id"
    t.integer  "tutor_id"
    t.text     "lesson_content"
    t.boolean  "has_attached_files", :default => false
    t.text     "understanding"
    t.text     "word_to_student"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "note"
    t.string   "homework_result"
    t.string   "textbook_usage"
    t.string   "homework"
  end

  add_index "lesson_reports", ["author_id"], :name => "index_lesson_reports_on_author_id"
  add_index "lesson_reports", ["lesson_id"], :name => "index_lesson_reports_on_lesson_id"
  add_index "lesson_reports", ["student_id"], :name => "index_lesson_reports_on_student_id"

  create_table "lesson_request_rejections", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.string   "reason"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lesson_request_rejections", ["lesson_id"], :name => "index_lesson_request_rejections_on_lesson_id"
  add_index "lesson_request_rejections", ["user_id"], :name => "index_lesson_request_rejections_on_user_id"

  create_table "lesson_settings", :force => true do |t|
    t.integer  "tutor_entry_period_before_start_time",   :default => 10, :null => false
    t.integer  "tutor_entry_period_after_start_time",    :default => 0,  :null => false
    t.integer  "student_entry_period_before_start_time", :default => 5,  :null => false
    t.integer  "student_entry_period_after_start_time",  :default => 45, :null => false
    t.integer  "dropout_limit",                          :default => 10, :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "request_time_limit",                     :default => 15
    t.integer  "max_units",                              :default => 5
    t.integer  "max_units_of_basic_lesson",              :default => 5
    t.string   "message_to_tutor"
    t.integer  "max_units_of_trial_lesson",              :default => 29
    t.integer  "duration_per_unit",                      :default => 45
    t.integer  "period_to_close_room_after_end_time",    :default => 10, :null => false
    t.integer  "student_entry_period_after_end_time",    :default => 0,  :null => false
    t.integer  "beginner_tutor_lessons_limit",           :default => 10, :null => false
  end

  create_table "lesson_students", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "student_id"
    t.datetime "attended_at"
    t.datetime "left_at"
    t.datetime "entered_at"
    t.datetime "cancelled_at"
    t.string   "status",                   :default => "active"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "base_lesson_fee_per_unit"
  end

  add_index "lesson_students", ["lesson_id"], :name => "index_lesson_students_on_lesson_id"
  add_index "lesson_students", ["student_id"], :name => "index_lesson_students_on_student_id"

  create_table "lesson_tutor_wages", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "wage"
    t.boolean  "includes_group_lesson_premium", :default => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "includes_extension_wage",       :default => false
    t.boolean  "journalized",                   :default => false
  end

  add_index "lesson_tutor_wages", ["lesson_id"], :name => "index_lesson_tutor_wages_on_lesson_id"

  create_table "lessons", :force => true do |t|
    t.string   "type"
    t.integer  "subject_id"
    t.integer  "tutor_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "units",                       :default => 1
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "status",                      :default => "new"
    t.boolean  "is_group_lesson",             :default => false
    t.integer  "friend_id"
    t.integer  "course_id"
    t.integer  "creator_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "cancelled_by"
    t.boolean  "extension_enabled",           :default => false
    t.float    "cs_point"
    t.boolean  "cs_sheets_collected",         :default => false
    t.datetime "original_start_time"
    t.datetime "original_end_time"
    t.boolean  "extended",                    :default => false
    t.boolean  "show_on_calendar",            :default => false
    t.boolean  "schedule_fixed",              :default => false
    t.boolean  "established",                 :default => false
    t.boolean  "door_closed",                 :default => false
    t.boolean  "delayed",                     :default => false
    t.boolean  "not_started",                 :default => false
    t.integer  "settlement_year"
    t.integer  "settlement_month"
    t.datetime "journalized_at"
    t.datetime "cancelled_at"
    t.datetime "tutor_attended_at"
    t.datetime "tutor_entered_at"
    t.string   "accounting_status",           :default => "unprocessed"
    t.integer  "tutor_base_hourly_wage"
    t.float    "upload_capacity_consumption", :default => 0.0
  end

  add_index "lessons", ["course_id"], :name => "index_lessons_on_course_id"
  add_index "lessons", ["creator_id"], :name => "index_lessons_on_creator_id"
  add_index "lessons", ["end_time"], :name => "index_lessons_on_end_time"
  add_index "lessons", ["friend_id"], :name => "index_lessons_on_friend_id"
  add_index "lessons", ["schedule_fixed"], :name => "index_lessons_on_schedule_fixed"
  add_index "lessons", ["show_on_calendar"], :name => "index_lessons_on_show_on_calendar"
  add_index "lessons", ["start_time"], :name => "index_lessons_on_start_time"
  add_index "lessons", ["status"], :name => "index_lessons_on_status"
  add_index "lessons", ["subject_id"], :name => "index_lessons_on_subject_id"
  add_index "lessons", ["tutor_id"], :name => "index_lessons_on_tutor_id"
  add_index "lessons", ["type"], :name => "index_lessons_on_type"

  create_table "meeting_members", :force => true do |t|
    t.integer  "meeting_id"
    t.integer  "user_id"
    t.integer  "preferred_schedule_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "prefers_other_schedule", :default => false
    t.datetime "joined_at"
  end

  add_index "meeting_members", ["meeting_id"], :name => "index_meeting_members_on_meeting_id"
  add_index "meeting_members", ["preferred_schedule_id"], :name => "index_meeting_members_on_preferred_schedule_id"
  add_index "meeting_members", ["user_id"], :name => "index_meeting_members_on_user_id"

  create_table "meeting_reports", :force => true do |t|
    t.integer  "meeting_id"
    t.integer  "author_id"
    t.text     "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "lesson_type"
    t.string   "subjects"
  end

  add_index "meeting_reports", ["author_id"], :name => "index_meeting_reports_on_author_id"
  add_index "meeting_reports", ["meeting_id"], :name => "index_meeting_reports_on_meeting_id"

  create_table "meeting_schedules", :force => true do |t|
    t.integer  "meeting_id"
    t.datetime "datetime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "meeting_schedules", ["meeting_id"], :name => "index_meeting_schedules_on_meeting_id"

  create_table "meetings", :force => true do |t|
    t.integer  "creator_id"
    t.datetime "datetime"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "status",      :default => "registering"
    t.integer  "schedule_id"
    t.datetime "closed_at"
    t.string   "type"
  end

  add_index "meetings", ["creator_id"], :name => "index_meetings_on_creator_id"
  add_index "meetings", ["type"], :name => "index_meetings_on_type"

  create_table "membership_applications", :force => true do |t|
    t.integer  "user_id"
    t.string   "status",             :default => "new"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "yucho_request_type"
    t.string   "type"
  end

  add_index "membership_applications", ["user_id"], :name => "index_membership_applications_on_user_id"

  create_table "membership_cancellations", :force => true do |t|
    t.integer  "user_id"
    t.string   "status",         :default => "new"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "reason"
    t.text     "error_messages"
  end

  add_index "membership_cancellations", ["user_id"], :name => "index_membership_cancellations_on_user_id"

  create_table "message_files", :force => true do |t|
    t.integer  "user_file_id"
    t.integer  "message_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "message_files", ["message_id"], :name => "index_message_files_on_message_id"
  add_index "message_files", ["user_file_id"], :name => "index_message_files_on_user_file_id"

  create_table "message_recipients", :force => true do |t|
    t.integer "message_id"
    t.integer "recipient_id"
    t.boolean "deleted",      :default => false
    t.string  "sender_name",                     :null => false
    t.boolean "is_read",      :default => false, :null => false
  end

  add_index "message_recipients", ["message_id"], :name => "index_message_recipients_on_message_id"
  add_index "message_recipients", ["recipient_id"], :name => "index_message_recipients_on_recipient_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "student_id"
    t.string   "title"
    t.text     "text"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "recipient_names"
    t.string   "recipient_names_for_hq_user"
    t.string   "recipient_names_for_bs_user"
    t.string   "recipient_names_for_coach"
    t.string   "recipient_names_for_tutor"
    t.string   "recipient_names_for_student"
    t.string   "recipient_names_for_parent"
    t.integer  "message_recipients_count",    :default => 0, :null => false
    t.integer  "original_message_id"
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["student_id"], :name => "index_messages_on_student_id"

  create_table "mitsubishi_tokyo_ufj_accounts", :force => true do |t|
    t.string   "branch_name"
    t.string   "branch_code"
    t.string   "account_number"
    t.string   "account_holder_name"
    t.string   "account_holder_name_kana"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "account_type",             :default => "savings"
  end

  create_table "monthly_charging_users", :id => false, :force => true do |t|
    t.integer  "year",       :null => false
    t.integer  "month",      :null => false
    t.integer  "user_id",    :null => false
    t.string   "user_type",  :null => false
    t.string   "user_name",  :null => false
    t.string   "full_name",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "monthly_charging_users", ["user_id"], :name => "index_monthly_charging_users_on_user_id"

  create_table "monthly_statement_calculations", :force => true do |t|
    t.integer  "year"
    t.integer  "month"
    t.string   "status",     :default => "new"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "monthly_statement_items", :force => true do |t|
    t.integer  "monthly_statement_id"
    t.integer  "year"
    t.integer  "month"
    t.string   "account_item"
    t.integer  "amount_of_payment",        :default => 0
    t.integer  "amount_of_money_received", :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "monthly_statement_items", ["account_item"], :name => "index_monthly_statement_items_on_account_item"
  add_index "monthly_statement_items", ["monthly_statement_id"], :name => "index_monthly_statement_items_on_monthly_statement_id"

  create_table "monthly_statement_update_requests", :id => false, :force => true do |t|
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "year",       :null => false
    t.integer  "month",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "monthly_statements", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "year"
    t.integer  "month"
    t.integer  "amount_of_payment",        :default => 0
    t.integer  "amount_of_money_received", :default => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "paid",                     :default => false
    t.integer  "tax_of_payment",           :default => 0
    t.integer  "tax_of_money_received",    :default => 0
  end

  add_index "monthly_statements", ["owner_id", "owner_type"], :name => "index_monthly_statements_on_owner_id_and_owner_type"

  create_table "no_charging_users", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "no_charging_users", ["user_id"], :name => "index_no_charging_users_on_user_id"

  create_table "operating_systems", :force => true do |t|
    t.string   "name"
    t.boolean  "windows_experience_index_score_available", :default => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "display_order",                            :default => 999
    t.boolean  "active",                                   :default => true
  end

  create_table "organizations", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "email"
    t.string   "phone_number"
    t.integer  "address_id"
    t.string   "area_code"
    t.boolean  "active",            :default => true
    t.integer  "representative_id"
    t.datetime "left_at"
  end

  add_index "organizations", ["address_id"], :name => "index_organizations_on_address_id"
  add_index "organizations", ["area_code"], :name => "index_organizations_on_area_code"
  add_index "organizations", ["representative_id"], :name => "index_organizations_on_representative_id"

  create_table "payment_methods", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "payment_methods", ["user_id"], :name => "index_payment_methods_on_user_id"

  create_table "payment_veritrans_txns", :force => true do |t|
    t.integer  "user_id"
    t.string   "order_id"
    t.string   "v_result_code"
    t.string   "cust_txn"
    t.string   "march_txn"
    t.string   "service_type"
    t.string   "mstatus"
    t.string   "txn_version"
    t.string   "card_transactiontype"
    t.string   "gateway_request_date"
    t.string   "gateway_response_date"
    t.string   "center_request_date"
    t.string   "center_response_date"
    t.string   "pending"
    t.string   "loopback"
    t.string   "connected_center_id"
    t.string   "amount"
    t.string   "item_code"
    t.string   "with_capture"
    t.string   "return_reference_number"
    t.string   "auth_code"
    t.string   "action_code"
    t.string   "acquirer_code"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "payment_veritrans_txns", ["order_id"], :name => "index_payment_veritrans_txns_on_order_id"
  add_index "payment_veritrans_txns", ["user_id"], :name => "index_payment_veritrans_txns_on_user_id"

  create_table "postal_codes", :force => true do |t|
    t.string   "prefecture"
    t.string   "city"
    t.string   "town"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "zip_code_id"
    t.integer  "area_code_id"
  end

  add_index "postal_codes", ["area_code_id"], :name => "index_postal_codes_on_area_code_id"
  add_index "postal_codes", ["zip_code_id"], :name => "index_postal_codes_on_zip_code_id"

  create_table "question_sheets", :force => true do |t|
    t.integer  "exam_id"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "question_sheets", ["exam_id"], :name => "index_question_sheets_on_exam_id"

  create_table "questions", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rate_settings", :force => true do |t|
    t.string   "name"
    t.float    "rate",       :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "rate_settings", ["name"], :name => "index_rate_settings_on_name"

  create_table "student_coaches", :force => true do |t|
    t.integer  "coach_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "student_coaches", ["coach_id"], :name => "index_student_coaches_on_coach_id"
  add_index "student_coaches", ["student_id"], :name => "index_student_coaches_on_student_id"

  create_table "student_exams", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "started_at"
  end

  add_index "student_exams", ["exam_id"], :name => "index_student_exams_on_exam_id"
  add_index "student_exams", ["student_id"], :name => "index_student_exams_on_student_id"

  create_table "student_favorite_tutors", :id => false, :force => true do |t|
    t.integer "student_id"
    t.integer "tutor_id"
  end

  add_index "student_favorite_tutors", ["student_id"], :name => "index_student_favorite_tutors_on_student_id"
  add_index "student_favorite_tutors", ["tutor_id"], :name => "index_student_favorite_tutors_on_tutor_id"

  create_table "student_infos", :force => true do |t|
    t.integer  "student_id"
    t.integer  "grade_id"
    t.string   "academic_results"
    t.boolean  "use_textbooks",                           :default => true
    t.boolean  "teach_by_using_textbooks"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.boolean  "lesson_reports_public",                   :default => false
    t.integer  "learning_grade_id"
    t.string   "note",                     :limit => 512
    t.boolean  "referenced_by_hq_user",                   :default => false
    t.string   "school"
  end

  add_index "student_infos", ["grade_id"], :name => "index_student_infos_on_grade_id"
  add_index "student_infos", ["student_id"], :name => "index_student_infos_on_student_id"

  create_table "student_lesson_tutors", :force => true do |t|
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "student_lesson_tutors", ["student_id"], :name => "index_student_lesson_tutors_on_student_id"
  add_index "student_lesson_tutors", ["tutor_id"], :name => "index_student_lesson_tutors_on_tutor_id"

  create_table "student_settings", :force => true do |t|
    t.integer "student_id"
    t.integer "max_charge", :default => 50000, :null => false
  end

  add_index "student_settings", ["student_id"], :name => "index_student_settings_on_student_id"

  create_table "subject_levels", :force => true do |t|
    t.integer "subject_id"
    t.integer "level",      :null => false
    t.string  "code",       :null => false
  end

  add_index "subject_levels", ["subject_id"], :name => "index_subject_levels_on_subject_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "grade_group_id"
  end

  add_index "subjects", ["grade_group_id"], :name => "index_subjects_on_grade_group_id"

  create_table "subjects_tutors", :force => true do |t|
    t.integer "subject_id"
    t.integer "tutor_id"
  end

  add_index "subjects_tutors", ["subject_id"], :name => "index_subjects_tutors_on_subject_id"
  add_index "subjects_tutors", ["tutor_id"], :name => "index_subjects_tutors_on_tutor_id"

  create_table "system_settings", :force => true do |t|
    t.integer  "entry_fee"
    t.integer  "message_storage_period"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "lesson_delay_limit",            :default => 10
    t.float    "bs_share_of_lesson_sales",      :default => 0.2
    t.integer  "cutoff_date",                   :default => 20
    t.float    "tutor_share_of_lesson_fee",     :default => 0.57
    t.integer  "calculation_date",              :default => 26
    t.integer  "default_max_charge",            :default => 50000
    t.float    "tax_rate",                      :default => 0.05
    t.integer  "document_camera_fps",           :default => 2
    t.integer  "document_camera_bandwidth",     :default => 0
    t.integer  "document_camera_quality",       :default => 90
    t.integer  "video_fps",                     :default => 10
    t.integer  "video_bandwidth",               :default => 16384
    t.integer  "video_quality",                 :default => 90
    t.integer  "document_camera_width",         :default => 720
    t.integer  "document_camera_height",        :default => 540
    t.integer  "meeting_video_bandwidth",       :default => 49152
    t.integer  "meeting_video_fps",             :default => 10
    t.integer  "meeting_video_quality",         :default => 90
    t.integer  "max_coach_count_for_area",      :default => 3
    t.string   "monitoring_email_address"
    t.integer  "camera_width",                  :default => 160
    t.integer  "camera_height",                 :default => 120
    t.integer  "meeting_camera_width",          :default => 640
    t.integer  "meeting_camera_height",         :default => 480
    t.boolean  "cs_point_visible",              :default => false
    t.string   "email_for_error_nortification"
    t.boolean  "free_mode",                     :default => false
    t.integer  "free_lesson_limit_number",      :default => 3
    t.integer  "free_lesson_expiration_date",   :default => 30
    t.float    "dropzone_max_filesize"
    t.float    "lesson_max_upload_capacity",    :default => 0.0
  end

  create_table "teaching_subjects", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "grade_group_id"
    t.integer  "subject_id"
    t.integer  "level",            :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "subject_level_id"
  end

  add_index "teaching_subjects", ["grade_group_id"], :name => "index_teaching_subjects_on_grade_group_id"
  add_index "teaching_subjects", ["subject_id"], :name => "index_teaching_subjects_on_subject_id"
  add_index "teaching_subjects", ["subject_level_id"], :name => "index_teaching_subjects_on_subject_level_id"
  add_index "teaching_subjects", ["tutor_id"], :name => "index_teaching_subjects_on_tutor_id"

  create_table "temp_yucho_accounts", :force => true do |t|
    t.string   "kigo1"
    t.string   "kigo2"
    t.string   "bango"
    t.string   "account_holder_name"
    t.string   "account_holder_name_kana"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "yucho_account_application_id"
  end

  create_table "tests", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "tests", ["email"], :name => "index_tests_on_email", :unique => true
  add_index "tests", ["reset_password_token"], :name => "index_tests_on_reset_password_token", :unique => true

  create_table "textbook_chapters", :force => true do |t|
    t.integer  "textbook_id"
    t.string   "title"
    t.integer  "pages"
    t.string   "dir"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "chapter_no"
  end

  add_index "textbook_chapters", ["textbook_id"], :name => "index_textbook_chapters_on_textbook_id"

  create_table "textbooks", :force => true do |t|
    t.integer  "textbook_id"
    t.string   "title"
    t.integer  "pages"
    t.string   "direction"
    t.boolean  "double_pages"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "width"
    t.integer  "height"
    t.string   "dir"
    t.integer  "textbook_set_id", :default => 1
    t.string   "grade"
    t.string   "subject"
  end

  add_index "textbooks", ["textbook_id"], :name => "index_textbooks_on_textbook_id"

  create_table "transactions", :force => true do |t|
    t.integer  "payer_id"
    t.string   "payer_type"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.integer  "amount",       :default => 0
    t.string   "account_item"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lesson_id"
    t.integer  "year"
    t.integer  "month"
  end

  add_index "transactions", ["lesson_id"], :name => "index_transactions_on_lesson_id"
  add_index "transactions", ["payee_id", "payee_type"], :name => "index_transactions_on_payee_id_and_payee_type"
  add_index "transactions", ["payer_id", "payer_type"], :name => "index_transactions_on_payer_id_and_payer_type"

  create_table "tutor_app_forms", :force => true do |t|
    t.integer  "tutor_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pc_mail"
    t.string   "phone_mail"
    t.string   "phone_number"
    t.string   "skype_id"
    t.string   "photo"
    t.string   "nickname"
    t.string   "college"
    t.string   "department"
    t.integer  "year_of_admission"
    t.integer  "year_of_graduation"
    t.string   "birth_place"
    t.string   "high_school"
    t.string   "activities"
    t.string   "teaching_experience"
    t.string   "teaching_results"
    t.string   "free_description"
    t.boolean  "confirmed",                                      :default => false
    t.string   "status",                                         :default => "new"
    t.boolean  "do_volunteer_work",                              :default => false
    t.boolean  "undertake_group_lesson",                         :default => false
    t.string   "job_history"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "first_name_kana"
    t.string   "last_name_kana"
    t.string   "sex"
    t.boolean  "graduated",                                      :default => false
    t.integer  "grade"
    t.string   "graduate_college"
    t.string   "major"
    t.date     "birthday"
    t.string   "grades_and_subjects"
    t.string   "pc_spec"
    t.string   "line_speed"
    t.boolean  "use_document_camera"
    t.string   "reference"
    t.boolean  "special_tutor"
    t.integer  "special_tutor_wage"
    t.datetime "interview_datetime_1"
    t.datetime "interview_datetime_2"
    t.datetime "interview_datetime_3"
    t.datetime "confirmed_at"
    t.boolean  "adsl",                                           :default => false
    t.integer  "os_id"
    t.float    "upload_speed"
    t.float    "download_speed"
    t.float    "windows_experience_index_score"
    t.string   "has_web_camera",                                 :default => "built_in"
    t.string   "graduate_college_department"
    t.string   "student_number"
    t.string   "driver_license_number"
    t.string   "passport_number"
    t.string   "pc_model_number"
    t.string   "jyuku_history"
    t.string   "favorite_books",                 :limit => 1000
    t.string   "faculty"
    t.string   "custom_os_name"
  end

  add_index "tutor_app_forms", ["tutor_id"], :name => "index_tutor_app_forms_on_tutor_id"

  create_table "tutor_daily_available_times", :force => true do |t|
    t.integer  "tutor_id",   :null => false
    t.datetime "start_at",   :null => false
    t.datetime "end_at",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tutor_daily_available_times", ["end_at"], :name => "index_tutor_daily_available_times_on_end_at"
  add_index "tutor_daily_available_times", ["start_at"], :name => "index_tutor_daily_available_times_on_start_at"
  add_index "tutor_daily_available_times", ["tutor_id"], :name => "index_tutor_daily_available_times_on_tutor_id"

  create_table "tutor_daily_lesson_skips", :force => true do |t|
    t.integer  "tutor_id"
    t.date     "date"
    t.integer  "count",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "tutor_daily_lesson_skips", ["tutor_id"], :name => "index_tutor_daily_lesson_skips_on_tutor_id"

  create_table "tutor_infos", :force => true do |t|
    t.integer  "tutor_id"
    t.string   "pc_mail"
    t.string   "phone_mail"
    t.string   "photo"
    t.string   "college"
    t.string   "department"
    t.integer  "year_of_admission"
    t.integer  "year_of_graduation"
    t.string   "birth_place"
    t.string   "high_school"
    t.string   "activities"
    t.string   "teaching_experience"
    t.string   "teaching_results"
    t.string   "free_description"
    t.string   "status",                                        :default => "new"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.float    "cs_points",                                     :default => 0.0
    t.boolean  "do_volunteer_work",                             :default => false
    t.boolean  "undertake_group_lesson",                        :default => false
    t.string   "job_history"
    t.integer  "upgrade_points",                                :default => 0
    t.integer  "total_lesson_units",                            :default => 0
    t.integer  "continuous_basic_lesson_count",                 :default => 0
    t.integer  "good_cs_score_count",                           :default => 0
    t.boolean  "graduated",                                     :default => false
    t.string   "graduate_college"
    t.integer  "grade"
    t.string   "major"
    t.boolean  "special_tutor",                                 :default => false
    t.boolean  "use_document_camera",                           :default => true
    t.string   "hobby"
    t.boolean  "photo_public",                                  :default => false
    t.float    "cs_points_of_recent_lessons",                   :default => 0.0
    t.float    "average_cs_points",                             :default => 0.0
    t.integer  "lesson_skip_count",                             :default => 0
    t.string   "graduate_college_department"
    t.string   "faculty"
    t.string   "student_number"
    t.string   "driver_license_number"
    t.string   "passport_number"
    t.string   "pc_model_number"
    t.string   "jyuku_history"
    t.string   "favorite_books",                :limit => 1000
  end

  add_index "tutor_infos", ["status"], :name => "index_tutor_infos_on_status"
  add_index "tutor_infos", ["tutor_id"], :name => "index_tutor_infos_on_tutor_id"

  create_table "tutor_lesson_cancellations", :force => true do |t|
    t.integer  "lesson_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "reason"
  end

  add_index "tutor_lesson_cancellations", ["lesson_id"], :name => "index_tutor_lesson_cancellations_on_lesson_id"

  create_table "tutor_monthly_incomes", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "current_amount",  :default => 0
    t.integer  "expected_amount", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "tutor_monthly_incomes", ["tutor_id"], :name => "index_tutor_monthly_incomes_on_tutor_id"

  create_table "tutor_price_histories", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "hourly_wage"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tutor_price_histories", ["tutor_id"], :name => "index_tutor_price_histories_on_tutor_id"

  create_table "tutor_prices", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "hourly_wage"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "lesson_fee_0"
    t.integer  "lesson_fee_50"
    t.integer  "lesson_fee_100"
    t.integer  "lesson_fee_200"
  end

  add_index "tutor_prices", ["tutor_id"], :name => "index_tutor_prices_on_tutor_id"

  create_table "tutor_students", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "student_id"
    t.boolean  "lesson_report", :default => true
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "tutor_students", ["student_id"], :name => "index_tutor_students_on_student_id"
  add_index "tutor_students", ["tutor_id"], :name => "index_tutor_students_on_tutor_id"

  create_table "unavailable_days", :force => true do |t|
    t.integer "tutor_id"
    t.date    "date"
  end

  add_index "unavailable_days", ["tutor_id"], :name => "index_unavailable_days_on_tutor_id"

  create_table "user_files", :force => true do |t|
    t.integer  "user_id"
    t.string   "file"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "size",       :default => 0
  end

  add_index "user_files", ["user_id"], :name => "index_user_files_on_user_id"

  create_table "user_monthly_stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "optional_lesson_cancellation_count", :default => 0
    t.integer  "basic_lesson_cancellation_count",    :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "lesson_extension_charge",            :default => 0
    t.integer  "lesson_charge",                      :default => 0
  end

  add_index "user_monthly_stats", ["user_id", "year", "month"], :name => "index_user_monthly_stats_on_user_id_and_year_and_month", :unique => true
  add_index "user_monthly_stats", ["user_id"], :name => "index_user_monthly_stats_on_user_id"

  create_table "user_operating_systems", :force => true do |t|
    t.integer  "user_id"
    t.integer  "operating_system_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "user_operating_systems", ["operating_system_id"], :name => "index_user_operating_systems_on_operating_system_id"
  add_index "user_operating_systems", ["user_id"], :name => "index_user_operating_systems_on_user_id"

  create_table "user_registration_emails", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "email",      :null => false
    t.string   "token",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_registration_forms", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "email"
    t.boolean  "adsl",                           :default => false
    t.string   "confirmation_token"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.float    "upload_speed"
    t.float    "download_speed"
    t.integer  "os_id"
    t.float    "windows_experience_index_score"
    t.integer  "parent_id"
  end

  add_index "user_registration_forms", ["type"], :name => "index_user_registration_forms_on_type"
  add_index "user_registration_forms", ["user_id"], :name => "index_user_registration_forms_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "user_name",                      :default => "",         :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.date     "birthday"
    t.string   "sex"
    t.string   "phone_number"
    t.string   "email",                          :default => "",         :null => false
    t.string   "encrypted_password",             :default => "",         :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "organization_id"
    t.string   "nickname"
    t.integer  "reference_id"
    t.string   "skype_id"
    t.string   "pc_spec"
    t.string   "line_speed"
    t.boolean  "active",                         :default => true
    t.string   "photo"
    t.string   "phone_email"
    t.string   "pc_email"
    t.string   "gmail"
    t.boolean  "admin",                          :default => false
    t.datetime "left_at"
    t.string   "reason_to_leave"
    t.string   "first_name_kana"
    t.string   "last_name_kana"
    t.datetime "enrolled_at"
    t.boolean  "has_credit_card",                :default => false
    t.integer  "parent_id"
    t.boolean  "adsl",                           :default => false
    t.float    "upload_speed"
    t.float    "download_speed"
    t.integer  "os_id"
    t.float    "windows_experience_index_score"
    t.string   "status",                         :default => "new"
    t.integer  "weekday_schedules_count",        :default => 0,          :null => false
    t.string   "birth_place"
    t.string   "driver_license_number"
    t.string   "passport_number"
    t.string   "pc_model_number"
    t.string   "has_web_camera",                 :default => "built_in"
    t.integer  "student_favorite_tutors_count",  :default => 0,          :null => false
    t.datetime "last_request_at"
    t.integer  "daily_available_times_count",    :default => 0,          :null => false
    t.string   "timezone"
    t.string   "customer_type"
    t.boolean  "switching_to_yucho"
    t.integer  "free_lesson_taken",              :default => 0
    t.datetime "date_of_becoming_free_user"
    t.integer  "free_lesson_reservation",        :default => 0
    t.integer  "free_lesson_limit_number",       :default => 3
    t.integer  "free_lesson_expiration_date",    :default => 30
    t.integer  "journalized_free_lesson_count",  :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["parent_id"], :name => "index_users_on_parent_id"
  add_index "users", ["reference_id"], :name => "index_users_on_reference_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["status"], :name => "index_users_on_status"
  add_index "users", ["type"], :name => "index_users_on_type"
  add_index "users", ["user_name"], :name => "user_name", :unique => true

  create_table "weekday_schedules", :force => true do |t|
    t.integer  "tutor_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "weekday_schedules", ["tutor_id"], :name => "index_weekday_schedules_on_tutor_id"

  create_table "yucho_accounts", :force => true do |t|
    t.string   "kigo1"
    t.string   "kigo2"
    t.string   "bango"
    t.string   "account_holder_name"
    t.string   "account_holder_name_kana"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "yucho_billings", :force => true do |t|
    t.integer  "yucho_account_id"
    t.integer  "monthly_statement_id"
    t.integer  "amount",               :default => 0, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "yucho_billings", ["monthly_statement_id"], :name => "index_yucho_billings_on_monthly_statement_id"
  add_index "yucho_billings", ["yucho_account_id"], :name => "index_yucho_billings_on_yucho_account_id"

  create_table "zip_codes", :force => true do |t|
    t.string  "code",                            :null => false
    t.integer "area_codes_count", :default => 0, :null => false
  end

  add_index "zip_codes", ["code"], :name => "index_zip_codes_on_code"

end
