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

set ocsp_test_bin=%1
set ocsp_test_bin=%ocsp_test_bin:/=\%
if not exist %ocsp_test_bin% exit /b 1

%ocsp_test_bin% www.amazon.com 443 & if !errorlevel! neq 0 exit /b 1
%ocsp_test_bin% cloudflare.com 443 & if !errorlevel! neq 0 exit /b 1

endlocal
