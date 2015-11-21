

# 概要 #

  * 携帯用ツイッターを使ってみる
  * `twtr.jp` という、日本の携帯向けアドレスがあるので、試してみよう

# シナリオ #

  * [tweet\_20110220.zip](http://cowares-wpost.googlecode.com/svn/trunk/twtr_jp/tweet_20110220.zip) つぶやきパックのダウンロード
  * [シナリオとスクリプトの閲覧](http://code.google.com/p/cowares-wpost/source/browse/trunk/twtr_jp/)

# ページショット #

## !User-Agent!Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0) ##

  * PC ではリダイレクトで飛ばされる。 IE をリダイレクト禁止にしてあると、拒否エラーとなる。
```
GET URL: http://twtr.jp/
Error -2147024891 アクセスが拒否されました。
 for http://twtr.jp/
```

## !User-Agent!Googlebot-Mobile ##

  * 検索エンジンを特別扱いするサイトは多いので試してみたが、これも拒否。
```
SetRequestHeaders: User-Agent = Googlebot-Mobile
Action: submit, 
GET URL: http://twtr.jp/
Error -2147024891 アクセスが拒否されました。
 for http://twtr.jp/
```

## !User-Agent!`DoCoMo/1.0/` ##

  * ドコモ偽装は通った。
  * i mode と認識しているが、 utf-8 で返してくるあたり、中途半端な対応の気もする。
```
SetRequestHeaders: User-Agent = DoCoMo/1.0/
200 OK http://twtr.jp/
Date: Sat, 19 Feb 2011 12:06:33 GMT
Server: hi
Status: 200 OK
ETag: "6d2cb1cae01f27eb094f5076b10a0a2c"-gzip
X-Runtime: 30
Content-Type: application/xhtml+xml; charset=UTF-8
Cache-Control: private, max-age=0, must-revalidate, max-age=300
Set-Cookie: _komadori_session=BAh7BzoQX2NzcmZfdG9rZW4iMXcrSlNwN3M2RWgxNDdYYVdCTDJFT0tVMmVtOFpBY2dmVXFUWlZhV2tvNDA9Og9zZXNzaW9uX2lkIiU4YmY2MmUyYmQ2NjZjMTlhZjI1NWM1NDI1MGM5MTc3MQ%3D%3D--1a4ed49c0e0e200109f812afd2bec5a2a00740a2; path=/; expires=Sat, 26-Feb-2011 12:06:33 GMT; HttpOnly
Expires: Sat, 19 Feb 2011 12:11:33 GMT
Vary: Accept-Encoding
Content-Encoding: gzip
Connection: close
Transfer-Encoding: chunked
```

```
<!DOCTYPE html PUBLIC "-//i-mode group (ja)//DTD XHTML i-XHTML(Locale/Ver.=ja/2.3) 1.0//EN" "i-xhtml_4ja_10.dtd">
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ﾂｲｯﾀｰ</title>
```

## !User-Agent!`SoftBank/2.0/` ##

  * ソフトバンク偽装も通った。
  * utf-8 xhtml-basic で返している。
```
SetRequestHeaders: User-Agent = SoftBank/2.0/
200 OK http://twtr.jp/
Date: Sat, 19 Feb 2011 12:06:34 GMT
Server: hi
Status: 200 OK
ETag: "9aacaa87b6319b3dc1063f35d4f0d00a"-gzip
X-Runtime: 12
Content-Type: application/xhtml+xml; charset=UTF-8
Cache-Control: private, max-age=0, must-revalidate, max-age=300
Set-Cookie: _komadori_session=BAh7BzoQX2NzcmZfdG9rZW4iMUdXSHA5WisrTDRFVm1LSFJuNUVZLzBsUXhvc3VvSkhxcUhlSGx0VWMrNmc9Og9zZXNzaW9uX2lkIiU4YmY2ZGVmMzA5YjIyMTQ3YTU0YzQ1ZTRjZjgzMDU5YQ%3D%3D--16972c38c04460512b89958aa82107128eb0d620; path=/; expires=Sat, 26-Feb-2011 12:06:34 GMT; HttpOnly
Expires: Sat, 19 Feb 2011 12:11:34 GMT
Vary: Accept-Encoding
Content-Encoding: gzip
Connection: close
Transfer-Encoding: chunked
```

```
<!DOCTYPE html PUBLIC "-//J-PHONE//DTD XHTML Basic 1.0 Plus//EN" "xhtml-basic10-plus.dtd">
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ﾂｲｯﾀｰ</title>
```
  * css 部分が半分ぐらい占めている。 body だけ取り出せば次のように単純。
```
<body style="background: #C0DDEE url(http://jp.twimg.com/p/images/dedca552938cf5c27a3b29c66abe1ed91f93cc8c.png?s=bg-clouds.png) repeat-x;"><a name="top" id="top"></a>
<div id="header">
<img alt="ﾂｲｯﾀｰ" height="30px" src="http://jp.twimg.com/p/images/4505734271eacffbbbb55d951f536871e5f29141.png?s=twitter.png" width="160px" />

</div>
<div>
今の出来事を知ろう<br />
<form action="http://twtr.jp/search" method="get"><input id="q" name="q" size="14" type="text" /><input type="submit" value="&#xe114;検索" />
<div><a href="http://twtr.jp/trend">流行のﾄﾋﾟｯｸ</a></div>
</form></div>

<div class="box">
<div><img alt="" src="http://jp.twimg.com/p/images/053749890de58b44209896a51c972bf9c74b1655.png?s=hr-clouds-top.png" /></div>

<div class="blue">ﾛｸﾞｲﾝ　　&#xe523;</div>
<form action="http://twtr.jp/login" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="GWHp9Z++L4EVmKHRn5EY/0lQxosuoJHqqHeHltUc+6g=" /></div>
ﾕｰｻﾞｰ名 <input class="screen-name" id="login" name="login" size="14" type="text" mode="alphabet" /><br />
ﾊﾟｽﾜｰﾄﾞ <input class="password" id="password" name="password" size="14" type="text" mode="alphabet" /><br />
<div class="center">
<input name="commit" type="submit" value="ﾛｸﾞｲﾝ" /><br />
<span class="small"><a href="http://twtr.jp/login/forgot_password">ﾊﾟｽﾜｰﾄﾞを忘れた?</a></span>
</div>
</form>
<div><img alt="" src="http://jp.twimg.com/p/images/d620a55ff277203258e807ecc47d5241680a3358.png?s=hr-clouds-bottom.png" /></div>
</div>


<div class="center">
&#xe10f;ﾂｲｯﾀｰに登録しよう<br />
<span class="light-green">&#xe523;<a href="http://twtr.jp/signup">いますぐ登録(無料)</a>&#xe337;</span>
</div>


<br />
<div class="center">
<span class="white">　<span class="blue">ﾂｲｯﾀｰって何?</span>　</span><br />
<span class="white"><a href="http://twinavi.jp/">詳しくはこちら</a>→</span>
</div>



<br />
<div id="footer">
<a href="http://twtr.jp/page/help">ﾍﾙﾌﾟ</a>
<br />
<a href="http://twtr.jp/tos">利用規約</a> - <a href="http://twtr.jp/privacy">ﾌﾟﾗｲﾊﾞｼｰﾎﾟﾘｼｰ</a><br />
&#xe24e; 2010 Twitter, Inc.<br />
</div>
</body>
```

### ログインフォーム ###

  * ソフトバンク偽装が無難な方法とみた。
  * 先のページから、フォームだけ取り出す。
```
<form action="http://twtr.jp/search" method="get">
<input id="q" name="q" size="14" type="text" />
<input type="submit" value="&#xe114;検索" />
<a href="http://twtr.jp/trend">流行のﾄﾋﾟｯｸ</a>
</form>

<form action="http://twtr.jp/login" method="post">
<input name="authenticity_token" type="hidden" value="GWHp9Z++L4EVmKHRn5EY/0lQxosuoJHqqHeHltUc+6g=" /> ﾕｰｻﾞｰ名 <input class="screen-name" id="login" name="login" size="14" type="text" mode="alphabet" /> ﾊﾟｽﾜｰﾄﾞ <input class="password" id="password" name="password" size="14" type="text" mode="alphabet" />
<input name="commit" type="submit" value="ﾛｸﾞｲﾝ" />
<a href="http://twtr.jp/login/forgot_password">ﾊﾟｽﾜｰﾄﾞを忘れた?</a>
</form>
```
  * ２つ目にログインフォームがある。ログインを試してみよう。
    * 非SSLだ。 SSL サーバーは用意されていないようだ。
    * authenticity\_token があるので、それを再送してやらないといけない。
```
!header
!User-Agent!SoftBank/2.0/

!request
!    url  !http://twtr.jp/

!action
!submit!
!run!login_twtr_jp.vbs

!request
!    url  !http://twtr.jp/login
! method  !POST

!input
!data!

!data
!login!ログインID
!password!パスワード

!action
!submit!
```
  * この結果は失敗。
```
SetEnv: data, authenticity_token, GWHp9Z++L4EVmKHRn5EY/0lQxosuoJHqqHeHltUc+6g=
SetEnv: data, commit, ﾛｸﾞｲﾝ
SetRequestHeaders: Referer = http://twtr.jp/
SetRequestHeaders: User-Agent = SoftBank/2.0/
DATA: login=xxx&password=xxx&authenticity_token=GWHp9Z%2B%2BL4EVmKHRn5EY%2F0lQxosuoJHqqHeHltUc%2B6g%3D&commit=%EF%BE%9B%EF%BD%B8%EF%BE%9E%EF%BD%B2%EF%BE%9D
422 Unprocessable Entity http://twtr.jp/login
```
    * Status 422 は authenticity\_token での認証失敗らしい。
    * おっと。クッキーを許可していなかった。
  * クッキー許可で ok
```
Status: 200 OK
```
  * これがメニューだ。
```
<div class="light-blue">
  <div class="title" style="border-bottom: 2px solid #337799;">
    &#xe225;<a href="#menu" accesskey="0"></a>
    ﾒﾆｭｰ
  </div>
  &#xe21c; &#xe036; <a href="http://twtr.jp/home" accesskey="1">ﾎｰﾑ</a><br />
  &#xe21d; ＠ <a href="http://twtr.jp/replies" accesskey="2">@ユーザーＩＤ関連</a><br />
  &#xe21e; <span class="star">★</span>  <a href="http://twtr.jp/user/ユーザーＩＤ/favorite" accesskey="3">お気に入り</a><br />
  &#xe21f; &#xe301; <a href="http://twtr.jp/inbox" accesskey="4">ﾀﾞｲﾚｸﾄﾒｯｾｰｼﾞ</a><br />
  <br />
  &#xe523; <a href="http://twtr.jp/status/create">ﾂｲｰﾄする</a> - <a href="http://twtr.jp/setting">各種設定</a><br />
  <span class="gray">┗</span> <a href="http://twtr.jp/setting/email_tweet">ﾒｰﾙでﾂｲｰﾄ</a> &#xe008;<br />
  &#xe114; <a href="http://twtr.jp/search">検索</a> - <a href="http://twtr.jp/trend">流行のﾄﾋﾟｯｸ</a><br />
  &#xe148; <a href="http://twtr.jp/find">友達をさがす</a><br />
  <span class="gray">┣</span> <a href="http://twtr.jp/follow/me">ﾌｫﾛｰﾐｰ!</a><br />
  <span class="gray">┗</span> <a href="http://twtr.jp/who_to_follow/interests">おすすめﾕｰｻﾞｰ</a><br />
</div>



<br />
<div id="footer">
<a href="http://twtr.jp/logout">ﾛｸﾞｱｳﾄ</a> - <a href="http://twtr.jp/home">ﾄｯﾌﾟﾍﾟｰｼﾞ</a>
```

## ツイート ##

  * `http://twtr.jp/status/create`
    * ログインできてたら、こいつでツイートフォームが出る。
```
<form action="http://twtr.jp/status/create" method="post">
<input name="authenticity_token" type="hidden" value="6LqC/hssNbXpDsY6rvzq8I84ElsNQhQuSFMfRyBjzDE=" />いまどうしてる? <textarea id="text" name="text" rows="6">
</textarea>
<input name="commit" type="submit" value="ﾂｲｰﾄ" />
</form>
```
  * これでツイートできた。
```
!output
!text!

!header
!User-Agent!SoftBank/2.0/

!request
!    url  !http://twtr.jp/status/create

!action
!submit!
!run!create_twtr_jp.vbs

!request
! method  !POST

!input
!data!

!data
!text!ついーとなう

!action
!submit!

```

# スクリプト #

## login\_twtr\_jp.vbs ##

```
' login_twtr_jp
' analyse http://twtr.jp/login
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x, h
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    Set x = RegLoginForm.Execute(Text)
    If x.Count = 1 Then
        'outSt.WriteLine x(0).Value
        Text = x(0).Value
        Set x = RegName.Execute(Text)
        For Each h in x
            'outSt.WriteLine h.SubMatches(0) & " " & DecUrlString(h.SubMatches(1))
            outSt.WriteLine h.SubMatches(0) & " " & h.SubMatches(1)
        Next
    End If
    Set x = Nothing
End Sub

Function RegLoginForm()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<form [^>]*login.*?</form>"
    
    Set RegLoginForm = R
End Function

Function RegName()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<[^>]* name=""([^""]*)""[^>]*value=""([^""]*)""[^>]*>"
    
    Set RegName = R
End Function

Function DecUrlString(Text)
    Dim out, Ps, i
    
    If Text = "" Then Exit Function
    
    Ps = Split(Replace(Text, "+", " "), "%")
    ' Ps(0)   : all raw characters
    ' Ps(1) - : the first pair bytes make a byte char, the left are raw characters
    
    out = Ps(0)
    For i = 1 To UBound(Ps)
        out = out & Chr(CByte("&H" & Left(Ps(i), 2)))
        If Len(Ps(i)) > 2 Then
            out = out & Mid(Ps(i), 3)
        End If
    Next
    
    DecUrlString = out
End Function
```

## create\_twtr\_jp.vbs ##

```
' create_twtr_jp
' analyse http://twtr.jp/status/create
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x, h
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    Set x = RegForm.Execute(Text)
    If x.Count = 1 Then
        'outSt.WriteLine x(0).Value
        Text = x(0).Value
        Set x = RegName.Execute(Text)
        For Each h in x
            'outSt.WriteLine h.SubMatches(0) & " " & DecUrlString(h.SubMatches(1))
            outSt.WriteLine h.SubMatches(0) & " " & h.SubMatches(1)
        Next
    End If
    Set x = Nothing
End Sub

Function RegForm()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<form .*?</form>"
    
    Set RegForm = R
End Function

Function RegName()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<[^>]* name=""([^""]*)""[^>]*value=""([^""]*)""[^>]*>"
    
    Set RegName = R
End Function

Function DecUrlString(Text)
    Dim out, Ps, i
    
    If Text = "" Then Exit Function
    
    Ps = Split(Replace(Text, "+", " "), "%")
    ' Ps(0)   : all raw characters
    ' Ps(1) - : the first pair bytes make a byte char, the left are raw characters
    
    out = Ps(0)
    For i = 1 To UBound(Ps)
        out = out & Chr(CByte("&H" & Left(Ps(i), 2)))
        If Len(Ps(i)) > 2 Then
            out = out & Mid(Ps(i), 3)
        End If
    Next
    
    DecUrlString = out
End Function
```