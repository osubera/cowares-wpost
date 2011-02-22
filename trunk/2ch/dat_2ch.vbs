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
