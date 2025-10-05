@echo off

path C:\Windows;C:\Windows\System32;%path%

:: TODO !!! PLS SET IT

set "OJIP=!!!.!!!.!!!.!!!"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo admin privilege needed!
    pause
    exit
)

sc query MpsSvc | findstr "RUNNING" >nul
if %errorlevel% neq 0 (
    echo firewall service running needed!
    pause
    exit
)

:: Fuck M$
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile /v EnableFirewall /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile /v EnableFirewall /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile /v EnableFirewall /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile /v EnableFirewall /t REG_DWORD /d 1 /f
gpupdate /force

set "ruleName=AntiCheat"

:: TODO !!! PLS SET IT

set "allowedIPs=%OJIP%,YYY.YYY.YYY.YYY,ZZZ.ZZZ.ZZZ.ZZZ"

netsh advfirewall firewall delete rule name="%ruleName%1"
netsh advfirewall firewall delete rule name="%ruleName%2"
netsh advfirewall firewall delete rule name="%ruleName%3"

netsh advfirewall firewall add rule name="%ruleName%1" dir=out action=allow remoteip=%allowedIPs% protocol=any
netsh advfirewall firewall add rule name="%ruleName%2" dir=in action=allow remoteip=any protocol=any program="C:\3000soft\Red Spider\REDAgent.exe"
netsh advfirewall firewall add rule name="%ruleName%3" dir=out action=allow remoteip=any protocol=any program="C:\3000soft\Red Spider\REDAgent.exe"

echo firewall rule added.

netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

if %errorlevel% neq 0 (
    echo failed to enable firewall!
    pause
    exit
)
