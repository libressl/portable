@echo off
setlocal enabledelayedexpansion
REM	quictest.bat

set quictest_bin=%1
set quictest_bin=%quictest_bin:/=\%
if not exist %quictest_bin% exit /b 1

%quictest_bin% %srcdir%\server1-rsa.pem %srcdir%\server1-rsa-chain.pem %srcdir%\ca-root-rsa.pem
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
