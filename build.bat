@echo off
setlocal
set "VENDOR_WINDOWS_ARCH=%VSCMD_ARG_TGT_ARCH%"
if not defined VENDOR_WINDOWS_ARCH set "VENDOR_WINDOWS_ARCH=%PROCESSOR_ARCHITECTURE%"
if /I "%VENDOR_WINDOWS_ARCH%"=="AMD64" set "VENDOR_WINDOWS_ARCH=x64"
if /I "%VENDOR_WINDOWS_ARCH%"=="ARM64" set "VENDOR_WINDOWS_ARCH=arm64"
set "CMAKE_ARCH=%VENDOR_WINDOWS_ARCH%"
if /I "%CMAKE_ARCH%"=="arm64" set "CMAKE_ARCH=ARM64"
cd /d "%~dp0"
set "OUTPUT=windows_%VENDOR_WINDOWS_ARCH%"
set "BUILD=build\%OUTPUT%"
cmake -A %CMAKE_ARCH% -S . -B "%BUILD%" -DBUILD_SHARED_LIBS=ON -DBUILD_PORTMIDI_TESTS=OFF -DBUILD_JAVA_NATIVE_INTERFACE=OFF || exit /b 1
cmake --build "%BUILD%" --config Release --target portmidi --parallel || exit /b 1
if not exist "%OUTPUT%" mkdir "%OUTPUT%"
copy /y "%BUILD%\Release\portmidi.dll" "%OUTPUT%\portmidi.dll" || exit /b 1
copy /y "%BUILD%\Release\portmidi.lib" "%OUTPUT%\portmidi.lib" || exit /b 1
