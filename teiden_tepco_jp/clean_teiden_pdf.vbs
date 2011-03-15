' clean_teiden_pdf
' wpost page analyser for teiden.pdf
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript //NoLogo nop.vbs /url:URL < in > out

'On Error Resume Next
Main WScript.StdIn, WScript.StdOut
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)

Sub Main(inSt, outSt)
    Dim Text
    
    Text =RegClean.Replace(inSt.ReadAll, vbCrLf)
    
    outSt.Write ChrW(&HFEFF)    ' adding unicode bom enables notepad to see the result
    outSt.Write Text
End Sub

Function RegClean()
    Dim R
    
    Set R = CreateObject("VBScript.RegExp")
    R.Global = True
    R.IgnoreCase = False
    R.MultiLine = True
    ' �Ƃ肠�����A���y�[�W�L���ƁA�S�p�u�����N�i��ɍs���j������������s�ɒu�������Ă݂�B
    R.Pattern = "\x0C|�@"
    
    Set RegClean = R
End Function
