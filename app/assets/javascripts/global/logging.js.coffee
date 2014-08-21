# consoleが定義されていないブラウザ向けの空の定義
unless window.console?
  window.console =
    log: ()->
    error: ()->
