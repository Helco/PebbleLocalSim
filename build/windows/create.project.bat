@echo off
REM Variables
set PLS_INST_FROM=%~dp0
set PLS_ROBOCOPY_SILENT=/NJH /NJS /NP /NFL /NDL /NS /NC

REM command-line parsing
if "%1"=="" (
	echo Usage: create.project.bat project_name
	goto exit
)	

set PLS_INST_TO=.\%1\
if exist %PLS_INST_TO%\pebble_app.ld (
	echo The project %1 already exists
	goto exit
) 

REM Copy the project
robocopy %PLS_INST_FROM%\sampleProject %PLS_INST_TO% %PLS_ROBOCOPY_SILENT% /E >NUL
rename %PLS_INST_TO%\src\sampleProject.c %1.c
echo %1> %PLS_INST_TO%\pebble_app.ld

REM Generate envvars.bat
echo @echo off > %PLS_INST_TO%\tools\envvars.bat
echo REM This file is generated by create.project.bat >> %PLS_INST_TO%\tools\envvars.bat
echo REM DO NOT MODIFY UNLESS YOU KNOW WHAT YOU DO >> %PLS_INST_TO%\tools\envvars.bat
echo set PLS_SDK_PATH=%PLS_INST_FROM%>> %PLS_INST_TO%\tools\envvars.bat
echo call %PLS_INST_FROM%envvars.bat >> %PLS_INST_TO%\tools\envvars.bat

REM Print friendly message
echo You created the project "%1"
echo Now you can run:
echo     cd %1
echo     .\tools\build.local.bat
echo     .\tools\run.local.bat

:exit