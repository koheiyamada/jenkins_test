# -*- encoding: utf-8 -*-
include Veritrans::Tercerog::Mdk

module Veritrans
  module Tercerog
    module Mdk

      #
      # =検索結果:決済オーダー情報のクラス
      #
      # @author:: t.honma
      #
      class ProperOrderInfo

        #
        # ===コンストラクタ
        #
        def initialize
          @proper_transaction_info = Veritrans::Tercerog::Mdk::BaseDto.new
        end

        #
        # ===決済方式を取得する
        #
        # @return:: 決済方式
        #
        def settlement_method
          @settlement_method
        end

        #
        # ===決済方式を設定する
        #
        # @param:: settlementMethod 決済方式
        #
        def settlement_method=(settlementMethod)
          @settlement_method = settlementMethod
        end

        #
        # ===決済タイプを取得する
        #
        # @return:: 決済タイプ
        #
        def settlement_type
          @settlement_type
        end

        #
        # ===決済タイプを設定する
        #
        # @param:: settlementType 決済タイプ
        #
        def settlement_type=(settlementType)
          @settlement_type = settlementType
        end

        #
        # ===決済金額を取得する
        #
        # @return:: 決済金額
        #
        def amount
          @amount
        end

        #
        # ===決済金額を設定する
        #
        # @param:: amount 決済金額
        #
        def amount=(amount)
            @amount = amount
        end

        #
        # ===決済期限を取得する
        #
        # @return:: 決済期限
        #
        def settlement_limit
          @settlement_limit
        end

        #
        # ===決済期限を設定する
        #
        # @param:: settlementLimit 決済期限
        #
        def settlement_limit=(settlementLimit)
          @settlement_limit = settlementLimit
        end

        #
        # ===転送メール送信要否を取得する
        #
        # @return:: 転送メール送信要否
        #
        def forward_mail_flag
          @forward_mail_flag
        end

        #
        # ===転送メール送信要否を設定する
        #
        # @param:: forwardMailFlag 転送メール送信要否
        #
        def forward_mail_flag=(forwardMailFlag)
          @forward_mail_flag = forwardMailFlag
        end

        #
        # ===マーチャントメールアドレスを取得する
        #
        # @return:: マーチャントメールアドレス
        #
        def merchant_mail_addr
          @merchant_mail_addr
        end

        #
        # ===マーチャントメールアドレスを設定する
        #
        # @param:: merchantMailAddr マーチャントメールアドレス
        #
        def merchant_mail_addr=(merchantMailAddr)
          @merchant_mail_addr = merchantMailAddr
        end

        #
        # ===取消返金通知メールアドレスを取得する
        #
        # @return:: 取消返金通知メールアドレス
        #
        def cancel_mail_addr
          @cancel_mail_addr
        end

        #
        # ===取消返金通知メールアドレスを設定する
        #
        # @param:: cancelMailAddr 取消返金通知メールアドレス
        #
        def cancel_mail_addr=(cancelMailAddr)
          @cancel_mail_addr = cancelMailAddr
        end

        #
        # ===依頼メール付加情報を取得する
        #
        # @return:: 依頼メール付加情報
        #
        def request_mail_add_info
          @request_mail_add_info
        end

        #
        # ===依頼メール付加情報を設定する
        #
        # @param:: requestMailAddInfo 依頼メール付加情報
        #
        def request_mail_add_info=(requestMailAddInfo)
          @request_mail_add_info = requestMailAddInfo
        end

        #
        # ===完了メール付加情報を取得する
        #
        # @return:: 完了メール付加情報
        #
        def complete_mail_add_info
          @complete_mail_add_info
        end

        #
        # ===完了メール付加情報を設定する
        #
        # @param:: completeMailAddInfo 完了メール付加情報
        #
        def complete_mail_add_info=(completeMailAddInfo)
          @complete_mail_add_info = completeMailAddInfo
        end

        #
        # ===ショップ名を取得する
        #
        # @return:: ショップ名
        #
        def shop_name
          @shop_name
        end

        #
        # ===ショップ名を設定する
        #
        # @param:: shopName ショップ名
        #
        def shop_name=(shopName)
          @shop_name = shopName
        end

        #
        # ===完了メール送信要否を取得する
        #
        # @return:: 完了メール送信要否
        #
        def complete_mail_flag
          @complete_mail_flag
        end

        #
        # ===完了メール送信要否を設定する
        #
        # @param:: completeMailFlag 完了メール送信要否
        #
        def complete_mail_flag=(completeMailFlag)
          @complete_mail_flag = completeMailFlag
        end

        #
        # ===内容確認画面付加情報を取得する
        #
        # @return:: 内容確認画面付加情報
        #
        def confirm_screen_add_info
          @confirm_screen_add_info
        end

        #
        # ===内容確認画面付加情報を設定する
        #
        # @param:: confirmScreenAddInfo 内容確認画面付加情報
        #
        def confirm_screen_add_info=(confirmScreenAddInfo)
          @confirm_screen_add_info = confirmScreenAddInfo
        end

        #
        # ===完了画面付加情報を取得する
        #
        # @return:: 完了画面付加情報
        #
        def complete_screen_add_info
          @complete_screen_add_info
        end

        #
        # ===完了画面付加情報を設定する
        #
        # @param:: completeScreenAddInfo 完了画面付加情報
        #
        def complete_screen_add_info=(completeScreenAddInfo)
          @complete_screen_add_info = completeScreenAddInfo
        end

        #
        # ===画面タイトルを取得する
        #
        # @return:: 画面タイトル
        #
        def screen_title
          @screen_title
        end

        #
        # ===画面タイトルを設定する
        #
        # @param:: screenTitle 画面タイトル
        #
        def screen_title=(screenTitle)
          @screen_title = screenTitle
        end

        #
        # ===決済完了戻り先種別を取得する
        #
        # @return:: 決済完了戻り先種別
        #
        def complete_return_kind
          @complete_return_kind
        end

        #
        # ===決済完了戻り先種別を設定する
        #
        # @param:: completeReturnKind 決済完了戻り先種別
        #
        def complete_return_kind=(completeReturnKind)
          @complete_return_kind = completeReturnKind
        end

        #
        # ===決済完了戻り先URLを取得する
        #
        # @return:: 決済完了戻り先URL
        #
        def complete_return_url
          @complete_return_url
        end

        #
        # ===決済完了戻り先URLを設定する
        #
        # @param:: completeReturnUrl 決済完了戻り先URL
        #
        def complete_return_url=(completeReturnUrl)
          @complete_return_url = completeReturnUrl
        end

        #
        # ===決済完了通知URLを取得する
        #
        # @return:: 決済完了通知URL
        #
        def complete_notice_url
          @complete_notice_url
        end

        #
        # ===決済完了通知URLを設定する
        #
        # @param:: completeNoticeUrl 決済完了通知URL
        #
        def complete_notice_url=(completeNoticeUrl)
          @complete_notice_url = completeNoticeUrl
        end

        #
        # ===販売区分を取得する
        #
        # @return:: 販売区分
        #
        def sales_type
          @sales_type
        end

        #
        # ===販売区分を設定する
        #
        # @param:: salesType 販売区分
        #
        def sales_type=(salesType)
          @sales_type = salesType
        end

        #
        # ===備考を取得する
        #
        # @return:: 備考
        #
        def free
          @free
        end

        #
        # ===備考を設定する
        #
        # @param:: free 備考
        #
        def free=(free)
          @free = free
        end

        #
        # ===返金オーダーIDを取得する
        #
        # @return:: 返金オーダーID
        #
        def refund_order_ctl_id
          @refund_order_ctl_id
        end

        #
        # ===返金オーダーIDを設定する
        #
        # @param:: refundOrderCtlId 返金オーダーID
        #
        def refund_order_ctl_id=(refundOrderCtlId)
          @refund_order_ctl_id = refundOrderCtlId
        end

        #
        # ===決済アプリ起動URLを取得する
        #
        # @return:: 決済アプリ起動URL
        #
        def app_url
          @app_url
        end

        #
        # ===決済アプリ起動URLを設定する
        #
        # @param:: appUrl 決済アプリ起動URL
        #
        def app_url=(appUrl)
          @app_url = appUrl
        end

        #
        # ===オーダー種別を取得する
        #
        # @return:: オーダー種別
        #
        def order_kind
          @order_kind
        end

        #
        # ===オーダー種別を設定する
        #
        # @param:: orderKind オーダー種別
        #
        def order_kind=(orderKind)
          @order_kind = orderKind
        end

        #
        # ===完了日時を取得する
        #
        # @return:: 完了日時
        #
        def complete_datetime
          @complete_datetime
        end

        #
        # ===完了日時を設定する
        #
        # @param:: completeDatetime 完了日時
        #
        def complete_datetime=(completeDatetime)
          @complete_datetime = completeDatetime
        end

        #
        # ===決済サービスオプションを取得する
        #
        # @return:: 決済サービスオプション
        #
        def cvs_type
          @cvs_type
        end

        #
        # ===決済サービスオプションを設定する
        #
        # @paracvsType m 決済サービスオプション
        #
        def cvs_type=(cvsType)
          @cvs_type = cvsType
        end

        #
        # ===氏名１を取得する
        #
        # @return:: 氏名１
        #
        def name1
          @name1
        end

        #
        # ===氏名１を設定する
        #
        # @param:: name1 氏名１
        #
        def name1=(name1)
          @name1 = name1
        end

        #
        # ===氏名２を取得する
        #
        # @return:: 氏名２
        #
        def name2
          @name2
        end

        #
        # ===氏名２を設定する
        #
        # @param:: name2 氏名２
        #
        def name2=(name2)
          @name2 = name2
        end

        #
        # ===カナを取得する
        #
        # @return:: カナ
        #
        def kana
          @kana
        end

        #
        # ===カナを設定する
        #
        # @param:: kana カナ
        #
        def kana=(kana)
          @kana = kana
        end

        #
        # ===電話番号を取得する
        #
        # @return:: 電話番号
        #
        def tel_no
          @tel_no
        end

        #
        # ===電話番号を設定する
        #
        # @param:: telNo 電話番号
        #
        def tel_no=(telNo)
          @tel_no = telNo
        end

        #
        # ===メールアドレスを取得する
        #
        # @return:: メールアドレス
        #
        def mail_addr
          @mail_addr
        end

        #
        # ===メールアドレスを設定する
        #
        # @param:: mailAddr メールアドレス
        #
        def mail_addr=(mailAddr)
          @mail_addr = mailAddr
        end

        #
        # ===備考１を取得する
        #
        # @return:: 備考１
        #
        def free1
          @free1
        end

        #
        # ===備考１を設定する
        #
        # @param:: free1 備考１
        #
        def free1=(free1)
          @free1 = free1
        end

        #
        # ===備考２を取得する
        #
        # @return:: 備考２
        #
        def free2
          @free2
        end

        #
        # ===備考２を設定する
        #
        # @param:: free2 備考２
        #
        def free2=(free2)
          @free2 = free2
        end

        #
        # ===支払期限を取得する
        #
        # @return:: 支払期限
        #
        def pay_limit
          @pay_limit
        end

        #
        # ===支払期限を設定する
        #
        # @param:: payLimit 支払期限
        #
        def pay_limit=(payLimit)
          @pay_limit = payLimit
        end

        #
        # ===受付番号を取得する
        #
        # @return:: 受付番号
        #
        def receipt_no
          @receipt_no
        end

        #
        # ===受付番号を設定する
        #
        # @param:: receiptNo 受付番号
        #
        def receipt_no=(receiptNo)
          @receipt_no = receiptNo
        end

        #
        # ===入金受付日を取得する
        #
        # @return:: 入金受付日
        #
        def paid_datetime
          @paid_datetime
        end

        #
        # ===入金受付日を設定する
        #
        # @param:: paidDatetime 入金受付日
        #
        def paid_datetime=(paidDatetime)
          @paid_datetime = paidDatetime
        end

        #
        # ===収納日時を取得する
        #
        # @return:: 収納日時
        #
        def received_datetime
          @received_datetime
        end

        #
        # ===収納日時を設定する
        #
        # @param:: receivedDatetime 収納日時
        #
        def received_datetime=(receivedDatetime)
          @received_datetime = receivedDatetime
        end

        #
        # ===電文IDを取得する
        #
        # @return:: 電文ID
        #
        def start_txn
          @start_txn
        end

        #
        # ===電文IDを設定する
        #
        # @param:: startTxn 電文ID
        #
        def start_txn=(startTxn)
          @start_txn = startTxn
        end

        #
        # ===3Dメッセージバージョンを取得する
        #
        # @return:: 3Dメッセージバージョン
        #
        def ddd_message_version
          @ddd_message_version
        end

        #
        # ===3Dメッセージバージョンを設定する
        #
        # @param:: dddMessageVersion 3Dメッセージバージョン
        #
        def ddd_message_version=(dddMessageVersion)
         @ddd_message_version = dddMessageVersion
        end

        #
        # ===要求通貨単位を取得する
        #
        # @return:: 要求通貨単位
        #
        def request_currency_unit
          @request_currency_unit
        end

        #
        # ===要求通貨単位を設定する
        #
        # @param:: requestCurrencyUnit 要求通貨単位
        #
        def request_currency_unit=(requestCurrencyUnit)
          @request_currency_unit = requestCurrencyUnit
        end

        #
        # ===カード有効期限を取得する
        #
        # @return:: カード有効期限
        #
        def card_expire
          @card_expire
        end

        #
        # ===カード有効期限を設定する
        #
        # @param:: cardExpire カード有効期限
        #
        def card_expire=(cardExpire)
          @card_expire = cardExpire
        end

        #
        # ===広告URLを取得する
        #
        # @return:: 広告URL
        #
        def trad_url
          @trad_url
        end

        #
        # ===広告URLを設定する
        #
        # @param:: tradUrl 広告URL
        #
        def trad_url=(tradUrl)
          @trad_url = tradUrl
        end

        #
        # ===請求番号を取得する
        #
        # @return:: 請求番号
        #
        def invoice_id
          @invoice_id
        end

        #
        # ===請求番号を設定する
        #
        # @param:: invoiceId 請求番号
        #
        def invoice_id=(invoiceId)
          @invoice_id = invoiceId
        end

        #
        # ===顧客番号を取得する
        #
        # @return:: 顧客番号
        #
        def payer_id
          @payer_id
        end

        #
        # ===顧客番号を設定する
        #
        # @param:: payerId 顧客番号
        #
        def payer_id=(payerId)
          @payer_id = payerId
        end

        #
        # ===支払日時を取得する
        #
        # @return:: 支払日時
        #
        def payment_datetime
          @payment_datetime
        end

        #
        # ===支払日時を設定する
        #
        # @param:: paymentDatetime 支払日時
        #
        def payment_datetime=(paymentDatetime)
          @payment_datetime = paymentDatetime
        end

        #
        # ===マーチャントリダイレクトURIを取得する
        #
        # @return:: マーチャントリダイレクトURI
        #
        def merchant_redirect_uri
          @merchant_redirect_uri
        end

        #
        # ===マーチャントリダイレクトURIを設定する
        #
        # @param:: merchantRedirectUri マーチャントリダイレクトURI
        #
        def merchant_redirect_uri=(merchantRedirectUri)
          @merchant_redirect_uri = merchantRedirectUri
        end

        #
        # ===決済金額を取得する
        #
        # @return:: 決済金額
        #
        def total_amount
          @total_amount
        end

        #
        # ===決済金額を設定する
        #
        # @param:: totalAmount 決済金額
        #
        def total_amount=(totalAmount)
          @total_amount = totalAmount
        end

        #
        # ===ウォレット決済金額を取得する
        #
        # @return:: ウォレット決済金額
        #
        def wallet_amount
          @wallet_amount
        end

        #
        # ===ウォレット決済金額を設定する
        #
        # @param:: walletAmount ウォレット決済金額
        #
        def wallet_amount=(walletAmount)
          @wallet_amount = walletAmount
        end

        #
        # ===カード決済金額を取得する
        #
        # @return:: カード決済金額
        #
        def card_amount
          @card_amount
        end

        #
        # ===カード取引IDを取得する
        #
        # @return:: カード取引ID
        #
        def card_order_id
          @card_order_id
        end

        #
        # ===カード取引IDを設定する
        #
        # @param:: cardOrderId カード取引ID
        #
        def card_order_id=(cardOrderId)
          @card_order_id = cardOrderId
        end

        #
        # ===カード決済金額を設定する
        #
        # @param:: cardAmount カード決済金額
        #
        def card_amount=(cardAmount)
          @card_amount = cardAmount
        end

        #
        # ===固有トランザクション情報を取得する
        #
        # @return:: 固有トランザクション情報
        #
        def proper_transaction_info
          @proper_transaction_info
        end

        #
        # ===固有トランザクション情報を設定する
        #
        # @param:: properTransactionInfo 固有トランザクション情報
        #
        def proper_transaction_info=(properTransactionInfo)
          @proper_transaction_info = properTransactionInfo
        end

      end
    end
  end
end