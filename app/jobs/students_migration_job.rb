class StudentsMigrationJob < Struct.new(:bs_id)
  def perform
    bs = Bs.find_by_id(bs_id)
    if bs
      migration = BsMigrationService.new(bs)
      migration.immigrate_students_from_headquarter
      Rails.logger.info 'Executed students migration process'
    end
  end
end
