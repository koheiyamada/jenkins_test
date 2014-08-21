module ProfilesHelper
  def address_format(address)
    t("common.address_format", postal_code:address.postal_code, address:address.address)
  end
end
