' form
' wpost page analyser for cutting forms
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
    Dim f
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    Set x =RegFORM.Execute(Text)
    If x.Count = 1 Then
        outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        outSt.WriteLine Url & vbCrLf
    End If
    For each f in x
        Text = f.Value
        Text =RegLessTags.Replace(Text, "")
        Text =RegTooManyBlanks.Replace(Text, " ")
        Text =RegTagEachLine.Replace(Text, ">" & vbCrLf & "<")
        outSt.WriteLine Text & vbCrLf
    Next
    Set x = Nothing
End Sub

Function RegFORM()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<form.*?</form>"
    
    Set RegFORM = R
End Function

Function RegLessTags()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "</?(table|tr|td|div|span|br|font)[^>]*>"
    
    Set RegLessTags = R
End Function

Function RegTooManyBlanks()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "(\s|&nbsp;)+"
    
    Set RegTooManyBlanks = R
End Function

Function RegTagEachLine()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = ">\s*<"
    
    Set RegTagEachLine = R
End Function

