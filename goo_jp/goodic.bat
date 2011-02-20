@ECHO OFF
setlocal
set DIR=C:\tmp\g

if "%1" == "" goto USAGE

cmd /D /U /C echo MT %* > %DIR%\w_keyword_temp.txt
cscript //NoLogo wpost.vbs グー辞書.txt
type %DIR%\w_result_temp.txt

goto DONE

:USAGE

echo goodic 検索語
echo 検索語で goo 辞書引きした結果を標準出力に出す。

:DONE
endlocal