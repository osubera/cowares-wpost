' plain.vbs
' wpost page analyser for plainize html
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out
' /r:6 to select the maximum rules to be applied

'On Error Resume Next
Set Args = WScript.Arguments
Main WScript.StdIn, WScript.StdOut, Args.Named("url"), Args.Named("r")
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt, Url, ByVal MaxRule)
    Dim Text, Keep
    Dim UrlBase, UrlDomain, Title, SafeKey
    
    MaxRule = CLng(MaxRule)
    If MaxRule <= 0 Then MaxRule = 7
    Set Keep = CreateObject("Scripting.Dictionary")
    
    Text = inSt.ReadAll
    
    If MaxRule >= 1 Then Rule1 Text, Keep, Url, UrlBase, UrlDomain, Title, SafeKey
    If MaxRule >= 2 Then Rule2 Text, Keep, SafeKey
    If MaxRule >= 3 Then Rule3 Text, Keep, SafeKey
    If MaxRule >= 4 Then Rule4 Text
    If MaxRule >= 5 Then Rule5 Text, UrlBase, UrlDomain
    If MaxRule >= 6 Then Rule6 Text
    If MaxRule >= 7 Then Rule7 Text, Keep, SafeKey
    
    Keep.RemoveAll
    Set Keep = Nothing
    
    outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
    outSt.WriteLine Url
    outSt.WriteLine Title
    outSt.WriteLine Text
End Sub
    
' follow the code 2011/2/24 on plain.wiki

Sub Rule1(ByRef Text, Keep, Url, ByRef UrlBase, ByRef UrlDomain, ByRef Title, ByRef SafeKey)
    Dim x, Rblank
    Dim RootSlash
    
    Set Rblank = RegBlank
    
    ' adjust line-feeds
    Text = Replace(Replace(Text, vbCrLf, vbCr), vbLf, vbCr)
    
    ' base
    Set x = RegTag("base").Execute(Text)
    If x.Count = 0 Then
        UrlBase = Url
    Else
        Set x =RegAttrib("href").Execute(x(0).SubMatches(1))
        If x.Count = 0 Then
            UrlBase = Url
        Else
            UrlBase = x(0).SubMatches(0)
        End If
    End If
    If Right(UrlBase, 1) <> "/" Then UrlBase = Left(UrlBase, InStrRev(UrlBase, "/"))
    RootSlash = InStr(Len("http://") + 1, UrlBase, "/",vbBinaryCompare)
    If RootSlash = 0 Then
        UrlDomain = ""
    Else
        UrlDomain = Left(UrlBase, RootSlash - 1)
    End If
    
    ' title
    Set x = RegTag("title").Execute(Text)
    If x.Count = 0 Then
        Title = ""
    Else
        Title = Rblank.Replace(x(0).SubMatches(3), " ")
    End If
    
    ' safekey
    SafeKey = ""
    Do While InStr(1, Text, SafeKey, vbBinaryCompare) > 0
        SafeKey = SafeKey & Mid(CStr(Rnd), 3)
    Loop
    
    Set x = Nothing
End Sub

Sub Rule2(ByRef Text, Keep, SafeKey)
    Dim x, R, Key, Tag
    
    For Each Tag In Array("script", "style")
        Set R = RegTag(Tag)
        Do
            Set x = R.Execute(Text)
            If x.Count = 0 Then Exit Do
            Key = "&" & Tag & SafeKey & Keep.Count & ";"
            Keep.Add Key, x(0).Value
            Text = Left(Text, x(0).FirstIndex) & vbCr & Key & vbCr & Mid(Text, x(0).FirstIndex + x(0).Length + 1)
        Loop
    Next
    
    Set x = Nothing
    Set R = Nothing
End Sub

Sub Rule3(ByRef Text, Keep, SafeKey)
    Dim x, R, Key, Tag
    
    For Each Tag In Array("comment", "pre", "form", "head")
        If Tag = "comment" Then
            Set R = RegCOMMENT
        Else
            Set R = RegTag(Tag)
        End If
        Do
            Set x = R.Execute(Text)
            If x.Count = 0 Then Exit Do
            Key = "&" & Tag & SafeKey & Keep.Count & ";"
            Keep.Add Key, x(0).Value
            Text = Left(Text, x(0).FirstIndex) & vbCr & Key & vbCr & Mid(Text, x(0).FirstIndex + x(0).Length + 1)
        Loop
    Next
    
    Set x = Nothing
    Set R = Nothing
End Sub

Sub Rule4(ByRef Text)
    ' blanks
    Text = RegBlank.Replace(Text, " ")
    
    ' clean tag blank
    Text = Replace(Text, "< ", "<", 1, -1, vbBinaryCompare)
    Text = Replace(Text, "</ ", "</", 1, -1, vbBinaryCompare)
    Text = Replace(Text, " >", ">", 1, -1, vbBinaryCompare)
End Sub

Sub Rule5(ByRef Text, UrlBase, UrlDomain)
    Dim x, R, Key, Tag, y, TagAttrib
    Dim Rattr, Ralt, Rhref, Rsrc, Description
    Dim LeftText, RightText, LinkUrl, FoundTag
    
    Set Rhref = RegAttrib("href")
    Set Rsrc = RegAttrib("src")
    Set Ralt = RegAttrib("alt")
    For Each Tag In Array("a", "img|embed|frame|iframe")
        Set R = RegTagStart(Tag)
        If Tag = "a" Then
            Set Rattr = Rhref
        Else
            Set Rattr = Rsrc
        End If
        
        Do
            Set x = R.Execute(Text)
            If x.Count = 0 Then Exit Do
            
            LeftText = Left(Text, x(0).FirstIndex)
            RightText = Mid(Text, x(0).FirstIndex + x(0).Length + 1)
            FoundTag = LCase(x(0).SubMatches(0))
            TagAttrib = x(0).SubMatches(1)
            Set x =Rattr.Execute(TagAttrib)
            If x.Count = 0 Then Exit Do
            
            Select Case FoundTag
            Case "a"
                Description = ""
            Case "img"
                Set y = Ralt.Execute(TagAttrib)
                If y.Count = 0 Then
                    Description = "âÊ "
                Else
                    Description = y(0).SubMatches(1) & " "
                End If
            Case "embed"
                Description = "ìÆ "
            Case Else
                Description = "ë} "
            End Select
            LinkUrl = x(0).SubMatches(1)
            If Left(LinkUrl, 7) <> "http://" Then
                If Left(Href, 1) = "/" Then
                    LinkUrl = UrlDomain & LinkUrl
                Else
                    LinkUrl = UrlBase & LinkUrl
                End If
            End If
            Text = LeftText & vbCr & Description & LinkUrl & vbCr & RightText
        Loop
    Next
    
    ' remove attributes
    Text = RegTagRemoveAttr.Replace(Text, "<$1$4>")
    
    Set x = Nothing
    Set Rattr = Nothing
    Set Rhref = Nothing
    Set Rsrc = Nothing
    Set Ralt = Nothing
    Set R = Nothing
End Sub

Sub Rule6(ByRef Text)
    Dim i
    
    ' to single line-feed
    Text = RegTagG("br|div").Replace(Text, vbCr)
    
    ' to double line-feed
    Text = RegTagG("blockquote|p|dl|ol|ul|tr").Replace(Text, vbCr & vbCr)
    
    ' to ----
    Text = RegTagG("hr").Replace(Text, vbCr & "----" & vbCr)
    
    ' to list
    Text = RegTagGS("li|dt|dd|th|td").Replace(Text, vbCr & "- ")
    
    ' to header
    For i = 1 to 6
        Text = RegTagGS("h" & CStr(i)).Replace(Text, vbCr & vbCr & String(i, "*") & " ")
    Next
    Text = RegTagG("h[1-6]").Replace(Text, vbCr & vbCr)
    
    ' remove tags
    Text = RegNoTags.Replace(Text, "")
    
    ' remove unused escapes
    Text = RegEscaped("comment").Replace(Text, "")
    Text = RegEscaped("head").Replace(Text, "")
    
    ' adjust line-feeds
    Text = RegTooManyCr.Replace(Text, vbCr & vbCr)
    
    ' vbCr to vbCrLf
    Text = Replace(Text, vbCr, vbCrLf, 1, -1, vbBinaryCompare)
End Sub

Sub Rule7(ByRef Text, Keep, SafeKey)
    Dim x, R, Key, Tag, Escaped
    
    ' restore escaped blocks
    For Each Tag In Array("pre")
        Set R = RegEscaped(Tag & SafeKey)
        Do
            Set x = R.Execute(Text)
            If x.Count = 0 Then Exit Do
            Key = x(0).Value
            Escaped = Keep(Key)
            Escaped = Replace(Replace(Replace(Escaped, vbCrLf, vbCr), vbLf, vbCr), vbCr, vbCrLf)
            Text = Left(Text, x(0).FirstIndex) & Escaped & Mid(Text, x(0).FirstIndex + x(0).Length + 1)
        Loop
    Next
    
    ' special entities
    Text = Replace(Text, "&lt;", "<")
    Text = Replace(Text, "&gt;", ">")
    Text = Replace(Text, "&quot;", """")
    Text = Replace(Text, "&amp;", "&")
    
    Set x = Nothing
    Set R = Nothing
End Sub

Function RegTag(TagName)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<\s*(" & TagName & ")((\s+[^>]*)?)>(.*?)<\s*/\s*" & TagName & "\s*>"
    
    Set RegTag = R
End Function

Function RegTagStart(TagName)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<\s*(" & TagName & ")((\s+[^>]*)?)(/?)\s*>"
    
    Set RegTagStart = R
End Function

Function RegTagRemoveAttr()
    Set RegTagRemoveAttr = RegTagStart("[^\s/>]+")
    RegTagRemoveAttr.Global = True
    RegTagRemoveAttr.IgnoreCase = False
End Function

Function RegTagGS(TagName)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<\s*(" & TagName & ")\s*/?\s*>"
    
    Set RegTagGS = R
End Function

Function RegTagG(TagName)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<\s*/?\s*(" & TagName & ")\s*/?\s*>"
    
    Set RegTagG = R
End Function

Function RegAttrib(AttribName)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "(" & AttribName & ")\s*=\s*""([^""]+)"""
    
    Set RegAttrib = R
End Function

Function RegBlank()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "(\s|&nbsp;|Å@)+"
    
    Set RegBlank = R
End Function

Function RegCOMMENT()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "<!--.*?-->"
    
    Set RegCOMMENT = R
End Function

Function RegNoTags()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "<[^>]*>"
    
    Set RegNoTags = R
End Function

Function RegTooManyCr()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "(\s*\r\s*){2,}"
    
    Set RegTooManyCr = R
End Function

Function RegEscaped(Tag)
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = False
    R.Pattern = "&" & Tag & "[^;]*;"
    
    Set RegEscaped = R
End Function
