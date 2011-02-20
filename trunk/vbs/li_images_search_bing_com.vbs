' li_images_search_bing_com.vbs
' wpost page analyser for http://www.bing.com/images/search
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
    Dim CHECK
    Dim CacheUrl, OrgUrl, img, meta
    
    Text = Replace(inSt.ReadAll, vbLf, " ")
    ' work arround a bug that vb regexp fails in multi-lilne searching
    
    Set x =RegResults.Execute(Text)
    If x.Count = 1 Then
        'outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
        Text = x(0).SubMatches(0)
        
        CHECK = 0
        Select Case CHECK
        
        Case 1
            outSt.WriteLine Text
            
        Case 2
            Set x = RegIMG.Execute(Text)
            
            If x.Count > 0 Then
                outSt.WriteLine x(0).Value
            End If
            
        Case 3
            Set x = RegIMG.Execute(Text)
            
            If x.Count > 0 Then
                Set x = RegSRC.Execute(x(0).Value)
                If x.Count > 0 Then
                    CacheUrl = x(0).SubMatches(0)
                    outSt.WriteLine CacheUrl
                    Set x = RegURL.Execute(CacheUrl)
                    If x.Count > 0 Then
                        OrgUrl = DecUrlString(x(0).SubMatches(0))
                        outSt.WriteLine OrgUrl
                    End If
                End If
            End If
            
        Case 4
            Set x = RegMETADATA.Execute(x(0).Value)
            
            If x.Count > 0 Then
                outSt.WriteLine x(0).SubMatches(0)
            End If
            
        Case 5
            Set x = RegMETADATA.Execute(x(0).Value)
            
            If x.Count > 0 Then
                Set x = RegIMGURL.Execute(x(0).SubMatches(0))
                If x.Count > 0 Then
                    OrgUrl = x(0).SubMatches(0)
                    outSt.WriteLine OrgUrl
                End If
            End If
            
        Case 6
            Set x = RegMETADATA.Execute(Text)
            
            For Each meta In x
                Set x = RegIMGURL.Execute(meta.SubMatches(0))
                If x.Count > 0 Then
                    OrgUrl = x(0).SubMatches(0)
                    outSt.WriteLine OrgUrl    ' print an original url
                End If
            Next
            
        Case Else
            Set x = RegIMG.Execute(Text)
            
            For Each img In x
                Set x = RegSRC.Execute(img.Value)
                If x.Count > 0 Then
                    CacheUrl = x(0).SubMatches(0)
                    outSt.WriteLine CacheUrl    ' print a cache url
                    
                    ' cache url contains an original url
                    Set x = RegURL.Execute(CacheUrl)
                    If x.Count > 0 Then
                        OrgUrl = DecUrlString(x(0).SubMatches(0))
                        outSt.WriteLine OrgUrl    ' print an original url
                    Else
                    End If
                End If
            Next
            
        End Select
        
    End If
    Set x = Nothing
End Sub

Function RegIMGURL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = ",imgurl:&quot;([^,]+)&quot;"
    
    Set RegIMGURL = R
End Function

Function RegMETADATA()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = " metadata=""{([^""]+)}"""
    
    Set RegMETADATA = R
End Function

Function RegURL()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = ";url=([^;]+)"
    
    Set RegURL = R
End Function

Function RegSRC()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = " src=""([^""]+)"""
    
    Set RegSRC = R
End Function

Function RegIMG()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "<img [^>]*>"
    
    Set RegIMG = R
End Function

Function RegResults()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = False
    R.IgnoreCase = True
    R.MultiLine = False
    R.Pattern = "(<[^>]* id=""sg_results.*)<div id=""sb_foot"
    
    Set RegResults = R
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
