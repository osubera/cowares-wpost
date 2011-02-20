' search_yahoo_co_jp
' wpost page analyser for http://search.yahoo.co.jp/search
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out
' /o:OUTPUT_FORMAT
'   text = summary text
'   otherwise url list

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url"), Args.Named("o")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url, outFo)
    Dim Text, x, y
    Dim ol, li, v, LinkUrl
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    If LCase(outFo) = "text" Then
        outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
    End If
    
    Set y = RegOL.Execute(Text)
    'If y.Count = 0 Then Set y = RegUL.Execute(Text)
    
    For Each ol In y
        Set x =RegLI.Execute(ol.SubMatches(0))
        For Each li In x
            Text = li.SubMatches(0)
            LinkUrl = ""
            Set x = RegA_HREF.Execute(Text)
            If x.Count = 1 Then
                Set x = RegUrl.Execute(x(0).SubMatches(0))
                If x.Count = 1 Then
                    LinkUrl = DecUrlString(x(0).SubMatches(0))
                End If
            End If
            
            If LCase(outFo) = "text" Then
                v = Split(Text, "<em", 2, vbTextCompare)
                Text = v(0)
                Text = Replace(Text, "<div>", vbCrLf, 1, -1, vbTextCompare)
                Text =RegNoTags.Replace(Text, "")
                Text =RegNoSpecialChars.Replace(Text, "")
                Text = Text & vbCrLf
                outSt.WriteLine LinkUrl
                outSt.WriteLine Text
            Else
                outSt.WriteLine LinkUrl
            End If
        Next
    Next
    Set x = Nothing
    Set y = Nothing
End Sub

Function RegUL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<ul>(.*?)</ul>"
    
    Set RegUL = R
End Function

Function RegOL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<ol>(.*?)</ol>"
    
    Set RegOL = R
End Function

Function RegLI()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<li>(.*?)</li>"
    
    Set RegLI = R
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

Function RegA_HREF()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<a href=""([^""]*)"""
    
    Set RegA_HREF = R
End Function

Function RegUrl()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "/\*\*(.*)"
    
    Set RegUrl = R
End Function

Function RegNoSpecialChars()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "&[0-9A-Za-z#]*;"
    
    Set RegNoSpecialChars = R
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
