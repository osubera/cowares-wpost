@ECHO OFF
setlocal
set DIR=C:\tmp\g

if "%1" == "" goto USAGE

cmd /D /U /C echo MT %* > %DIR%\w_keyword_temp.txt
cscript //NoLogo wpost.vbs �O�[����.txt
type %DIR%\w_result_temp.txt

goto DONE

:USAGE

echo goodic ������
echo ������� goo ���������������ʂ�W���o�͂ɏo���B

:DONE
endlocal