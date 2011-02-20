' goodic
' search goo dictionaries
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

Const PopX = 500    ' x location by screen twips
Const PopY = 1000   ' y location by screen twips

'On Error Resume Next
Main
If Err.Number <> 0 Then WScript.Echo Err.Description
WScript.Quit(Err.Number)


Sub Main()
    SearchPrompt
End Sub

Sub SearchPrompt()
    Dim AText, out
    Const Title = "ÉOÅ[é´èë"
    
    Do
        AText = InputBox(out, Title, AText, PopX, PopY)
        If AText = "" Then Exit Sub
        out = DoSearch(AText)
    Loop
End Sub

Function DoSearch(Text)
    Dim out, cmd, rc
    Dim fs, sh, ts
    Const TristateFalse = 0
    Const TristateTrue = -1
    Const ForReading = 1
    
    Const BatName = "goodic.bat"
    Const ResultFile = "C:\tmp\g\w_result_temp.txt"
    
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set sh = CreateObject("WScript.Shell")
    
    ScriptFolder = fs.GetParentFolderName(WScript.ScriptFullName)
    If Right(ScriptFolder, 1) <> "\" Then ScriptFolder = ScriptFolder & "\"
    BatFullPath = """" & ScriptFolder & BatName & """ "
    
    cmd = "cmd /D /U /C " & _
            BatFullPath & Text
    rc = sh.Run(cmd, 8, True)
    
    If rc <> 0 Then
        out = "Error " & rc
    Else
        Set ts = fs.OpenTextFile(ResultFile, ForReading, False, TristateTrue)
        ' TristateTrue is required to read a text including non-ANSI characters.
        out = ts.ReadAll
        ts.Close
        Set ts = Nothing
    End If
    
    Set sh = Nothing
    Set fs = Nothing
    DoSearch = out
End Function
