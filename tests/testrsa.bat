@echo off
setlocal enabledelayedexpansion

:: Copyright (c) 2016 Kinichiro Inoguchi
::
:: Permission to use, copy, modify, and distribute this software for any
:: purpose with or without fee is hereby granted, provided that the above
:: copyright notice and this permission notice appear in all copies.
::
:: THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
:: WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
:: MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
:: ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
:: WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
:: ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
:: OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

:: Test RSA certificate generation of openssl

set openssl_bin=%1
set openssl_bin=%openssl_bin:/=\%
if not exist %openssl_bin% exit /b 1

REM # Generate RSA private key
%openssl_bin% genrsa -out rsakey.pem
if !errorlevel! neq 0 (
	exit /b 1
)


REM # Generate an RSA certificate
%openssl_bin% req -config %srcdir%\openssl.cnf -key rsakey.pem -new -x509 -days 365 -out rsacert.pem
if !errorlevel! neq 0 (
	exit /b 1
)


REM # Now check the certificate
%openssl_bin% x509 -text -in rsacert.pem
if !errorlevel! neq 0 (
	exit /b 1
)

del rsacert.pem rsakey.pem

exit /b 0
endlocal
