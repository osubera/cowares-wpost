@ECHO OFF
set DIR=C:\tmp\y

if "%1" == "" goto USAGE

cmd /D /U /C echo p %* > %DIR%\w_keyword_temp.txt
cscript //NoLogo wpost.vbs ヤフー検索.txt
type %DIR%\w_result_temp.txt

goto DONE

:USAGE

echo yahoo 検索語１ [検索語２],,,
echo 検索語で yahoo ウェブ検索した結果を標準出力に出す。

:DONE