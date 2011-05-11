' nav_image_search_yahoo_co_jp
' wpost page analyser for http://image.search.yahoo.co.jp/search
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text, x
    Dim KeyValue
    
    Text = inSt.ReadAll
    
    Set x =RegNav2.Execute(Text)
    If x.Count >= 1 Then
        Set x = RegParams.Execute(x(0).SubMatches(0))
        If x.Count >= 1 Then
            Set x = RegAmp.Execute(x(0).SubMatches(0))
            For Each KeyValue In x
                outSt.WriteLine KeyValue.SubMatches(0) & " " & KeyValue.SubMatches(1)
            Next
        End If
    End If
    Set x = Nothing
End Sub

Function RegNav2()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = True
    R.Pattern = "<a title=""2""[^>]* href=""([^""]*)"""
    
    Set RegNav2 = R
End Function

Function RegParams()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "\?p=[^&]*(&.*)"
    
    Set RegParams = R
End Function

Function RegAmp()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "&amp;([^&=]+)=([^&=]*)"
    
    Set RegAmp = R
End Function
