@echo off
setlocal enabledelayedexpansion
REM	shutdowntest.bat

set shutdowntest_bin=%1
set shutdowntest_bin=%shutdowntest_bin:/=\%
if not exist %shutdowntest_bin% exit /b 1

%shutdowntest_bin% %srcdir%\server1-rsa.pem %srcdir%\server1-rsa-chain.pem %srcdir%\ca-root-rsa.pem
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
