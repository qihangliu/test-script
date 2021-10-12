@echo off  
Echo Install Tencent.WeChat  Tencent.wechat-work  
REM wechat
winget install  Tencent.WeChat
if %ERRORLEVEL% EQU 0 Echo wechat installed successfully.  
REM wechat-wort
winget install Tencent.wechat-work  
if %ERRORLEVEL% EQU 0 Echo wechat-work installed successfully. 
REM winrar
winget install  RARLab.WinRAR 
if %ERRORLEVEL% EQU 0 Echo winrar installed successfully. 
REM bandzip
winget install Bandisoft.Bandizip 
if %ERRORLEVEL% EQU 0 Echo bandzip installed successfully. 
REM notepad++
winget install Notepad++.Notepad++ 
if %ERRORLEVEL% EQU 0 Echo notepad++ installed successfully. 


 %ERRORLEVEL%
