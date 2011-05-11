' login_verify_yahoo_co_jp
' wpost page analyser for yahoo login verify
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text
    Const SearchMe = "パスワードの再確認"
    
    Text = inSt.ReadAll
    If InStr(1, Text, SearchMe, vbTextCompare) > 0 Then
        outSt.WriteLine SearchMe
    End If
End Sub
