' search_www_google_co_jp
' wpost page analyser for http://www.google.co.jp/search
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
    Dim Text, x
    Dim p, v, LinkUrl
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    If LCase(outFo) = "text" Then
        outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
    End If
    
    Set x =RegP.Execute(Text)
    For Each p In x
        Text = p.SubMatches(0)
        If Left(Text, 2) = "<a" Then
            ' reject related searches
            
            LinkUrl = ""
            Set x = RegA_HREF.Execute(Text)
            If x.Count = 1 Then
                Set x = RegUrl.Execute(x(0).SubMatches(0))
                If x.Count = 1 Then
                    LinkUrl = Replace(x(0).SubMatches(0), "%25", "%")
                End If
            End If
            
            If LCase(outFo) = "text" Then
                v = Split(Text, "<font", -1, vbTextCompare)
                If UBound(v) >= 1 Then
                    Text = "<font" & v(1)
                    Text = Replace(Text, "<br>", vbCrLf, 1, -1, vbTextCompare)
                    Text = v(0) & vbCrLf & Text
                    Text =RegNoTags.Replace(Text, "")
                    Text =RegNoSpecialChars.Replace(Text, "")
                Else
                    Text = vbCrLf
                End If
                outSt.WriteLine LinkUrl
                outSt.WriteLine Text
            Else
                outSt.WriteLine LinkUrl
            End If
        End If
    Next
    Set x = Nothing
End Sub

Function RegP()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<p>(.*?)</p>"
    
    Set RegP = R
End Function

Function RegRemoveAfterTable()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<table.*"
    
    Set RegRemoveAfterTable = R
End Function

Function RegLessTags()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "</?(table|tr|td|div|span|br|font|b)[^>]*>"
    
    Set RegLessTags = R
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
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "q=(.*?)&amp;"
    
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

