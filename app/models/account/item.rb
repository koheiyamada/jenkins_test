class Account::Item
  class << self
    def all
      all_items
    end

    def items_for(role)
      items_for_role[role]
    end

    private

    def items_for_role
      @items_for_role ||= base_data.each_with_object({}) do |(account_item, data), obj|
        data["roles"].map(&:to_sym).each do |role|
          obj[role] = [] unless obj.has_key?(role)
          obj[role] << account_item
        end
      end
    end

    def all_items
      base_data.keys
    end

    def base_data
      @base_data ||= YAML.load_file(Rails.root.join('db/data/account_items.yml'))
    end
  end
end