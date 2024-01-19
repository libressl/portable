@echo off
setlocal enabledelayedexpansion
REM	shutdowntest.bat

set shutdowntest_bin=%1
set shutdowntest_bin=%shutdowntest_bin:/=\%
if not exist %shutdowntest_bin% exit /b 1

%shutdowntest_bin% %srcdir%\server.pem %srcdir%\server.pem %srcdir%\ca.pem
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
