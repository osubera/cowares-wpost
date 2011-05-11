' id_yahoo_co_jp
' analyse http://id.yahoo.co.jp/
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x
    
    Text = inSt.ReadAll
    Set x =RegKonichiwa.Execute(Text)
    If x.Count = 1 Then
        outSt.WriteLine x(0).SubMatches(0)
    End If
    Set x = Nothing
End Sub

Function RegKonichiwa()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "Ç±ÇÒÇ…ÇøÇÕÅA<strong>([^<]+)</strong>Ç≥ÇÒ"
    
    Set RegKonichiwa = R
End Function
