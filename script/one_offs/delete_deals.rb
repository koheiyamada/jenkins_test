# encoding:utf-8
# 会計科目モデル群を作成する
model_names = %w(
  EntryFeeDeal
  BasicLessonTutorFeeDeal
  BasicLessonFeeDeal
  BsIdManagementFeeDeal
  StudentIdManagementFeeDeal
  TextbookUsageFeeDeal
  OptionalLessonTutorFeeDeal
  TutorReferralFeeDeal
  StudentReferralFeeDeal
  OptionalLessonFeeDeal
  ExaminationFeeDeal
  LessonSaleAmountDeal
  ScoringFeeDeal
  TextbookRentalFeeDeal
  BsTextbookRentalFeeDeal
  SobaIdManagementFeeDeal
  BeginnerTutorDiscountDeal
  GroupLessonDiscountDeal
  GroupLessonPremiumDeal
  LessonDelayReductionDeal
  LessonCancellationPenaltyDeal
  Exam2FeeDeal
  Exam3FeeDeal
  Exam4FeeDeal
  Exam5FeeDeal
)

model_names.each do |model_name|
  `rails d model Deal::#{model_name}`
end
