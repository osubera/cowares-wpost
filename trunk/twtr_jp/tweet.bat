@ECHO OFF
set DIR=C:\tmp\t

if "%1" == "" goto USAGE

cmd /D /U /C echo text %* > %DIR%\w_tweet_temp.txt
cscript //NoLogo wpost.vbs �g�уc�C�b�^�[�Ƀ��O�C��.txt �g�уc�C�b�^�[�łԂ₭.txt

goto DONE

:USAGE

echo tweet �Ԃ₫

:DONE