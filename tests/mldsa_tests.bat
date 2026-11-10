@echo off
setlocal enabledelayedexpansion

:: Copyright (c) 2025,2026 Theo Beuhler
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

set mlkem_tests_bin=%1
set mlkem_tests_bin=%mlkem_tests_bin:/=\%
if not exist %mlkem_tests_bin% exit /b 1

%mlkem_tests_bin% mldsa44_nist_keygen_tests	%srcdir%\mldsa44_nist_keygen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)
%mlkem_tests_bin% mldsa44_nist_siggen_tests	%srcdir%\mldsa44_nist_siggen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)
%mlkem_tests_bin% mldsa65_nist_keygen_tests	%srcdir%\mldsa65_nist_keygen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)
%mlkem_tests_bin% mldsa65_nist_siggen_tests	%srcdir%\mldsa65_nist_siggen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)
%mlkem_tests_bin% mldsa87_nist_keygen_tests	%srcdir%\mldsa87_nist_keygen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)
%mlkem_tests_bin% mldsa87_nist_siggen_tests	%srcdir%\mldsa87_nist_siggen_tests.txt
if !errorlevel! neq 0 (
	exit /b 1
)

endlocal
