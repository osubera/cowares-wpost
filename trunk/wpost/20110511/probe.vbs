' probe
' wpost page analyser for probe
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url)
    Dim Text, ErrSt
    
    Set ErrSt = New StringStream
    'ErrSt.WriteLine Url
    HeadCharAFile inSt, ErrSt, 256
    MsgBox ErrSt.Text, vbOkOnly, Url
    Set ErrSt = Nothing
End Sub

Sub HeadLineAFile(inSt, outSt, ByVal Counter)
    Do Until inSt.AtEndOfStream
        Counter = Counter - 1
        If Counter < 0 Then Exit Do
        outSt.WriteLine inSt.ReadLine
    Loop
End Sub

Sub HeadCharAFile(inSt, outSt, ByVal Counter)
    If inSt.AtEndOfStream Then Exit Sub
    outSt.Write inSt.Read(Counter) & vbCrLf
End Sub

Class StringStream
    Public Text
    
    Public Sub WriteLine(Data)
        Text = Text & Data & vbCrLf
    End Sub
    
    Public Sub Write(Data)
        Text = Text & Data
    End Sub
End Class
