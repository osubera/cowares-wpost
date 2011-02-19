' href_search_bing_com.vbs
' wpost page analyser for http://www.bing.com/search
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url)
    Dim Text, x
    Dim LinkUrl, href
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    Set x =RegH1H4.Execute(Text)
    If x.Count = 1 Then
        'outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        Text = x(0).Value
        
        Set x = RegHREF_SRC.Execute(Text)
        For Each href In x
            LinkUrl = href.SubMatches(0)
            If Left(LinkUrl, 7) = "http://" Then
                ' reject internal links this time
                If InStr(LinkUrl, "?") = 0 Then
                    ' needs only simple urls
                    outSt.WriteLine LinkUrl
                ElseIf InStr(LinkUrl, "cache.aspx?") > 0 Then
                    ' but needs this
                    'outSt.WriteLine LinkUrl
                End If
            End If
        Next
    End If
    Set x = Nothing
End Sub

Function RegBlank()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "\s"
    
    Set RegBlank = R
End Function

Function RegBODY()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<body .*</body>"
    
    Set RegBODY = R
End Function

Function RegSCRIPT_STYLE()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<script .*?</script>|<style .*?</style>"
    
    Set RegSCRIPT_STYLE = R
End Function

Function RegHREF_SRC()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = " href=""([^""]+)""| src=""([^""]+)"""
    
    Set RegHREF_SRC = R
End Function

Function RegBingFooter()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "go to bing in.*"
    
    Set RegBingFooter = R
End Function

Function RegH1H4()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "</h1>(.*)<h4>"
    
    Set RegH1H4 = R
End Function

