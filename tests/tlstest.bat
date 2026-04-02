@echo off
setlocal enabledelayedexpansion
REM	tlstest.bat

set tlstest_bin=%1
set tlstest_bin=%tlstest_bin:/=\%
if not exist %tlstest_bin% exit /b 1

%tlstest_bin% %srcdir%\ca-root-rsa.pem %srcdir%\server1-rsa-chain.pem %srcdir%\server1-rsa.pem
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
