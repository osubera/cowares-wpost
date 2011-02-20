' dictionary_goo_ne_jp
' wpost page analyser for http://dictionary.goo.ne.jp/freewordsearcher.html
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url)
    Dim Text, x
    Dim dl, Raddlf, Rnotag
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    Set x = RegRemoveRight.Execute(Text)
    If x.Count = 1 Then
        'outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        'outSt.WriteLine x(0).Value
        Set Raddlf = RegDT_DD
        Set Rnotag = RegNoTags
        Set x =RegDL.Execute(x(0).Value)
        For Each dl in x
            Text = dl.Value
            Text = Replace(Text, " <", "<", 1, -1, vbTextCompare)
            Text = Raddlf.Replace(Text, vbCrLf)
            Text = Rnotag.Replace(Text, "")
            outSt.WriteLine Text
        Next
        Set Raddlf = Nothing
        Set Rnotag = Nothing
    End If
    
    Set x = Nothing
End Sub

Function RegRemoveRight()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = ".*<!--RIGHTSIDE-->"
    
    Set RegRemoveRight = R
End Function

Function RegDL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<dl .*?</dl>"
    
    Set RegDL = R
End Function

Function RegDT_DD()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "</d[td]>"
    
    Set RegDT_DD = R
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
