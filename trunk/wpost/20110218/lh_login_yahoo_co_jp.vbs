' lh_login_yahoo_co_jp
' wpost page analyser for http://lh.login.yahoo.co.jp
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x
    
    Text = Replace(inSt.ReadAll, vbLf, vbCr)
    ' work arround a bug that vb regexp fails in multi-lilne searching
    'Text = inSt.ReadAll
    
    Set x =RegTBODY.Execute(Text)
    If x.Count = 1 Then
        outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        Text = x(0).Value
        Text =RegTD_CLASS.Replace(Text, "$1 = ")
        Text =RegNoTags.Replace(Text, "")
        Text =RegTooManyBlanks.Replace(Text, vbCrLf)
        'Text = Replace(Text, vbCr, vbCrLf)
        outSt.WriteLine Text
    End If
    Set x = Nothing
End Sub

Function RegTBODY()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<tbody.*</tbody>"
    
    Set RegTBODY = R
End Function

Function RegTD_CLASS()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<td class=""([^""]*)"">"
    
    Set RegTD_CLASS = R
End Function

Function RegNoTags()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "<[^>]*>"
    
    Set RegNoTags = R
End Function

Function RegTooManyBlanks()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "\r+"
    
    Set RegTooManyBlanks = R
End Function

