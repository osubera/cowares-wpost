' grep
' wpost page analyser for searching string
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out
'  /e:REGEX_PATTERN
'  /f:STRING

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("e"), Args.Named("f"), 64
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, E, F, Length)
    Dim Text, x, m, Blank, At, LeftAt
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    'Text = inSt.ReadAll
    
    Set Blank = RegBlank
    If E <> "" Then
        Set x =RegPattern(".{0," & Length & "}" & E & ".{0," & Length & "}").Execute(Text)
        For Each m In X
            outSt.WriteLine Blank.Replace(m.Value, " ")
        Next
        Set m = Nothing
        Set x = Nothing
    ElseIf F <> "" Then
        At = 0
        Do
            At = InStr(At + 1, Text, F, vbTextCompare )
            If At = 0 Then Exit Do
            LeftAt = At - Length
            If LeftAt < 1 Then LeftAt = 1
            outSt.WriteLine Blank.Replace(Mid(Text, LeftAt, 2 * Length), " ")
        Loop
    End If
    Set Blank = Nothing
    
End Sub

Function RegBlank()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "\s+"
    
    Set RegBlank = R
End Function

Function RegPattern(Pattern)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = True
    R.Pattern = ".{0,64}" & Pattern & ".{0,64}"
    
    Set RegPattern = R
End Function

