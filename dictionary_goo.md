

# 概要 #

  * グー辞書を引いてみる

# シナリオ #

  * [goodic\_20110220.zip](http://cowares-wpost.googlecode.com/svn/trunk/goo_jp/goodic_20110220.zip) グー辞書パックのダウンロード
  * [シナリオとスクリプトの閲覧](http://code.google.com/p/cowares-wpost/source/browse/trunk/goo_jp/)

# 解析手順 #

  1. `<!--RIGHTSIDE-->` 以降は不要。
  1. `<dl ...>..</dl>` タグ内に結果がある。
  1. `<dt></dt>` が見出し。
  1. `<dd></dd>` が説明。
  1. リンクとかいらないのでタグを消す。

# goodic.vbs #

  * goodic.bat をラップして GUI にしてみた。
  * 積み上げるより、 bat 経由しないで直に動かした方がきれいだけど、とりあえずの用途には便利。