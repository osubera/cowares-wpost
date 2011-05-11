' wpost
' post to web form
' Copyright (C) 2011 Tomizono - kobobau.com
' Fortitudinous, Free, Fair, http://cowares.nobody.jp

' usage> CScript wpost.vbs /e:CHARSET POSTDATA

' POSTDATA is a text file that contains urls and post parameters
' CHARSET is an encoding of the postdata file
' see examples for details

On Error Resume Next
Set Bag = New GlobalResources
Set Args = WScript.Arguments
Main Args.Named, Args.Unnamed
If Err.Number <> 0 Then WScript.Echo Err.Description
If Bag.Logger.Text <> "" Then
    SaveTextFile Bag.Logger.Text, GetTempPathOut
    WScript.Echo "Log: " & GetTempPathIn
End If
WScript.Quit(Err.Number)

Sub Main(Opts, Files)
    Dim File, Charset
    Dim ts, Finder
    Const adTypeText = 2
    
    Set ts = CreateObject("ADODB.Stream")
    Set Finder = New StreamParser
    Set Finder.Stream = ts
    Charset = Opts("e")
    If Charset = "" Then Charset = "utf-8"
    
    For Each File in Files
        ts.Open
        ts.Type = adTypeText
        ts.Charset = Charset
        ts.LoadFromFile File
        ReadWPost Finder
        ts.Close
    Next
    
    Set ts = Nothing
    Set Finder = Nothing
End Sub


'=== parse wpost sheet begin ===


Sub ReadWPost(Finder)
    Dim Bch, Ech
    Finder.Text = ""
    If Not SetSpecialChars(Finder, Bch, Ech) Then Exit Sub
    EvalAfter Finder, Bch, Ech
End Sub

Private Function SetSpecialChars(Finder, ByRef Bch, ByRef Ech)
    Dim i, EndBegins, At
    Const SheetName = "wpost"
    
    SetSpecialChars = False
    At = Finder.FindString(1, SheetName, vbBinaryCompare)
    If At <= 1 Then Exit Function
    
    Finder.Text = Mid(Finder.Text, At - 1)
    
    Bch = Left(Finder.Text, 1)
    EndBegins = Len(SheetName) + 2
    i = Finder.FindString(EndBegins, Bch, vbBinaryCompare)
    If i <= EndBegins Then Exit Function
    
    Ech = Mid(Finder.Text, EndBegins, i - EndBegins)
    SetSpecialChars = True
End Function

Private Sub EvalAfter(Finder, Bch, Ech)
    Dim BlockName, Key, Value, BeforeTag
    Dim BlockVoid
    Dim EchNextBlock
    
    BlockName = ""
    EchNextBlock = Ech & Bch
    Do Until Finder.AtEndOfStream
        EvalComma BeforeTag, Finder, Bch, Ech
        EvalEscape BeforeTag, Finder, Bch, Ech
        EvalBefore BeforeTag, Bch, BlockName, Key, Value, BlockVoid
        
        If BlockName = "" Then
            Finder.Text = Ech & Finder.Text
            EvalComma BeforeTag, Finder, Bch, EchNextBlock
            If Finder.Text <> "" Then Finder.Text = Bch & Finder.Text
        ElseIf BlockName = "end" Then
            Exit Do
        End If
    Loop
End Sub

Private Sub EvalComma(ByRef BeforeTag, Finder, Bch, Ech)
    Dim At
    
    At = Finder.FindString(1, Ech, vbBinaryCompare)
    If At = 0 Then
        BeforeTag = Finder.Text
        Finder.Text = ""
    Else
        BeforeTag = Left(Finder.Text, At - 1)
        Finder.Text = Right(Finder.Text, Len(Finder.Text) - At + 1 - Len(Ech))
    End If
End Sub

Private Sub EvalEscape(ByRef BeforeTag, Finder, Bch, EchStd)
    Dim Ech, At
    Dim KeyValue
    
    If Left(BeforeTag, 1) <> Bch Then Exit Sub
    
    KeyValue = Split(BeforeTag, Bch, 3, vbBinaryCompare)
    Ech = Right(KeyValue(1), 1)
    If Ech = "" Then Exit Sub
    If Asc(Ech) > 0 And Asc(Ech) < 128 Then Exit Sub
    
    At = Finder.FindString(1, EchStd & Ech & EchStd, vbBinaryCompare)
    BeforeTag = Bch & Trim(Left(KeyValue(1), Len(KeyValue(1)) - 1)) & Bch
    If At = 0 Then
        BeforeTag = BeforeTag & Finder.Text
        Finder.Text = ""
    Else
        BeforeTag = BeforeTag & Left(Finder.Text, At - 1)
        Finder.Text = Right(Finder.Text, Len(Finder.Text) - At + 1 - Len(Ech))
    End If
End Sub

Private Sub EvalBefore(BeforeTag, Bch, ByRef BlockName, ByRef Key, ByRef Value, ByRef BlockVoid)
    Dim KeyValue
    
    KeyValue = Split(BeforeTag, Bch, 3, vbBinaryCompare)
    If BeforeTag = "" Then
        BlockName = ""
    ElseIf BlockName = "" Then
        If UBound(KeyValue) = 1 Then
            BlockName = KeyValue(1)
            Key = ""
            Value = ""
            BlockVoid = False
        End If
    ElseIf Not BlockVoid And UBound(KeyValue) = 2 Then
        Key = Trim(KeyValue(1))
        Value = KeyValue(2)
        If Key = "void" Then
            BlockVoid = True
        Else
            If BlockName = "action" Then
                DoAction Key, Value, BlockVoid, BlockName
            Else
                Bag.SetEnv BlockName, Key, Value
            End If
        End If
    End If
End Sub


'=== parse wpost sheet end ===
'=== control actions begin ===


Private Sub DoAction(Key, Value, ByRef BlockVoid, ByRef BlockName)
    Bag.Logger.WriteLine "Action: " & Key & ", " & Value
    
    Select Case Key
    Case "submit"
        Submit Trim(Value)
    Case "run"
        RunScript Trim(Value)
    Case "run-cmd"
        RunCmd Trim(Value)
    Case "gather"
        GatherOutput Trim(Value)
    Case "remove"
        RemoveFile Trim(Value)
    Case "clear"
        ClearEnv Trim(Value)
    Case "verbose"
        VerboseEnv Trim(Value)
    Case "if-empty"
        BlockVoid = Not VoidIfEmpty(Trim(Value))
    Case "if-not-empty"
        BlockVoid = VoidIfEmpty(Trim(Value))
    Case "end"
        BlockName = "end"
    End Select
    
    If BlockVoid Then Bag.Logger.WriteLine "is void"
End Sub


'=== control actions end ===
'=== act miscellaneous begin ===


Private Sub ClearEnv(Value)
    If Bag.Env.Exists(Value) Then Bag.Env(Value).RemoveAll
End Sub

Private Sub VerboseEnv(Value)
    Dim BlockName
    Bag.Logger.WriteLine "verbose dump begin"
    For Each BlockName In Bag.Env.Keys
        Bag.Logger.WriteLine BlockName
        For Each k In Bag.Env(BlockName)
            Bag.Logger.WriteLine k & " = " & Bag.Env(BlockName)(k)
        Next
    Next
    Bag.Logger.WriteLine "verbose dump end"
End Sub

Private Sub GatherOutput(Value)
    Dim GatherFile, LastFile
    Dim fs, inSt, outSt
    Const TristateFalse = 0
    Const TristateTrue = -1
    Const ForReading = 1
    Const ForWriting = 2
    Const ForAppending = 8
    
    If Value = "" Then Exit Sub
    GatherFile = MakeTempFileName(Value)
    LastFile = GetLastTempPath
    If LastFile = "" Then Exit Sub
    
    Bag.Logger.WriteLine "append " & LastFile & " into " & GatherFile
    Set fs = Bag.FileSystem
    Set inSt = fs.OpenTextFile(LastFile, ForReading, False, TristateTrue)
    Set outSt = fs.OpenTextFile(GatherFile, ForAppending, True, TristateTrue)
    ' TristateTrue is required for a text including non-ANSI characters.
    If outSt Is Nothing Then Err.Raise 52    ' invalid file name
    If Not inSt.AtEndOfStream Then
        outSt.Write inSt.ReadAll
    End If
    outSt.Close
    inSt.Close
    Set outSt = Nothing
    Set inSt = Nothing
    Set fs = Nothing
End Sub

Private Sub RemoveFile(Value)
    Dim FileName
    
    If Value = "" Then Exit Sub
    
    If Mid(Value, 2, 1) = ":" Then
        FileName = Value
    Else
        FileName = MakeTempFileName(Value)
    End If
    
    If Bag.FileSystem.FileExists(FileName) Then
        Bag.Logger.WriteLine "remove file: " & FileName
        Bag.FileSystem.DeleteFile FileName
    End If
End Sub

Private Function VoidIfEmpty(Value)
    Dim fs, FileName, out
    
    If Value = "" Then
        FileName = GetLastTempPath
    ElseIf Mid(Value, 2, 1) = ":" Then
        FileName = Value
    Else
        FileName = MakeTempFileName(Value)
    End If
    Bag.Logger.WriteLine "check empty: " & FileName
    
    Set fs = Bag.FileSystem
    If Not fs.FileExists(FileName) Then
        out = True
    ElseIf fs.GetFile(FileName).Size = 0 Then
        out = True
    Else
        out = False
    End If
    Set fs = Nothing
    Bag.Logger.WriteLine "empty = " & CStr(out)
    
    VoidIfEmpty = out
End Function


'=== act miscellaneous end ===
'=== act submit begin ===


Private Sub Submit(Value)
    Const TristateFalse = 0
    Const TristateTrue = -1
    Const ForReading = 1
    Dim Url, ts, inFile, Counter
    
    inFile = GetTempPathIn
    
    If Bag.Input.Exists("data") Then
        Bag.Logger.WriteLine "reading data from: " & inFile
        SetEnvDataFromFile inFile
    End If
    
    If Bag.Input.Exists("url-list") Then
        Bag.Logger.WriteLine "reading url list from: " & inFile
        Set ts = Bag.FileSystem.OpenTextFile(inFile, ForReading, False, TristateTrue)
        ' TristateTrue is required to read a text including non-ANSI characters.
        Counter = 0
        Do Until ts.AtEndOfStream
            Url = ts.ReadLine
            SubmitOne Url
            SetReferer Url
            Counter = Counter + 1
        Loop
        ts.Close
        Set ts = Nothing
        Bag.Logger.WriteLine Counter & " urls are processed from: " & inFile
    Else
        Url = Bag.Request("url")
        SubmitOne Url
        SetReferer Url
    End If
End Sub

Private Sub SetReferer(Url)
    Bag.Header("Referer") = Url
End Sub

Private Sub SubmitOne(Url)
    Dim tp, Method, GetUrl
    
    If Left(Url, 4) <> "http" Then Exit Sub
    
    Set tp = Bag.Http
    Method = UCase(Bag.GetEnv("request", "method", "GET"))
    
    On Error Resume Next
    If Method = "POST" Then
        tp.Open Method, Url, False
        SetRequestHeaders tp, Method, Url
        tp.send EncodePostData
    Else
        GetUrl = EncodeGetData(Url)
        tp.Open Method, GetUrl, False
        SetRequestHeaders tp, Method, Url
        tp.send
    End If
    
    If Err.Number <> 0 then
        Bag.Logger.WriteLine "Error " & Err.Number & " " & Err.Description & " for " & Url
        Err.Clear
    Else
        ReportResponse tp, Url
    End If
End Sub

Private Sub SetRequestHeaders(tp, Method, Url)
    Dim h
    
    If Bag.Input.Exists("referer-self") Then
        Bag.SetEnv "header", "Referer", Url
    ElseIf Bag.Input.Exists("referer-clear") Then
        Bag.SetEnv "header", "Referer", ""
    End If
    
    For Each h In Bag.Header.Keys
        Bag.Logger.WriteLine "SetRequestHeaders: " & h & " = " & Bag.Header(h)
        tp.setRequestHeader h, Bag.Header(h)
    Next
    
    If Method = "POST" And Not Bag.Header.Exists("Content-Type") Then
        tp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    End If
End Sub

Private Function EncodePostData()
    Dim out, Charset
    
    out = ""
    Charset = LCase(Bag.GetEnv("request", "charset", "utf-8"))
    For Each Key In Bag.Data.Keys
        If out <> "" Then out = out & "&"
        out = out & Key & "=" & EncUrlString(Bag.Data(Key), Charset)
    Next
    
    If out <> "" Then Bag.Logger.WriteLine "DATA: " & out
    EncodePostData = out
End Function

Private Function EncodeGetData(Url)
    Dim EncodedData, out
    
    EncodedData = EncodePostData
    If EncodedData = "" Then
        out = Url
    ElseIf InStr(Url, "?") = 0 Then
        out = Url & "?" & EncodedData
    Else
        out = Url & "&" & EncodedData
    End If
    
    Bag.Logger.WriteLine "GET URL: " & out
    EncodeGetData = out
End Function

Private Function EncUrlString(Text, Charset)
    Dim bs, Stream
    Dim out
    Const adTypeBinary = 1

    Set Stream = CreateObject("ADODB.Stream")
    
    Stream.Open
    Stream.Charset = Charset
    Stream.WriteText Text
    
    Stream.Position = 0
    Stream.Type = adTypeBinary
    
    ' skip 3 bytes BOM
    If Charset = "utf-8" Then Stream.Position = 3
    
    out = ""
    Do Until Stream.EOS
        bs = AscB(Stream.Read(1))
        out = out & EncUrlByte(bs)
    Loop
    Stream.Close
    Set Stream = Nothing
    
    EncUrlString = out
End Function

Private Function EncUrlByte(Data)
    Dim out
    
    If Data = &H20 Then   '" "
        out = "+"
    ElseIf Data >= &H30 And Data <= &H39 Then   '"0" to "9"
        out = Chr(Data)
    ElseIf Data >= &H41 And Data <= &H5A Then   '"A" to "Z"
        out = Chr(Data)
    ElseIf Data >= &H61 And Data <= &H7A Then   '"a" to "z"
        out = Chr(Data)
    ElseIf Data = &H2E Then   '"."
        out = Chr(Data)
    ElseIf Data = &H2D Then   '"-"
        out = Chr(Data)
    ElseIf Data = &H5F Then   '"_"
        out = Chr(Data)
    ElseIf Data < &H10 Then
        out = "%0" & Hex(Data)
    Else
        out = "%" & Hex(Data)
    End If
    
    EncUrlByte = out
End Function

Private Sub SetEnvDataFromFile(FileName)
    Const TristateFalse = 0
    Const TristateTrue = -1
    Const ForReading = 1
    Dim ts, KeyValue
    
    Set ts = Bag.FileSystem.OpenTextFile(FileName, ForReading, False, TristateTrue)
    ' TristateTrue is required to read a text including non-ANSI characters.
    Do Until ts.AtEndOfStream
        KeyValue = Split(ts.ReadLine, " ", 2)
        If UBound(KeyValue) = 1 Then
            Bag.SetEnv "data", Trim(KeyValue(0)), KeyValue(1)
        End If
    Loop
    ts.Close
    Set ts = Nothing
End Sub


'=== act submit end ===
'=== act report begin ===


Private Sub ReportResponse(tp, Url)
    Dim FileName, AsText, LogHeader, At
    
    Bag.Logger.WriteLine tp.Status & " " & tp.statusText & " " & Url
    LogHeader = True
    If LogHeader Then Bag.Logger.Write tp.getAllResponseHeaders
    
    FileName = GetSaveFileName(tp, Url)
    AsText = Bag.Output.Exists("text")
    If AsText Then
        Bag.Logger.WriteLine "save text to: " & FileName
        SaveTextFile GetResponseText(tp), FileName
    Else
        Bag.Logger.WriteLine "save raw to: " & FileName
        SaveBinaryFile tp.responseBody, FileName
    End If
    
    At = InStr(Url, "?")
    If At = 0 Then
        Bag.Misc("last-url") = Url
    Else
        Bag.Misc("last-url") = Left(Url, At - 1)
    End If
    Bag.Misc("last-saved-file") = FileName
    Bag.Logger.WriteLine Bag.Misc("last-url") & " " & FileName & vbCrLf
End Sub

Private Function GetSaveFileName(tp, Url)
    Dim FileName, FolderName
    
    FileName = Bag.PopEnv("output", "file", "")
    If FileName = "" Then
        FolderName = Bag.GetEnv("output", "folder", "")
        If FolderName <> "" Then
            FileName = GetUniquePath(FolderName, GetFileExtByMime(tp))
        Else
            FileName = GetTempPathOut
        End If
    End If
    
    GetSaveFileName = FileName
End Function

Private Function GetUniquePath(ByVal FolderName, ByVal FileExt)
    Dim out, Base, fs
    
    If Right(FolderName, 1) <> "\" Then FolderName = FolderName & "\"
    If Left(FileExt, 1) <> "." Then FileExt = "." & FileExt
    
    Base = CLng(Bag.Misc("last-file-base"))
    Set fs = Bag.FileSystem
    Do
        Base = Base + 1
        out = fs.GetAbsolutePathName(FolderName & CStr(Base) & FileExt)
    Loop While fs.FileExists(out)
    Set fs = Nothing
    Bag.Misc("last-file-base") = Base
    
    GetUniquePath = out
End Function

Private Function GetFileExtByMime(tp)
    Dim out
    out = Replace(Split(tp.getResponseHeader("Content-Type"), ";")(0), "/", ".")
    If out = "" Then out = "bin"
    GetFileExtByMime = out
End Function

Private Sub SaveBinaryFile(Data, FileName)
    Const adTypeBinary = 1
    Const adSaveCreateOverWrite = 2
    Dim Stream
    
    Set Stream = CreateObject("ADODB.Stream")
    Stream.Open
    Stream.Type = adTypeBinary
    Stream.Write Data
    Stream.SaveToFile FileName, adSaveCreateOverWrite
    Stream.Close
    Set Stream = Nothing
End Sub

Private Sub SaveTextFile(Data, FileName)
    Const TristateFalse = 0
    Const TristateTrue = -1
    Const ForWriting = 2
    Dim Stream
    
    Set Stream = Bag.FileSystem.OpenTextFile(FileName, ForWriting, True, TristateTrue)
    ' TristateTrue is required to save a text including non-ANSI characters.
    If Stream Is Nothing Then Err.Raise 52    ' invalid file name
    Stream.Write Data
    Stream.Close
    Set Stream = Nothing
End Sub

Private Function CharsetByResponseHeader(tp)
    Dim out, ContentType, At
    
    out = ""
    ContentType = Split(tp.getResponseHeader("Content-Type"), ";")
    If UBound(ContentType) >= 1 Then
        At = InStr(1, ContentType(1), "charset=", vbTextCompare)
        If At > 0 Then
            out = LCase(Trim(Mid(ContentType(1), At + Len("charset="))))
        End If
    End If
    
    CharsetByResponseHeader = out
End Function

Private Function CharsetByMeta(tp)
    Dim out, At
    
    out = ""
    At = InStr(1, tp.responseText, "charset=", vbTextCompare)
    If At > 0 Then
        out = LCase(Mid(tp.responseText, At + Len("charset="), 64))
        out = Left(out, InStr(1, out, """", vbBinaryCompare))
        If out <> "" Then out = Left(out, Len(out) - 1)   ' remove last "
    End If
    
    CharsetByMeta = out
End Function

Private Function GetResponseText(tp)
    Dim AutoCharset, InCharset
    Dim out
    
    AutoCharset = CharsetByResponseHeader(tp)
    Bag.Logger.WriteLine "header charset: " & AutoCharset
    InCharset = LCase(Bag.GetEnv("request", "charset", AutoCharset))
    Bag.Logger.WriteLine "expected charset: " & InCharset
    If InCharset = "" Then InCharset = CharsetByMeta(tp)
    Bag.Logger.WriteLine "charset: " & InCharset
    
    If InCharset = AutoCharset Then   ' includes blank
        out = tp.responseText
    ElseIf InCharset = "utf-8" And AutoCharset = "" Then
        out = tp.responseText
    Else
        Bag.Logger.WriteLine "convert from raw into: " & InCharset
        out = DecodeResponseBody(tp, InCharset)
    End If
    
    GetResponseText = out
End Function

Private Function DecodeResponseBody(tp, Charset)
    Dim out, Stream
    Const adTypeBinary = 1
    Const adTypeText = 2
    
    Set Stream = CreateObject("ADODB.Stream")
    
    Stream.Open
    Stream.Type = adTypeBinary
    Stream.Write tp.responseBody
    
    Stream.Position = 0
    Stream.Type = adTypeText
    Stream.Charset = Charset
    out = Stream.ReadText
    Stream.Close
    
    Set Stream = Nothing
    DecodeResponseBody = out
End Function


'=== act report end ===
'=== act run begin ===


Private Sub RunScript(Value)
    Dim rc, cmd
    
    If Value = "" Then Exit Sub
    
    cmd = "cmd /D /U /C CScript //NoLogo //U " & _
            GetScriptPath(Value) & " /url:" & Replace(Bag.Misc("last-url"), "%", "%%") & _
            " < " & GetTempPathIn & " > " & GetTempPathOut
    rc = Bag.Shell.Run(cmd, 8, True)
    Bag.Logger.WriteLine "run returns " & rc & " for " & cmd
End Sub

Private Sub RunCmd(Value)
    Dim rc, cmd
    
    If Value = "" Then Exit Sub
    
    cmd = "cmd /D /U /C " & _
            Value & _
            " < " & GetTempPathIn & " > " & GetTempPathOut
    rc = Bag.Shell.Run(cmd, 8, True)
    Bag.Logger.WriteLine "run-cmd returns " & rc & " for " & cmd
End Sub

Private Function GetScriptPath(Value)
    Dim ScriptFolder
    
    If Mid(Value, 2, 1) = ":" Then
        ScriptFolder = ""
    Else
        If Bag.Misc.Exists("script-folder") Then
            ScriptFolder = Bag.Misc("script-folder")
        Else
            ScriptFolder = Bag.FileSystem.GetParentFolderName(WScript.ScriptFullName)
            Bag.Misc("script-folder") = ScriptFolder
        End If
        If Right(ScriptFolder, 1) <> "\" Then ScriptFolder = ScriptFolder & "\"
    End If
    
    GetScriptPath = ScriptFolder & Value
End Function


'=== act run end ===
'=== temporary files begin ===


Private Function GetTempPathOut()
    Dim Base, out
    
    Base = Bag.PopEnv("output", "temp", "")
    If Base = "" Then
        Base = CLng(Bag.Misc("temp-last-number")) + 1
        Bag.Misc("temp-last-number") = Base
    End If
    out = MakeTempFileName(Base)
    
    Bag.Misc("temp-last-path") = out
    GetTempPathOut = out
End Function

Private Function GetTempPathIn()
    Dim Base, out
    
    Base = Bag.PopEnv("input", "temp", "")
    If Base = "" Then
        out = GetLastTempPath
    Else
        out = MakeTempFileName(Base)
    End If
    
    GetTempPathIn = out
End Function

Private Function GetLastTempPath()
    GetLastTempPath = Bag.Misc("temp-last-path")
End Function

Private Function GetTempFolder()
    Dim ScriptFolder
    
    If Bag.Misc.Exists("temp-folder") Then
        out = Bag.Misc("temp-folder")
    Else
        out = Bag.FileSystem.GetParentFolderName(WScript.ScriptFullName)
        Bag.Misc("temp-folder") = out
    End If
    If Right(out, 1) <> "\" Then out = out & "\"
    
    GetTempFolder = out
End Function

Private Function MakeTempFileName(Base)
    Dim Temp, out
    
    Temp = Bag.GetEnv("misc", "temp-name", "temp")
    out = GetTempFolder & "w_" & Base & "_" & Temp & ".txt"
    
    MakeTempFileName = out
End Function


'=== temporary files end ===
'=== classes begin ===
'  StreamParser, GlobalResources, StringStream

Class StreamParser
    Public Text
    Public Stream
    
    Public Property Get EOS
        EOS = Stream.EOS
    End Property
    
    Public Property Get AtEndOfStream
        AtEndOfStream = EOS And (Text = "")
    End Property
    
    Public Function MoreText()
        If EOS Then Exit Function
        
        Const BuffSize = 8192
        Dim out
        out = Stream.ReadText(BuffSize)
        Text = Text & out
        MoreText = out
    End Function
    
    Public Function FindString(StartAt, Search, CompareMethod)
        Dim out, more, At, Require
        
        Require = StartAt + Len(Search) - 1
        Do While Len(Text) < Require
            more = MoreText
            If more = "" Then Exit Do
        Loop
        
        out = InStr(StartAt, Text, Search, CompareMethod)
        Do While out = 0
            At = Len(Text) - Len(Search) + 2
            more = MoreText
            If more = "" Then Exit Do
            
            out = InStr(At, Text, Search, CompareMethod)
        Loop
        
        FindString = out
    End Function
End Class

Class GlobalResources
    Public Env, Request, Header, Data, Binary, Input, Output, Log, Misc
    Public FileSystem, Shell, Http
    Public Logger
    
    Public Function PopEnv(BlockName, Key, DefaultValue)
        If Env.Exists(BlockName) Then
            If Env(BlockName).Exists(Key) Then
                PopEnv = Env(BlockName)(Key)
                Env(BlockName).Remove Key
            Else
                PopEnv = DefaultValue
            End If
        End If
    End Function
    
    Public Function GetEnv(BlockName, Key, DefaultValue)
        If Env.Exists(BlockName) Then
            If Env(BlockName).Exists(Key) Then
                GetEnv = Env(BlockName)(Key)
            Else
                GetEnv = DefaultValue
            End If
        End If
    End Function
    
    Public Sub SetEnv(BlockName, Key, Value)
        If Env.Exists(BlockName) Then
            If Key = "clear" Then
                Env(BlockName).RemoveAll
            Else
                Env(BlockName)(Key) = Value
            End If
        Else
            Logger.WriteLine "SetEnv: Unknown Block: " & BlockName & ", " & Key & ", " & Value
        End If
        Logger.WriteLine "SetEnv: " & BlockName & ", " & Key & ", " & Value
    End Sub
    
    Private Sub Class_Initialize
        Dim x
        Const TextCompare = 1
        
        Set Logger = New StringStream
        Set FileSystem = CreateObject("Scripting.FileSystemObject")
        Set Shell = CreateObject("WScript.Shell")
        Set Http = CreateObject("MSXML2.XMLHTTP")
        'Set Http = CreateObject("MSXML2.XMLHTTP.6.0")
        Set Env = CreateObject("Scripting.Dictionary")
        Set Request = CreateObject("Scripting.Dictionary")
        Set Header = CreateObject("Scripting.Dictionary")
        Set Data = CreateObject("Scripting.Dictionary")
        Set Binary = CreateObject("Scripting.Dictionary")
        Set Input = CreateObject("Scripting.Dictionary")
        Set Output = CreateObject("Scripting.Dictionary")
        Set Log = CreateObject("Scripting.Dictionary")
        Set Misc = CreateObject("Scripting.Dictionary")
        
        Set Env("request") = Request
        Set Env("header") = Header
        Set Env("data") = Data
        Set Env("binary") = Binary
        Set Env("input") = Input
        Set Env("output") = Output
        Set Env("log") = Log
        Set Env("misc") = Misc
        
        For Each x in Env.Items
            x.CompareMode = TextCompare
        Next
    End Sub
    
    Private Sub Class_Terminate
        Env.RemoveAll
        Set Misc = Nothing
        Set Log = Nothing
        Set Output = Nothing
        Set Input = Nothing
        Set Binary = Nothing
        Set Data = Nothing
        Set Header = Nothing
        Set Request = Nothing
        Set Env = Nothing
        Set Http = Nothing
        Set Shell = Nothing
        Set FileSystem = Nothing
        Set Logger = Nothing
    End Sub
End Class

Class StringStream
    Public Text
    
    Public Sub WriteLine(Data)
        Text = Text & Data & vbCrLf
    End Sub
    
    Public Sub Write(Data)
        Text = Text & Data
    End Sub
End Class


'=== classes end ===
