@echo off
echo.
echo ========================================
echo  HHMS Application - Pre-Debug Check
echo ========================================
echo.

echo Checking project readiness for Visual Studio debugging...
echo.

REM Check if we're in the right directory
if not exist "HHMS_Application.csproj" (
    echo [ERROR] Not in project directory. Please run this from the project root.
    echo Expected: HHMS_Application.csproj
    goto :error
)

echo [OK] Project file found
echo.

REM Check .NET SDK
echo Checking .NET SDK...
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] .NET SDK not found. Please install .NET 6.0 SDK.
    echo Download from: https://dotnet.microsoft.com/download/dotnet/6.0
    goto :error
)

for /f "tokens=1" %%i in ('dotnet --version') do set DOTNET_VERSION=%%i
echo [OK] .NET SDK: %DOTNET_VERSION%
echo.

REM Restore packages
echo Restoring NuGet packages...
dotnet restore --verbosity quiet
if %errorlevel% neq 0 (
    echo [ERROR] Package restore failed.
    echo Try running: dotnet restore
    goto :error
)
echo [OK] Packages restored
echo.

REM Build project
echo Building project in Debug configuration...
dotnet build --configuration Debug --verbosity minimal
if %errorlevel% neq 0 (
    echo [ERROR] Build failed. Please fix build errors before debugging.
    echo.
    echo Common solutions:
    echo - Check that all required packages are installed
    echo - Ensure WebView2 runtime is installed
    echo - Verify .NET 6.0 Windows Desktop runtime is installed
    echo.
    goto :error
)
echo [OK] Build successful
echo.

REM Check if executable exists
if exist "bin\Debug\net6.0-windows\HHMS_Application.exe" (
    echo [OK] Debug executable found: bin\Debug\net6.0-windows\HHMS_Application.exe
) else (
    echo [WARNING] Debug executable not found at expected location
    echo Looking for alternative locations...
    
    for /r bin\Debug %%f in (HHMS_Application.exe) do (
        if exist "%%f" (
            echo [OK] Found executable: %%f
            goto :exe_found
        )
    )
    
    echo [ERROR] Debug executable not found after successful build
    echo This may indicate a configuration issue.
    goto :error
)

:exe_found
echo.
echo ========================================
echo PRE-DEBUG CHECK: PASSED
echo ========================================
echo.
echo ✓ Project file found
echo ✓ .NET SDK available  
echo ✓ Packages restored
echo ✓ Build successful
echo ✓ Debug executable ready
echo.
echo You can now debug in Visual Studio:
echo 1. Open HHMS_Application.sln
echo 2. Set Configuration to 'Debug'
echo 3. Press F5 to start debugging
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo PRE-DEBUG CHECK: FAILED
echo ========================================
echo.
echo The project is not ready for debugging.
echo Please fix the errors above before trying to debug.
echo.
echo For help, see:
echo - TROUBLESHOOTING_VISUAL_STUDIO.md
echo - DEBUG_GUIDE.md
echo.
pause
exit /b 1