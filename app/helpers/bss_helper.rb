module BssHelper
  def bs_name(bs)
    bs.name.present? ? bs.name : t('common.bs')
  end
end