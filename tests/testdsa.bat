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

:: Test DSA certificate generation of openssl

set openssl_bin=%1
set openssl_bin=%openssl_bin:/=\%
if not exist %openssl_bin% exit /b 1

REM # Generate DSA paramter set
%openssl_bin% dsaparam 512 -out dsa512.pem
if !errorlevel! neq 0 (
	exit /b 1
)


REM # Generate a DSA certificate
%openssl_bin% req -config %srcdir%\openssl.cnf -x509 -newkey dsa:dsa512.pem -out testdsa.pem -keyout testdsa.key
if !errorlevel! neq 0 (
	exit /b 1
)


REM # Now check the certificate
%openssl_bin% x509 -text -in testdsa.pem
if !errorlevel! neq 0 (
	exit /b 1
)

del testdsa.key dsa512.pem testdsa.pem

exit /b 0
endlocal
