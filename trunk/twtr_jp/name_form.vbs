' name_form
' analyse name attributes in form
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out
'   /form:1
'   /form:login

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("form")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, F)
    Dim Text, x, h, Fnum, Name, Value, v, RegV
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    If Not IsEmpty(F) And IsNumeric(F) Then
        Fnum = CLng(F)
        Set x = RegForm("").Execute(Text)
    Else
        Fnum = 1
        Set x = RegForm(F).Execute(Text)
    End If
    
    If x.Count >= Fnum Then
        'outSt.WriteLine x(0).Value
        Text = x(Fnum - 1).Value
        Set x = RegName.Execute(Text)
        Set RegV = RegValue
        For Each h in x
            Name = h.SubMatches(0)
            Set v = RegV.Execute(h.Value)
            If v.Count = 1 Then
                Value = v(0).SubMatches(0)
            Else
                Value = ""
            End If
            'outSt.WriteLine Name & " " & DecUrlString(Value)
            outSt.WriteLine Name & " " & Value
        Next
        Set RegV = Nothing
    End If
    Set x = Nothing
End Sub

Function RegForm(Attributes)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<form [^>]*" & Attributes & ".*?</form>"
    
    Set RegForm = R
End Function

Function RegName()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<[^>]* name=""([^""]*)""[^>]*>"
    
    Set RegName = R
End Function

Function RegValue()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "value=""([^""]*)"""
    
    Set RegValue = R
End Function

Function DecUrlString(Text)
    Dim out, Ps, i
    
    If Text = "" Then Exit Function
    
    Ps = Split(Replace(Text, "+", " "), "%")
    ' Ps(0)   : all raw characters
    ' Ps(1) - : the first pair bytes make a byte char, the left are raw characters
    
    out = Ps(0)
    For i = 1 To UBound(Ps)
        out = out & Chr(CByte("&H" & Left(Ps(i), 2)))
        If Len(Ps(i)) > 2 Then
            out = out & Mid(Ps(i), 3)
        End If
    Next
    
    DecUrlString = out
End Function
