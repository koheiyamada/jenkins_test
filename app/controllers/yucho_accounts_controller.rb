class YuchoAccountsController < BankAccountsController
  before_filter do
    params[:bank] = 'yucho'
  end
end
