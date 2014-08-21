class TutorSearch
  class SortObject
    def initialize(key, order)
      @key = key.to_sym
      @order = order.to_sym
    end

    attr_reader :key, :order
  end
end