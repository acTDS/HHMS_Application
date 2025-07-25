# HHMS Application - Pre-Debug Check (PowerShell)
# Ensures project is ready for Visual Studio debugging

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " HHMS Application - Pre-Debug Check" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$errors = 0

# Check if we're in the right directory
if (-not (Test-Path "HHMS_Application.csproj")) {
    Write-Host "[ERROR] Not in project directory. Please run this from the project root." -ForegroundColor Red
    Write-Host "Expected: HHMS_Application.csproj" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Project file found" -ForegroundColor Green
Write-Host ""

# Check .NET SDK
Write-Host "Checking .NET SDK..." -ForegroundColor Cyan
try {
    $dotnetVersion = & dotnet --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] .NET SDK: $dotnetVersion" -ForegroundColor Green
        
        $majorVersion = [int]($dotnetVersion.Split('.')[0])
        if ($majorVersion -lt 6) {
            Write-Host "[WARNING] .NET 6.0+ recommended for this project" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[ERROR] .NET SDK not found. Please install .NET 6.0 SDK." -ForegroundColor Red
        Write-Host "Download from: https://dotnet.microsoft.com/download/dotnet/6.0" -ForegroundColor Yellow
        $errors++
    }
} catch {
    Write-Host "[ERROR] .NET SDK not available in PATH" -ForegroundColor Red
    $errors++
}

Write-Host ""

# Restore packages
Write-Host "Restoring NuGet packages..." -ForegroundColor Cyan
try {
    $restoreOutput = & dotnet restore --verbosity quiet 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Packages restored" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Package restore failed." -ForegroundColor Red
        Write-Host "Try running: dotnet restore" -ForegroundColor Yellow
        $errors++
    }
} catch {
    Write-Host "[ERROR] Failed to run package restore" -ForegroundColor Red
    $errors++
}

Write-Host ""

# Build project
Write-Host "Building project in Debug configuration..." -ForegroundColor Cyan
try {
    $buildOutput = & dotnet build --configuration Debug --verbosity minimal 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Build successful" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Build failed. Please fix build errors before debugging." -ForegroundColor Red
        Write-Host ""
        Write-Host "Common solutions:" -ForegroundColor Yellow
        Write-Host "- Check that all required packages are installed" -ForegroundColor White
        Write-Host "- Ensure WebView2 runtime is installed" -ForegroundColor White
        Write-Host "- Verify .NET 6.0 Windows Desktop runtime is installed" -ForegroundColor White
        Write-Host ""
        $errors++
    }
} catch {
    Write-Host "[ERROR] Failed to build project" -ForegroundColor Red
    $errors++
}

Write-Host ""

# Check if executable exists
$exePath = "bin\Debug\net6.0-windows\HHMS_Application.exe"
if (Test-Path $exePath) {
    Write-Host "[OK] Debug executable found: $exePath" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Debug executable not found at expected location" -ForegroundColor Yellow
    Write-Host "Looking for alternative locations..." -ForegroundColor Cyan
    
    $found = $false
    Get-ChildItem -Path "bin\Debug" -Recurse -Name "HHMS_Application.exe" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "[OK] Found executable: bin\Debug\$_" -ForegroundColor Green
        $found = $true
    }
    
    if (-not $found) {
        Write-Host "[ERROR] Debug executable not found after successful build" -ForegroundColor Red
        Write-Host "This may indicate a configuration issue." -ForegroundColor Red
        $errors++
    }
}

Write-Host ""

if ($errors -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "PRE-DEBUG CHECK: PASSED" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "✓ Project file found" -ForegroundColor Green
    Write-Host "✓ .NET SDK available" -ForegroundColor Green
    Write-Host "✓ Packages restored" -ForegroundColor Green
    Write-Host "✓ Build successful" -ForegroundColor Green
    Write-Host "✓ Debug executable ready" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now debug in Visual Studio:" -ForegroundColor Cyan
    Write-Host "1. Open HHMS_Application.sln" -ForegroundColor White
    Write-Host "2. Set Configuration to 'Debug'" -ForegroundColor White
    Write-Host "3. Press F5 to start debugging" -ForegroundColor White
    Write-Host ""
    exit 0
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "PRE-DEBUG CHECK: FAILED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "The project is not ready for debugging." -ForegroundColor Red
    Write-Host "Please fix the errors above before trying to debug." -ForegroundColor Red
    Write-Host ""
    Write-Host "For help, see:" -ForegroundColor Cyan
    Write-Host "- TROUBLESHOOTING_VISUAL_STUDIO.md" -ForegroundColor White
    Write-Host "- DEBUG_GUIDE.md" -ForegroundColor White
    Write-Host ""
    exit 1
}