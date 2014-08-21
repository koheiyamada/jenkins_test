# encoding:utf-8
# 会計科目モデル群を作成する
model_names = %w(
  EntryFee
  BsIdManagementFee
  StudentIdManagementFee
  TextbookUsageFee
  BasicLessonTutorFee
  OptionalLessonTutorFee
  TutorReferralFee
  StudentReferralFee
  BasicLessonFee
  OptionalLessonFee
  ExaminationFee
  LessonSaleAmount
  ScoringFee
  TextbookRentalFee
  BsTextbookRentalFee
  SobaIdManagementFee
  BeginnerTutorDiscount
  GroupLessonDiscount
  GroupLessonPremium
  LessonDelayReduction
  LessonCancellationPenalty
)

model_names.each do |model_name|
  `rails g model Account::#{model_name} --parent=Account::JournalEntry`
end
