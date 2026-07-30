@echo off
setlocal

:: Copyright (c) 2026 Kenjiro Nakayama
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

if "%~1" == "" exit /b 1

set "ssl_verify_bin=%~1"
set "ssl_verify_bin=%ssl_verify_bin:/=\%"
if not exist "%ssl_verify_bin%" exit /b 1

if not defined srcdir set "srcdir=."
if not defined PERL set "PERL=perl"

set "workdir=ssl_verify-certs"
if exist "%workdir%" rmdir /s /q "%workdir%"
mkdir "%workdir%" || exit /b 1
pushd "%workdir%" || exit /b 1

set "status=1"
"%PERL%" "%srcdir%/create-libressl-test-certs.pl"
if errorlevel 1 goto cleanup

"%ssl_verify_bin%"
set "status=%errorlevel%"

:cleanup
popd
rmdir /s /q "%workdir%"
exit /b %status%
