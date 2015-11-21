

# 概要 #

  * ２ちゃんねるのdatを読む

# 資料 #

  * [monazilla/datの仕様](http://info.2ch.net/wiki/index.php?monazilla%2Fdat%A4%CE%BB%C5%CD%CD)

# シナリオ #

  * [シナリオとスクリプトの閲覧](http://code.google.com/p/cowares-wpost/source/browse/trunk/2ch/)

## ２ちゃんdat.txt ##

```
!wpost
!

!misc
!temp-folder!C:\tmp\2

!output
!text!

!header
!User-Agent!Mozilla/1.22 (compatible; MSIE 2.0d; Windows NT)

!request
!    url  !http://hibari.2ch.net/win/dat/1030610938.dat
!charset  !Shift_JIS

!action
!submit!
!run!dat_2ch.vbs

```

## dat\_2ch.vbs ##

```
' dat_2ch
' wpost page analyser for http://xxx.2ch.net/yyy/dat/zzz.dat
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url)
    Dim Counter, R, x
    Dim Text, Title, TitleAt
    
    R = Array(RegNoTags)
    Counter = 1
    Do Until inSt.AtEndOfStream
        Text = inSt.ReadLine
        If Counter = 1 Then
            TitleAt = InStrRev(Text, "<>")
            Title = Mid(Text, TitleAt + 2)
            Text = Left(Text, TitleAt + 1)
            outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
            outSt.WriteLine Url
            outSt.WriteLine Title
            outSt.WriteLine
        End If
        outSt.WriteLine Analyse(Text, Counter, R)
        Counter = Counter + 1
    Loop
    
    For Each x In R
        Set x = Nothing
    Next
End Sub
    
Function Analyse(ByVal Text, LineNo, R)
    Dim out, x
    Dim dl, Raddlf, Rnotag
    
    out = CStr(LineNo) & vbTab
    Text = Replace(Text, "<>", vbTab, 1, 2, vbBinaryCompare)
    Text = R(0).Replace(Text, vbCrLf)
    Text = Replace(Text, "&gt;", ">", 1, -1, vbBinaryCompare)
    out = out & Text
    
    Analyse = out
End Function

Function RegNoTags()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "</?[^>]*>"
    
    Set RegNoTags = R
End Function

```

## w\_2\_temp.txt ##

```
http://hibari.2ch.net/win/dat/1030610938.dat
☆☆　冴子先生をなすがままに！　☆☆

1	名無し~3.EXE		02/08/29 17:48 ID:qwo3mdxj
 冴子先生が見れるのは日本のOfficeだけ！！  
  http://www.microsoft.com/japan/site-XP/vol_02/wmv/wmv.asp  
    
  冴子先生マクロ  
  http://member.nifty.ne.jp/bear/offlady/offmacro.htm  
  http://www.zdnet.co.jp/internet/runner/0012/sp2/04a.html  
    
  ７種類あるオフィスアシスタントの中で、唯一の「人間キャラ」である冴子先生を、  
  ボタン1つで自在に操るためのプログラム。挨拶、顔アップ、変身、表示位置の  
  変更など、冴子先生の魅力的なアクションを存分に堪能できる（ただしエクセル  
  2000では使えない機能もある）。さらに、このプログラムは、自由なカスタマイズが  
  可能だ。例えば、冴子先生に「今日も一日お疲れさま、頑張ったわね」と慰めて  
  もらいたいとか、あるいは「もうひと頑張りよ、応援してるわ」と励ましてもらいたいとか、  
  そういう願望をかなえることもできてしまうのだ。全国の冴子先生ファンにはたまらない  
  一本と言えるだろう。  
    
  (;´Д`) ﾊｧﾊｧ 

2	名無しさん＠Ｅｍａｃｓ	sage	02/08/29 17:49 ID:NJMA7QvT
 わざわざこんなことでスレ立てるなよ。 
  

3	名無し~3.EXE	sage	02/08/29 17:50 ID:A2r3u2P4
 
>>2
 
 禿同 

...

599	名無し~3.EXE		2010/10/19(火) 13:00:57 ID:i3dsgHTj
  
  　∧＿∧ 　+ 
 　&lt;0゜｀∀´>　　　　　　　　 
 　（0゜∪ ∪ + 　　　　　 　　 
 　と＿_）__）　+ 

600	名無し~3.EXE	sage	2010/10/20(水) 07:24:08 ID:HQykehBz
 くそわろた 

601	名無し~3.EXE		2010/10/23(土) 15:35:33 ID:4sW5yt/5
 冴子2010復活!! 
 http://ameblo.jp/kazumi-no-blog/day-20101022.html 
 Twitterも復活しましたドキドキドキドキ 
 http://twtr.jp/user/saeko2010?guid=ON 

602	名無し~3.EXE	sage	2010/10/26(火) 23:45:10 ID:5mN0x7+5
 ロケみつとか電波少年のまねしてるな。絶対。。。 
  
 http://www.microsoft.com/japan/office/2010/saeko/default.mspx 

603	名無し~3.EXE		2010/10/29(金) 00:26:32 ID:uA+QjXND
 誰だよブログにここのリンク貼ったヤツ。 

604	名無し~3.EXE		2010/11/02(火) 22:10:20 ID:aEWUPqHF
 冴子2010 
 ttps://twitter.com/saeko2010 
 ttp://ameblo.jp/kazumi-no-blog/ 
 ttp://beautycity.jp/kazumi-yamamoto 
 マイクロまいこ 
 ttps://twitter.com/micromaiko 
 ttp://ameblo.jp/asuka1206/ 

```

  * `&lt;` とか、対応してないので素で出ている。