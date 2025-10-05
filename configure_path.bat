@echo off

set "path_parts_1=mingw\bin"
set "path_parts_2=jdk\bin"
set "path_parts_3=pypy"
set "path_parts_4=codium\bin"
set "path_parts_5=clangd\bin"

set "baseDir=%cd%"

set "full_path_1=%baseDir%\%path_parts_1%"
set "full_path_2=%baseDir%\%path_parts_2%"
set "full_path_3=%baseDir%\%path_parts_3%"
set "full_path_4=%baseDir%\%path_parts_4%"
set "full_path_4=%baseDir%\%path_parts_5%"

:: Fuck M$
set "final_path_value=%full_path_1%;%full_path_2%;%full_path_3%;%full_path_4%;%full_path_5%;%PATH%"

C:\Windows\System32\setx.exe PATH "%final_path_value%"