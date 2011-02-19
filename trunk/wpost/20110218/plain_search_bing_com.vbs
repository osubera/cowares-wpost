' plain_search_bing_com.vbs
' wpost page analyser for http://www.bing.com/search
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    Set x =RegBODY.Execute(Text)
    If x.Count = 1 Then
        outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        Text = x(0).Value
        Text =RegSCRIPT_STYLE.Replace(Text, "")
        Text =RegBlank.Replace(Text, " ")
        Text = Replace(Text, "</a></li>", vbCrLf, 1, -1, vbTextCompare)
        Text = Replace(Text, "</li>", vbCrLf, 1, -1, vbTextCompare)
        Text = Replace(Text, "</a>", vbCrLf, 1, -1, vbTextCompare)
        Text =RegNoTags.Replace(Text, "")
        outSt.WriteLine Text
    End If
    Set x = Nothing
End Sub

Function RegBlank()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "\s"
    
    Set RegBlank = R
End Function

Function RegBODY()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<body .*</body>"
    
    Set RegBODY = R
End Function

Function RegSCRIPT_STYLE()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<script .*?</script>|<style .*?</style>"
    
    Set RegSCRIPT_STYLE = R
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

