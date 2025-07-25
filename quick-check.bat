@echo off
echo =====================================
echo   HHMS Application Quick Check
echo =====================================
echo.

echo Checking .NET SDK...
dotnet --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] .NET SDK is installed
    dotnet --version
) else (
    echo [✗] .NET SDK is NOT installed
    echo     Download from: https://dotnet.microsoft.com/download/dotnet/6.0
)

echo.
echo Checking Visual Studio...
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\*\Common7\IDE\devenv.exe" (
    echo [✓] Visual Studio 2022 is installed
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\*\Common7\IDE\devenv.exe" (
    echo [✓] Visual Studio 2022 is installed
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\*\Common7\IDE\devenv.exe" (
    echo [⚠] Visual Studio 2019 found (2022 recommended)
) else (
    echo [✗] Visual Studio is NOT installed
    echo     Download from: https://visualstudio.microsoft.com/
)

echo.
echo To run detailed system check, execute:
echo powershell -ExecutionPolicy Bypass -File check-system-requirements.ps1
echo.

echo For setup instructions, see:
echo - HUONG_DAN_VISUAL_STUDIO.md (Vietnamese)
echo - README_VISUAL_STUDIO.md (English)
echo.

pause