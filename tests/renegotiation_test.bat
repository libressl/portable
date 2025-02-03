@echo off
setlocal enabledelayedexpansion
REM	renegotiation_test.bat

set renegotiation_test_bin=%1
set renegotiation_test_bin=%renegotiation_test_bin:/=\%
if not exist %renegotiation_test_bin% exit /b 1

%renegotiation_test_bin% %srcdir%\server1-rsa.pem %srcdir%\server1-rsa-chain.pem %srcdir%\ca-root-rsa.pem
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
