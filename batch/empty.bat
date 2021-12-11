@echo on
chcp 65001
title 自动解压
rem 自动解压升级包

for /f  %%i  in ('"dir *.zip /b"') do (
     @REM echo %%i
     tar xvf %%i 
     tar xvf factory.zip
     tar xvf product.zip
)

rem 解压完成
