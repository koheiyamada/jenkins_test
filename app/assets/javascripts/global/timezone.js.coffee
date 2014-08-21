# タイムゾーン
# timezone: システムのタイムゾーン。変更不可
# preferred_timezone: ユーザが設定できるタイムゾーン。変更可能。
class AID.TimeZone
  TIMEZONE_KEY: 'timezone'

  constructor: ->
    @timezone = $("html").get_timezone()

  save: ->
    stored_timezone = @loadStoredTimeZone()
    if stored_timezone != @timezone
      $.cookie(@TIMEZONE_KEY, @timezone, expires: 1)

  loadStoredTimeZone: ->
    $.cookie(@TIMEZONE_KEY)

  getTimeZone: ->
    @timezone

timezone = new AID.TimeZone()
timezone.save()
window.AID.getTimeZone = -> timezone
