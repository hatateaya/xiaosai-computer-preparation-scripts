@echo off

path C:\Windows;C:\Windows\System32;%path%

set "vsix_count=0"

for %%f in ("*.vsix") do (
    set /a vsix_count+=1
    echo installing "%%f"
    codium\bin\codium.cmd --install-extension %%f
)

if %vsix_count% equ 0 (
    echo finding zero vsix files!
    pause
)