@echo off&setlocal enabledelayedexpansion
color 2f
mode con cols=55 lines=30
:sc
title  IPһ���л�
:sc_top
cls
rd /s /q %temp%\ip_temp>nul 2>nul
md %temp%\ip_temp>nul 2>nul
echo.&echo.&echo.
ipconfig /all|findstr . >%temp%\ip_temp\t.txt
ver|findstr /c:"6.">nul && goto sc_7
ver|findstr /c:"10.">nul && goto sc_10
:sc_xp
echo xp>%temp%\ip_temp\xp.txt
findstr /i /b "Ethernet Wireless" %temp%\ip_temp\t.txt|findstr /v /i "vmware virtualBox">%temp%\ip_temp\t1.txt
for /f "tokens=1 delims=:" %%a in (%temp%\ip_temp\t1.txt) do echo %%a>>%temp%\ip_temp\net2.txt
if not exist %temp%\ip_temp\net2.txt echo none>%temp%\ip_temp\none.txt && goto sc_off
del /q %temp%\ip_temp\t1.txt >nul 2>nul
set z=0
for /f "tokens=2,* delims= " %%a in (%temp%\ip_temp\net2.txt) do (
set /a z+=1
echo                    !z!��%%b>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
)
for /f "tokens=12 delims=: " %%a in ('findstr /i /c:"Default Gateway" %temp%\ip_temp\t.txt') do (set q=%%a & ping !q! -n 1 -w 10>nul && goto sc_on)
goto sc_off
:sc_7
findstr /i /b /c:"Windows IP ����" %temp%\ip_temp\t.txt>nul||goto 7en
echo 7cn>%temp%\ip_temp\7cn.txt
findstr /i /c:"Microsoft Virtual WiFi Miniport Adapter" %temp%\ip_temp\t.txt>nul || goto novwifi
goto sc_10_next
:sc_10
findstr /i /b /c:"Windows IP ����" %temp%\ip_temp\t.txt>nul||goto 10en
echo 10cn>%temp%\ip_temp\10cn.txt
findstr /i /c:"Microsoft Wi-Fi Direct Virtual Adapter" %temp%\ip_temp\t.txt>nul || goto novwifi
:sc_10_next
echo V_WiFi>>%temp%\ip_temp\V_WiFi.txt
netsh wlan set hostednetwork mode=disallow>nul 2>nul
ipconfig /all|findstr . >%temp%\ip_temp\t.txt
:novwifi
findstr /r /b "��̫�������� ���߾�����������" %temp%\ip_temp\t.txt|findstr /v /i "vmware virtualBox">%temp%\ip_temp\t1.txt
:sc_10_next2
for /f "tokens=1 delims=:" %%a in (%temp%\ip_temp\t1.txt) do echo %%a>>%temp%\ip_temp\net2.txt
if not exist %temp%\ip_temp\net2.txt echo none>%temp%\ip_temp\none.txt && goto sc_off
del /q %temp%\ip_temp\t1.txt >nul 2>nul
if exist %temp%\ip_temp\V_WiFi.txt netsh wlan set hostednetwork mode=allow>nul 2>nul && del /q %temp%\ip_temp\V_WiFi.txt >nul 2>nul
set z=0
for /f "tokens=1,* delims= " %%a in (%temp%\ip_temp\net2.txt) do (
set /a z+=1
echo                    !z!��%%b>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
)
for /f "tokens=14 delims=: " %%a in ('findstr "Ĭ������" %temp%\ip_temp\t.txt') do (set q=%%a & ping !q! -n 1 -w 10>nul && goto sc_on)
goto sc_off
:7en
echo 7en>%temp%\ip_temp\7en.txt
findstr /i /b "Ethernet Wireless" %temp%\ip_temp\t.txt|findstr /v /i "vmware virtualBox">%temp%\ip_temp\t1.txt
for /f "tokens=1 delims=:" %%a in (%temp%\ip_temp\t1.txt) do echo %%a>>%temp%\ip_temp\net2.txt
if not exist %temp%\ip_temp\net2.txt echo none>%temp%\ip_temp\none.txt && goto sc_off
del /q %temp%\ip_temp\t1.txt >nul 2>nul
set z=0
for /f "tokens=2,* delims= " %%a in (%temp%\ip_temp\net2.txt) do (
set /a z+=1
echo               !z!��%%b>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
echo.>>%temp%\ip_temp\net.txt
)
for /f "tokens=12 delims=: " %%a in ('findstr /i /c:"Default Gateway" %temp%\ip_temp\t.txt') do (set q=%%a & ping !q! -n 1 -w 10>nul && goto sc_on)
goto sc_off
:sc_on
echo                   ��������״̬�� ���� & echo.
goto sc_main
:sc_off
echo                   ��������״̬�� ���� & echo.
del /q %temp%\ip_temp\t1.txt >nul 2>nul
goto sc_main
:sc_main
echo       -------------------------------------------
echo.&echo.
echo             1.�鿴�������������� & echo.
if exist IP1.ini (
for /f "delims=" %%a in ('findstr "�л���" IP1.ini') do echo             2.%%a & echo.
) else (
echo             2.�ֶ���� IP1 & echo.
)
if exist IP2.ini (
for /f "delims=" %%a in ('findstr "�л���" IP2.ini') do echo             3.%%a & echo.
) else (
echo             3.�ֶ���� IP2����ѡ� & echo.
)
if exist IP3.ini (
for /f "delims=" %%a in ('findstr "�л���" IP3.ini') do echo             4.%%a & echo.
) else (
echo             4.�ֶ���� IP3����ѡ� & echo.
)
if exist IP4.ini (
for /f "delims=" %%a in ('findstr "�л���" IP4.ini') do echo             5.%%a & echo.
) else (
echo             5.�ֶ���� IP4����ѡ� & echo.
)
echo             6.�Զ���ȡ IP & echo.
echo             7.�޸ġ��������� & echo.
echo             9.�� �� & echo.
echo.&echo.
set str1=123456789
set "select="
set/p select= �������֣����س� :
if not defined select goto sc_w
echo %select%|findstr "[%str1%]">nul||goto sc_w
if "%select%"=="1" (goto sc_bj) 
if "%select%"=="2" (goto sc_one) 
if "%select%"=="3" (goto sc_two) 
if "%select%"=="4" (goto sc_three) 
if "%select%"=="5" (goto sc_four) 
if "%select%"=="6" (goto sc_dhcp) 
if "%select%"=="7" (goto sc_gmenu)  
if "%select%"=="9" (goto sc_exit) 

exit
:sc_w
echo MyVar=MsgBox(" ������1-9֮������֣�", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
call :c_404
goto sc_top
:sc_bj
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_bj_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_bj_next
cls
echo.&echo.&echo.
call :c_info
if exist %temp%\ip_temp\169.txt call :c_169
findstr /i /c:"%n%" %temp%\ip_temp\net2.txt|findstr /i /b "���� Wireless" >nul||goto sc_yx
:sc_wx
echo                   ��ǰ������ʽ�� ���� & echo.
goto sc_info
:sc_yx
echo                   ��ǰ������ʽ�� ���� & echo.
goto sc_info
:sc_w1
echo MyVar=MsgBox(" ��������ȷ���֣�", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
call :c_404
goto sc_bj
:sc_info
echo        ------------------------------------------
echo.
if exist %temp%\ip_temp\*cn.txt goto sc_info_7cn
if exist %temp%\ip_temp\xp.txt goto sc_info_xp
goto sc_info_7en
:sc_info_xp
echo               �������        %COMPUTERNAME% & echo.
for /f "tokens=2 delims= " %%a in ('net config workstation^|findstr "����վ��"') do echo %%a>>%temp%\ip_temp\t1.txt
set /p u=<%temp%\ip_temp\t1.txt
del /q %temp%\ip_temp\t1.txt >nul 2>nul 
echo               ������/��       %u% & echo.
echo               ������          %n% & echo.
if exist %temp%\ip_temp\169.txt for /f "tokens=6 delims=: " %%a in ('findstr /i /c:"Autoconfiguration IP Address" %temp%\ip_temp\t2.txt') do set o=%%a && goto sc_info_xp_next
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"IP Address" %temp%\ip_temp\t2.txt') do set o=%%a
:sc_info_xp_next
echo               IP��ַ          %o% & echo.
set q=
for /f "tokens=12 delims=: " %%a in ('findstr /i /c:"Default Gateway" %temp%\ip_temp\t2.txt') do set q=%%a
echo               ����            %q% & echo.
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"Subnet Mask" %temp%\ip_temp\t2.txt') do set p=%%a
echo               ����            %p% & echo.
set r=
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"DNS Servers" %temp%\ip_temp\t2.txt') do set r=%%a
echo               ��ѡDNS         %r% & echo.
set s=
for /f %%a in ('findstr /v ":" %temp%\ip_temp\t2.txt') do set s=%%a
echo               ����DNS         %s% & echo.
findstr /i /c:"Dhcp Enabled. . . . . . . . . . . : Yes" %temp%\ip_temp\t2.txt>nul||echo               IP��Դ         �ֶ����� (��̬) && echo. && goto sc_xp_mac
echo               IP��Դ         �Զ���ȡ (��̬) & echo.
echo dhcp>%temp%\ip_temp\dhcp.txt
goto sc_xp_mac
:sc_xp_mac
for /f "tokens=2 delims=:" %%a in ('findstr /i /c:"Physical Address" %temp%\ip_temp\t2.txt') do set t=%%a
echo               MAC��ַ       %t%
goto sc_infoend
:sc_info_7cn
echo               �������        %COMPUTERNAME% & echo.
for /f "tokens=2 delims= " %%a in ('net config workstation^|findstr "����վ��"') do set u=%%a
echo               ������/��       %u% & echo.
echo               ������          %n% & echo.
if exist %temp%\ip_temp\169.txt for /f "tokens=11 delims=:( " %%a in ('findstr /i /c:"�Զ����� IPv4 ��ַ" %temp%\ip_temp\t2.txt') do set o=%%a && goto sc_info_7cn_next
for /f "tokens=15 delims=:( " %%a in ('findstr /i /c:"IPv4 ��ַ" %temp%\ip_temp\t2.txt') do set o=%%a
:sc_info_7cn_next
echo               IP��ַ          %o% & echo.
set q=
for /f "tokens=14 delims=: " %%a in ('findstr "Ĭ������" %temp%\ip_temp\t2.txt') do set q=%%a
echo               ����            %q% & echo.
for /f "tokens=14 delims=: " %%a in ('findstr "��������" %temp%\ip_temp\t2.txt') do set p=%%a
echo               ����            %p% & echo.
set r=
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"DNS ������" %temp%\ip_temp\t2.txt') do set r=%%a
echo               ��ѡDNS         %r% & echo.
set s=
for /f %%a in ('findstr /v ":" %temp%\ip_temp\t2.txt') do set s=%%a
echo               ����DNS         %s% & echo.
findstr /i /c:"DHCP ������ . . . . . . . . . . . : ��" %temp%\ip_temp\t2.txt>nul||echo               IP��Դ        �ֶ����� (��̬) && echo. && goto sc_7cn_mac
echo               IP��Դ        �Զ���ȡ (��̬)  & echo.
echo dhcp>%temp%\ip_temp\dhcp.txt
goto sc_7cn_mac
:sc_7cn_mac
for /f "tokens=14 delims=: " %%a in ('findstr /c:"�����ַ" %temp%\ip_temp\t2.txt') do set t=%%a
echo               MAC��ַ       %t%
goto sc_infoend
:sc_info_7en
echo               �������      %COMPUTERNAME% & echo.
for /f "tokens=3 delims= " %%a in ('net config workstation^|findstr /i /c:"Workstation domain"') do set u=%%a
echo               ������/��     %u% & echo.
echo               ������        %n% & echo.
if exist %temp%\ip_temp\169.txt for /f "tokens=6 delims=: " %%a in ('findstr /i /c:"Autoconfiguration IP Address" %temp%\ip_temp\t2.txt') do set o=%%a && goto sc_info_7en_next
for /f "tokens=13 delims=:( " %%a in ('findstr /i /c:"IPv4 Address" %temp%\ip_temp\t2.txt') do set o=%%a
:sc_info_7en_next
echo               IP��ַ        %o% & echo.
set q=
for /f "tokens=12 delims=: " %%a in ('findstr /i /c:"Default Gateway" %temp%\ip_temp\t2.txt') do set q=%%a
echo               ����          %q% & echo.
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"Subnet Mask" %temp%\ip_temp\t2.txt') do set p=%%a
echo               ����          %p% & echo.
for /f "tokens=14 delims=: " %%a in ('findstr /i /c:"DNS Servers" %temp%\ip_temp\t2.txt') do set r=%%a
echo               ��ѡDNS       %r% & echo.
for /f %%a in ('findstr /v ":" %temp%\ip_temp\t2.txt') do set s=%%a
echo               ����DNS       %s% & echo.
findstr /i /c:"DHCP Enabled. . . . . . . . . . . : Yes" %temp%\ip_temp\t2.txt>nul||echo               IP��Դ        �ֶ����� (��̬) && echo. && goto sc_7en_mac
echo               IP��Դ        �Զ���ȡ (��̬)  & echo.
echo dhcp>%temp%\ip_temp\dhcp.txt
goto sc_7en_mac
:sc_7en_mac
for /f "tokens=11 delims=: " %%a in ('findstr /i /c:"Physical Address" %temp%\ip_temp\t2.txt') do set t=%%a
echo               MAC��ַ       %t%
goto sc_infoend
:sc_infoend
echo.&echo.&echo.&echo.
if exist %temp%\ip_temp\dhcp.txt (echo             ��̬IP���豣�棬��������������أ� && pause >nul 2>nul && goto sc_top) else goto sc_jt
:sc_jt
set "name="
set/p name= �������Ʊ��棬�򰴻س����أ�
if "%name%"==" "  goto sc_w3
if not defined name goto sc_top
if exist "IP1.ini" del /q IP1.ini
call :c_ini
type %temp%\ip_temp\t5.txt>>IP1.ini
del /q %temp%\ip_temp\t5.txt >nul 2>nul
echo �л�����IP1��%name%��%o%>>IP1.ini
echo IP��%o%>>IP1.ini
echo �������룺%p%>>IP1.ini
echo ���أ�%q%>>IP1.ini
echo ��ѡDNS��%r%>>IP1.ini
echo ����DNS��%s%>>IP1.ini
goto sc_top
:sc_w3
echo MyVar=MsgBox(" ���Ʋ���Ϊ�ո����������룡", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
call :c_404
goto sc_bj
:sc_one
cls
if exist IP1.ini (goto sc_h1)  
echo.&echo.
set "name="
set/p name= ���� ����(��,ѧУ)�����س���
if "%name%"==" " goto sc_wip1
if not defined name goto sc_wip1
call :c_ini
type %temp%\ip_temp\t5.txt>>IP1.ini
del /q %temp%\ip_temp\t5.txt >nul 2>nul
echo.&echo.
set "ip="
set/p ip= ���� IP ���س���
if "%ip%"==" "  goto sc_wip1
if not defined ip goto sc_wip1
echo.&echo.
set "mask="
set/p mask= ���� �������� ���س���
if "%mask%"==" " goto sc_wip1
if not defined mask goto sc_wip1
echo �л�����IP1��%name%��%ip%>>IP1.ini
echo IP��%ip%>>IP1.ini
echo �������룺%mask%>>IP1.ini
echo.&echo.
set "gateway="
set/p gateway= ���� ���� ���س���
if "%gateway%"==" " goto sc_wip1
if not defined gateway goto sc_wip1
echo ���أ�%gateway%>>IP1.ini
echo.&echo.
set "dns="
set/p dns= ���� ��ѡDNS ���س���
if "%dns%"==" " goto sc_wip1
if not defined dns goto sc_wip1
echo ��ѡDNS��%dns%>>IP1.ini
echo.&echo.
set/p bdns= ���� ����DNS ���س���
if "%bdns%"==" " goto sc_wip1
echo ����DNS��%bdns%>>IP1.ini
echo.&echo.
goto sc_top
:sc_wip1
call :c_wip
del /q IP1.ini >nul 2>nul
goto sc_one
:sc_two
cls
if exist IP2.ini (goto sc_h2)
echo.&echo.
set "name2="
set/p name2= ���� ����(��,��λ)�����س���
if "%name2%"==" " goto sc_wip2
if not defined name2 goto sc_wip2
call :c_ini
type %temp%\ip_temp\t5.txt>>IP2.ini
del /q %temp%\ip_temp\t5.txt >nul 2>nul
echo.&echo.
set "ip2="
set/p ip2= ���� IP ���س���
if "%ip2%"==" " goto sc_wip2
if not defined ip2 goto sc_wip2
echo.&echo.
set "mask2="
set/p mask2= ���� �������� ���س���
if "%mask2%"==" " goto sc_wip2
if not defined mask2 goto sc_wip2
echo �л�����IP2��%name2%��%ip2%>>IP2.ini
echo IP��%ip2%>>IP2.ini
echo �������룺%mask2%>>IP2.ini
echo.&echo.
set "gateway2="
set/p gateway2= ���� ���� ���س���
if "%gateway2%"==" " goto sc_wip2
if not defined gateway2 goto sc_wip2
echo ���أ�%gateway2%>>IP2.ini
echo.&echo.
set "dns2="
set/p dns2= ���� ��ѡDNS ���س���
if "%dns2%"==" " goto sc_wip2
if not defined dns2 goto sc_wip2
echo ��ѡDNS��%dns2%>>IP2.ini
echo.&echo.
set/p bdns2= ���� ����DNS ���س���
if "%bdns2%"==" " goto sc_wip2
echo ����DNS��%bdns2%>>IP2.ini
echo.&echo.
goto sc_top
:sc_wip2
call :c_wip
del /q IP2.ini >nul 2>nul
goto sc_two
:sc_three
cls
if exist IP3.ini (goto sc_h3)  
echo.&echo.
set "name3="
set/p name3= ���� ����(��,�칫��)�����س���
if "%name3%"==" " goto sc_wip3
if not defined name3 goto sc_wip3
call :c_ini
type %temp%\ip_temp\t5.txt>>IP3.ini
del /q %temp%\ip_temp\t5.txt >nul 2>nul
echo.&echo.
set "ip3="
set/p ip3= ���� IP ���س���
if "%ip3%"==" " goto sc_wip3
if not defined ip3 goto sc_wip3
echo.&echo.
set "mask3="
set/p mask3= ���� �������� ���س���
if "%mask3%"==" " goto sc_wip3
if not defined mask3 goto sc_wip3
echo �л�����IP3��%name3%��%ip3%>>IP3.ini
echo IP��%ip3%>>IP3.ini
echo �������룺%mask3%>>IP3.ini
echo.&echo.
set "gateway3="
set/p gateway3= ���� ���� ���س���
if "%gateway3%"==" " goto sc_wip3
if not defined gateway3 goto sc_wip3
echo ���أ�%gateway3%>>IP3.ini
echo.&echo.
set "dns3="
set/p dns3= ���� ��ѡDNS ���س���
if "%dns3%"==" " goto sc_wip3
if not defined dns3 goto sc_wip3
echo ��ѡDNS��%dns3%>>IP3.ini
echo.&echo.
set/p bdns3= ���� ����DNS ���س���
if "%bdns3%"==" " goto sc_wip3
echo ����DNS��%bdns3%>>IP3.ini
echo.&echo.
goto sc_top
:sc_wip3
call :c_wip
del /q IP3.ini >nul 2>nul
goto sc_three
:sc_four
cls
if exist IP4.ini (goto sc_h4)  
echo.&echo.
set "name4="
set/p name4= ���� ����(��,����) ���س���
if "%name4%"==" " goto sc_wip4
if not defined name4 goto sc_wip4
call :c_ini
type %temp%\ip_temp\t5.txt>>IP4.ini
del /q %temp%\ip_temp\t5.txt >nul 2>nul
echo.&echo.
set "ip4="
set/p ip4= ���� IP ���س���
if "%ip4%"==" " goto sc_wip4
if not defined ip4 goto sc_wip4
echo.&echo.
set "mask4="
set/p mask4= ���� �������� ���س���
if "%mask4%"==" " goto sc_wip4
if not defined mask4 goto sc_wip4
echo �л�����IP4��%name4%��%ip4%>>IP4.ini
echo IP��%ip4%>>IP4.ini
echo �������룺%mask4%>>IP4.ini
echo.&echo.
set "gateway4="
set/p gateway4= ���� ���� ���س���
if "%gateway4%"==" " goto sc_wip4
if not defined gateway4 goto sc_wip4
echo ���أ�%gateway4%>>IP4.ini
echo.&echo.
set "dns4="
set/p dns4= ���� ��ѡDNS ���س���
if "%dns4%"==" " goto sc_wip4
if not defined dns4 goto sc_wip4
echo ��ѡDNS��%dns4%>>IP4.ini
echo.&echo.
set/p bdns4= ���� ����DNS ���س���
if "%bdns4%"==" " goto sc_wip4
echo ����DNS��%bdns4%>>IP4.ini
echo.&echo.
goto sc_top
:sc_wip4
call :c_wip
del /q IP4.ini >nul 2>nul
goto sc_four
:sc_h1
cls
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_h1_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_h1_next
call :c_info
if exist %temp%\ip_temp\xp.txt goto sc_h1_xp
:sc_h1_7
call :c_h1
Netsh interface IP Set Address "%n%" Static %ip% %mask% %gateway% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns% validate=no >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns% validate=no >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h1_xp
call :c_qhxptip
call :c_h1
Netsh interface IP Set Address "%n%" Static %ip% %mask% %gateway% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns% >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns% >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h2
cls
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_h2_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_h2_next
call :c_info
if exist %temp%\ip_temp\xp.txt goto sc_h2_xp
:sc_h2_7
call :c_h2
Netsh interface IP Set Address "%n%" Static %ip2% %mask2% %gateway2% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns2% validate=no >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns2% validate=no >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h2_xp
call :c_qhxptip
call :c_h2
Netsh interface IP Set Address "%n%" Static %ip2% %mask2% %gateway2% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns2% >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns2% >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h3
cls
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_h3_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_h3_next
call :c_info
if exist %temp%\ip_temp\xp.txt goto sc_h3_xp
:sc_h3_7
call :c_h3
Netsh interface IP Set Address "%n%" Static %ip3% %mask3% %gateway3% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns3% validate=no >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns3% validate=no >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h3_xp
call :c_qhxptip
call :c_h3
Netsh interface IP Set Address "%n%" Static %ip3% %mask3% %gateway3% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns3% >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns3% >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h4
cls
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_h4_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_h4_next
call :c_info
if exist %temp%\ip_temp\xp.txt goto sc_h4_xp
:sc_h4_7
call :c_h4
Netsh interface IP Set Address "%n%" Static %ip4% %mask4% %gateway4% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns4% validate=no >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns4% validate=no >nul 2>nul
call :c_qhtip
goto sc_top
:sc_h4_xp
call :c_qhxptip
call :c_h4
Netsh interface IP Set Address "%n%" Static %ip4% %mask4% %gateway4% 1 >nul 2>nul
Netsh interface IP Set DNS "%n%" Static %dns4% >nul 2>nul
Netsh interface IP add DNS "%n%" %bdns4% >nul 2>nul
call :c_qhtip
goto sc_top
:sc_dhcp
cls
if exist %temp%\ip_temp\none.txt call :c_woff & goto sc_top
findstr "2��" %temp%\ip_temp\net.txt>nul && call :c_net && goto sc_dhcp_next
for /f "tokens=2 delims=��" %%a in (%temp%\ip_temp\net.txt) do set n=%%a
:sc_dhcp_next
call :c_info
if exist %temp%\ip_temp\xp.txt goto sc_dxp
:sc_d7
netsh interface IP Set Address "%n%" dhcp >nul 2>nul
netsh interface ip set dns "%n%" dhcp validate=no >nul 2>nul
call :c_qhtip
goto sc_top
:sc_dxp
call :c_qhxptip
netsh interface IP Set Address "%n%" dhcp >nul 2>nul
netsh interface ip set dns "%n%" dhcp >nul 2>nul
ipconfig /renew "%n%" >nul 2>nul
call :c_qhtip
goto sc_top
:sc_gmenu
cls
echo.&echo.&echo.&echo.
echo                   �޸��ѱ����IP����
echo. 
echo       --------------------------------------------
echo.&echo.
if exist IP1.ini (
for /f "tokens=2 delims=��" %%a in ('findstr "�л���" IP1.ini') do echo              1.�޸�: %%a & echo.
) else (
echo              1.�������� IP1����ѡ� & echo.
)
if exist IP2.ini (
for /f "tokens=2 delims=��" %%a in ('findstr "�л���" IP2.ini') do echo              2.�޸�: %%a & echo.
) else (
echo              2.�������� IP2����ѡ� & echo.
)
if exist IP3.ini (
for /f "tokens=2 delims=��" %%a in ('findstr "�л���" IP3.ini') do echo              3.�޸�: %%a & echo.
) else (
echo              3.�������� IP3����ѡ� & echo.
)
if exist IP4.ini (
for /f "tokens=2 delims=��" %%a in ('findstr "�л���" IP4.ini') do echo              4.�޸�: %%a & echo.
) else (
echo              4.�������� IP4����ѡ� & echo.
)
echo              5.ɾ��ȫ�� IP ���� & echo.
echo              6.�������˵� & echo.
echo              7.�˳� & echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
set str2=1234567
set "num="
set/p num= �������֣����س���
if not defined num goto sc_w2
echo %num%|findstr "[%str2%]">nul||goto sc_w2
if "%num%"=="1" goto sc_g1 
if "%num%"=="2" goto sc_g2
if "%num%"=="3" goto sc_g3
if "%num%"=="4" goto sc_g4
if "%num%"=="5" (
del /q IP?.ini >nul 2>nul
goto sc_top
) 
if "%num%"=="6" goto sc_top
if "%num%"=="7" goto sc_exit
:sc_w2
echo MyVar=MsgBox(" ��������1-7֮������֣�", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
call :c_404
goto sc_gmenu
:sc_g1
cls
if exist IP1.ini (
call :c_xgtip
start /w notepad IP1.ini
goto sc_gmenu
) else (
goto sc_one
)
:sc_g2
cls
if exist IP2.ini (
call :c_xgtip
start /w notepad IP2.ini
goto sc_gmenu
) else (
goto sc_two
)
:sc_g3
cls
if exist IP3.ini (
call :c_xgtip
start /w notepad IP3.ini
goto sc_gmenu
) else (
goto sc_three
)
:sc_g4
cls
if exist IP4.ini (
call :c_xgtip
start /w notepad IP4.ini
goto sc_gmenu
) else (
goto sc_four
)
:sc_exit
cls
rd /s /q %temp%\ip_temp >nul 2>nul
exit
goto :eof
:c_net
cls
echo.
echo                     ��ѡ������������
echo.
echo       --------------------------------------------
type %temp%\ip_temp\net.txt
if exist %temp%\ip_temp\7en.txt (echo      0������) else echo                    0������
echo.
set "select="
set/p select= �������֣����س� :
if not defined select goto sc_w1
if "%select%"=="0" (goto sc_top)
findstr /c:"!select!��" %temp%\ip_temp\net.txt>nul||goto sc_w1
for /f "tokens=2 delims=��" %%a in ('findstr /c:"!select!��" %temp%\ip_temp\net.txt') do set n=%%a
cls
goto :eof
:c_info
for /f "tokens=1 delims=:" %%a in ('findstr /n /i /e /c:"!n!:" %temp%\ip_temp\t.txt') do set w=%%a
if exist %temp%\ip_temp\*cn.txt (for /f "tokens=1,* delims=:" %%a in ('findstr /n . %temp%\ip_temp\t.txt') do if %%a gtr %w% echo %%b>>%temp%\ip_temp\t2.txt & findstr /i /b "��̫�� ���� ��� ppp" %temp%\ip_temp\t2.txt>nul && goto sc_stop)
if not exist %temp%\ip_temp\*cn.txt (for /f "tokens=1,* delims=:" %%a in ('findstr /n . %temp%\ip_temp\t.txt') do if %%a gtr %w% echo %%b>>%temp%\ip_temp\t2.txt & findstr /i /b "Ethernet Wireless Tunnel ppp" %temp%\ip_temp\t2.txt>nul && goto sc_stop)
:sc_stop
if exist %temp%\ip_temp\*cn.txt (findstr /c:"ý���ѶϿ�" %temp%\ip_temp\t2.txt>nul||goto sc_end) else (findstr /i /c:"Media disconnected" %temp%\ip_temp\t2.txt>nul||goto sc_end)
cls
echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
echo                   �� ǰ �� �� �� �� ��
echo.&echo.
echo                  �� �� �� �� �� �� �� ��
echo.&echo.
echo                   �� ѡ �� �� �� �� ��
echo.&echo.&echo.
echo       --------------------------------------------
echo.&echo.&echo.&echo.&echo.&echo.
echo                     ���������������..
pause >nul 2>nul
goto sc_top
:sc_end
findstr /c:": 169.254." %temp%\ip_temp\t2.txt>nul && echo 169>%temp%\ip_temp\169.txt
goto :eof
:c_xgtip
cls
echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
echo                        �����޸�...
echo.&echo.&echo.
goto :eof
:c_qhxptip
echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
echo                        �����л�...
echo.&echo.&echo.
goto :eof
:c_qhtip
cls
echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
echo                      OK �л��ɹ���
echo.&echo.&echo.
rd /s /q %temp%\ip_temp >nul 2>nul
ping -n 2 127.0.0.1>nul
goto :eof
:c_wip
echo MyVar=MsgBox(" ����������ȷ���ַ���", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
start /w %temp%\ip_temp\404.vbs
del /q %temp%\ip_temp\404.vbs >nul 2>nul
goto :eof
:c_h1
for /f "tokens=2 delims=��" %%a in ('findstr /i "IP��" IP1.ini') do set ip=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "�������룺" IP1.ini') do set mask=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "���أ�" IP1.ini') do set gateway=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "��ѡDNS��" IP1.ini') do set dns=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "����DNS��" IP1.ini') do set bdns=%%a
goto :eof
:c_h2
for /f "tokens=2 delims=��" %%a in ('findstr /i "IP��" IP2.ini') do set ip2=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "�������룺" IP2.ini') do set mask2=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "���أ�" IP2.ini') do set gateway2=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "��ѡDNS��" IP2.ini') do set dns2=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "����DNS��" IP2.ini') do set bdns2=%%a
goto :eof
:c_h3
for /f "tokens=2 delims=��" %%a in ('findstr /i "IP��" IP3.ini') do set ip3=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "�������룺" IP3.ini') do set mask3=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "���أ�" IP3.ini') do set gateway3=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "��ѡDNS��" IP3.ini') do set dns3=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "����DNS��" IP3.ini') do set bdns3=%%a
goto :eof
:c_h4
for /f "tokens=2 delims=��" %%a in ('findstr /i "IP��" IP4.ini') do set ip4=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "�������룺" IP4.ini') do set mask4=%%a
for /f "tokens=2 delims=��" %%a in ('findstr "���أ�" IP4.ini') do set gateway4=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "��ѡDNS��" IP4.ini') do set dns4=%%a
for /f "tokens=2 delims=��" %%a in ('findstr /i "����DNS��" IP4.ini') do set bdns4=%%a
goto :eof
:c_ini
echo [ ������Ϣ ]>>%temp%\ip_temp\t5.txt
echo --------------------------------------------------------------->>%temp%\ip_temp\t5.txt
goto :eof
:c_woff
echo MyVar=MsgBox("   ����δ���ӣ� ���飺"^&chr(13)^&chr(13)^&"   �����Ƿ�Ӻã�"^&chr(13)^&"   �����Ƿ����ã�", vbSystemModal, "����")>%temp%\ip_temp\404.vbs
start /w %temp%\ip_temp\404.vbs
del /q %temp%\ip_temp\404.vbs >nul 2>nul
goto :eof
:c_169
echo MyVar=MsgBox(" �Զ���ȡIP�����������л���", vbSystemModal, "��ʾ")>%temp%\ip_temp\404.vbs
start /w %temp%\ip_temp\404.vbs
del /q %temp%\ip_temp\404.vbs >nul 2>nul
goto :eof
:c_404
start /w %temp%\ip_temp\404.vbs
del /q %temp%\ip_temp\404.vbs >nul 2>nul
goto :eof
