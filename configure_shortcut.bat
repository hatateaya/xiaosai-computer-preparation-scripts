@echo off

path C:\Windows;C:\Windows\System32;%path%

(echo Set oWS = WScript.CreateObject("WScript.Shell"^)
 echo sLinkFile = oWS.SpecialFolders("Desktop"^) ^& "\VSCodium.lnk"
 echo Set oLink = oWS.CreateShortcut(sLinkFile^)
 echo oLink.TargetPath = "%CD%\codium\VSCodium.exe"
 echo oLink.Arguments = "C:\Users\Default\Desktop"
 echo oLink.Save) > "%TEMP%\create_shortcut.vbs"
cscript /nologo "%TEMP%\create_shortcut.vbs"
del "%TEMP%\create_shortcut.vbs"