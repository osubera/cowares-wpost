@ECHO OFF
set DIR=C:\tmp\t

if "%1" == "" goto USAGE

cmd /D /U /C echo text %* > %DIR%\w_tweet_temp.txt
cscript //NoLogo wpost.vbs 携帯ツイッターにログイン.txt 携帯ツイッターでつぶやく.txt

goto DONE

:USAGE

echo tweet つぶやき

:DONE