' a
' wpost page analyser for a tags
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url)
    Dim Text, x, a, Rspaces, Rhref, y
    Dim Attributes, Href, BaseUrl, RootSlash
    
    outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result

    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    RootSlash = InStr(Len("http://") + 1, Url, "/",vbBinaryCompare)
    If RootSlash = 0 Then
        BaseUrl = ""
    Else
        BaseUrl = Left(Url, RootSlash - 1)
    End If
    
    Set Rspaces = RegBlank
    Set Rhref = RegHREF
    Set x =RegA.Execute(Text)
    For Each a In x
        Attributes = a.SubMatches(0)
        Text = a.SubMatches(1)
        'If InStr(1, Attributes, "href", vbTextCompare) > 0 Then
        Set y = RegHREF.Execute(Attributes)
        If y.Count = 1 Then
            Href = Rspaces.Replace(y(0).SubMatches(0), " ")
            If Left(Href, 1) = "/" Then Href = BaseUrl & Href
            Text = Rspaces.Replace(Text, " ")
            outSt.WriteLine Href
            outSt.WriteLine Text
        End If
    Next
    Set x = Nothing
    Set y = Nothing
    Set Rspaces = Nothing
    Set Rhref = Nothing
End Sub

Function RegBlank()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "(\s|&nbsp;|Å@)+"
    
    Set RegBlank = R
End Function

Function RegA()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<a\s([^>]*)>(.*?)</a>"
    
    Set RegA = R
End Function

Function RegHREF()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "href=""([^""]+)"""
    
    Set RegHREF = R
End Function

