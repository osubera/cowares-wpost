@ECHO OFF
set DIR=C:\tmp\y

if "%1" == "" goto USAGE

cmd /D /U /C echo p %* > %DIR%\w_keyword_temp.txt
cscript //NoLogo wpost.vbs ���t�[����.txt
type %DIR%\w_result_temp.txt

goto DONE

:USAGE

echo yahoo ������P [������Q],,,
echo ������� yahoo �E�F�u�����������ʂ�W���o�͂ɏo���B

:DONE