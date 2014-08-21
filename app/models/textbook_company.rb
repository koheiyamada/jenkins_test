class TextbookCompany < Organization
  #include Ledgerable

  class << self
    def instance
      TextbookCompany.first
    end
  end
end
