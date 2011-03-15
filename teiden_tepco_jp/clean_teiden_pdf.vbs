' clean_teiden_pdf
' wpost page analyser for teiden.pdf
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text
    
    Text =RegClean.Replace(inSt.ReadAll, vbCrLf)
    
    outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
    outSt.Write Text
End Sub

Function RegClean()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = True
    ' とりあえず、改ページ記号と、全角ブランク（主に行末）をいずれも改行に置き換えてみる。
    R.Pattern = "\x0C|　"
    
    Set RegClean = R
End Function
