' login_yahoo_co_jp
' analyse http://login.yahoo.co.jp/
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x, h
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    Set x = RegLoginForm.Execute(Text)
    If x.Count = 1 Then
        'outSt.WriteLine x(0).Value
        Text = x(0).Value
        Set x = RegHidden.Execute(Text)
        For Each h in x
            outSt.WriteLine h.SubMatches(0) & " " & h.SubMatches(1)
        Next
    End If
    Set x = Nothing
End Sub

Function RegLoginForm()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<form [^>]*name=""login_form"".*</form>"
    
    Set RegLoginForm = R
End Function

Function RegHidden()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<input[^>]*type=""hidden""[^>]*name=""([^""]*)""[^>]*value=""([^""]*)""[^>]*>"
    
    Set RegHidden = R
End Function
