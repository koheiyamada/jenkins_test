module Searchable
  def self.included(base)
    base.after_save :update_index_async
  end

  def update_index_async
    if should_update_index?
      delay.update_index!
    end
  end

  private

    def should_update_index?
      true
    end

    def update_index!
      index!
      logger.info "INDEX UPDATED: type: #{self.class.name}, id: #{id}"
    end
end