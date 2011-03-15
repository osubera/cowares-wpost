@echo off
pushd C:\tmp\xpdf

REM pdftotext.exe -cfg xpdfrc.ini -enc Shift-JIS 110314m.pdf -
pdftotext.exe -cfg xpdfrc.ini -enc Shift-JIS %1 %2

popd
