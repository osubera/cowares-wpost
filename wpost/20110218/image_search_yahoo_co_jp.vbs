' image_search_yahoo_co_jp
' analyse the result of http://image.search.yahoo.co.jp/search
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x
    Dim Li, LiArray
    Dim R, R2
    
    Text = inSt.ReadAll
    Set x =RegOL.Execute(Text)
    If x.Count = 1 Then
        LiArray = Split(RegCrLf.Replace(x(0).SubMatches(0), " "), "</li>")
        Set R = RegLI
        Set R2 = RegLIREV
        For Each Li in LiArray
            Set x = R.Execute(Li)
            If x.Count = 1 Then
                Text = x(0).SubMatches(0)
                outSt.WriteLine Text    ' thumbnail cached in yahoo server
                'outSt.WriteLine Split(Text, ":", 4)(3)    ' direct request to the original
            End If
            Set x = R2.Execute(Li)
            If x.Count = 1 Then
                Text = x(0).SubMatches(0)
                outSt.WriteLine DecUrlString(Text)    ' direct request to the original
            End If
        Next
        Set R = Nothing
        Set R2 = Nothing
    End If
    Set x = Nothing
End Sub

Function RegCrLf()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "[\r\n\t]"
    
    Set RegCrLf = R
End Function

Function RegOL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "id=""gridlist"">(.*)</ol>"
    
    Set RegOL = R
End Function

Function RegLI()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<img [^>]*src=""([^""]*)"""
    
    Set RegLI = R
End Function

Function RegLIREV()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "rev=""http[^*]*\*-([^,]*),"
    
    Set RegLIREV = R
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
