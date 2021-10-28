@ECHO off  
chcp 65001
@REM 无限循环的标签  
:LOOP  
ECHO 请提前使用adb连接到设备
adb wait-for-device  
@REM 循环安装本目录下的APK文件  
FOR %%i IN (*.apk) DO (   
    ECHO 正在安装：%%i  
    adb install "%%i"  
)  
ECHO 安装完成
PAUSE  
GOTO LOOP  
@ECHO on