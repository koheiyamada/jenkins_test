# coding:utf-8

class YuchoAccountService
  def compile_billings_and_payments_files(year, month)
    compile_billings_file_of_month year, month
    compile_payments_file_of_month year, month
  end

  # 受講者、保護者へのゆうちょでの請求データを作成する
  def compile_billings_file_of_month(year, month)
    prepare_directory_of_month(year, month)
    file = billings_file_of_month(year, month)
    billing = YuchoBillingService.new
    billing.clear_billings_for_month(year, month)
    billing.make_billings_for_month(year, month)
    billing.print_billings_for_month(year, month, file)
  end

  # チューター、BSへのゆうちょでの支払データを作成する
  def compile_payments_file_of_month(year, month)
    prepare_directory_of_month(year, month)
    file = payments_file_of_month(year, month)
    payment = YuchoPaymentService.new
    payment.clear_payments_for_month(year, month)
    payment.make_payments_for_month(year, month)
    payment.print_payments_for_month(year, month, file)
  end

  def billings_file_of_month(year, month)
    directory_of_month(year, month) + 'payments.csv' # ファイル名は外部の人視点になっている
  end

  def payments_file_of_month(year, month)
    directory_of_month(year, month) + 'receipts.csv' # ファイル名は外部の人視点になっている
  end

  private

    def prepare_directory_of_month(year, month)
      dir = directory_of_month(year, month)
      unless Dir.exists?(dir)
        FileUtils.makedirs(dir)
      end
    end

    def directory_of_month(year, month)
      Rails.root.join('public', 'yucho_accounts', year.to_s, month.to_s)
    end
end