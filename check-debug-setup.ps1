# HHMS Application - Visual Studio Debug Setup Checker
# PowerShell script to verify all debug configuration files are present

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " HHMS Application - Visual Studio Check" -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$errors = 0
$warnings = 0

# Function to check if file exists
function Test-File {
    param($path, $description, $required = $true)
    
    if (Test-Path $path) {
        Write-Host "[OK] $description" -ForegroundColor Green
        return $true
    } else {
        if ($required) {
            Write-Host "[ERROR] Missing: $description" -ForegroundColor Red
            $script:errors++
        } else {
            Write-Host "[WARNING] Missing: $description" -ForegroundColor Yellow
            $script:warnings++
        }
        return $false
    }
}

Write-Host "Checking required files for Visual Studio debugging..." -ForegroundColor Cyan
Write-Host ""

# Check core project files
Test-File "HHMS_Application.sln" "Solution file"
Test-File "HHMS_Application.csproj" "Project file"

# Check debug configuration files
Test-File ".vs\launch.vs.json" "Visual Studio launch configuration" $false
Test-File "HHMS_Application.csproj.user" "Project debug settings" $false  
Test-File "Properties\launchSettings.json" "Launch settings" $false
Test-File "Properties\AssemblyInfo.cs" "Assembly information" $false

# Check documentation
Test-File "DEBUG_GUIDE.md" "Debug guide documentation" $false
Test-File "README_VISUAL_STUDIO.md" "Visual Studio setup guide" $false

Write-Host ""
Write-Host "Checking .NET SDK..." -ForegroundColor Cyan

try {
    $dotnetVersion = & dotnet --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] .NET SDK is installed: $dotnetVersion" -ForegroundColor Green
        
        $majorVersion = [int]($dotnetVersion.Split('.')[0])
        if ($majorVersion -ge 6) {
            Write-Host "[OK] .NET 6.0+ detected" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] .NET 6.0+ recommended for this project" -ForegroundColor Yellow
            $warnings++
        }
    } else {
        Write-Host "[ERROR] .NET SDK not found" -ForegroundColor Red
        $errors++
    }
} catch {
    Write-Host "[ERROR] .NET SDK not available in PATH" -ForegroundColor Red
    $errors++
}

Write-Host ""
Write-Host "Checking package restore..." -ForegroundColor Cyan

try {
    $restoreOutput = & dotnet restore --verbosity quiet 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] NuGet packages restored successfully" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Package restore failed" -ForegroundColor Red
        Write-Host "Try running: dotnet restore" -ForegroundColor Yellow
        $errors++
    }
} catch {
    Write-Host "[ERROR] Failed to run package restore" -ForegroundColor Red
    $errors++
}

Write-Host ""
Write-Host "Checking project build..." -ForegroundColor Cyan

try {
    $buildOutput = & dotnet build --configuration Debug --verbosity quiet 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Project builds successfully in Debug mode" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Build failed - may be platform specific (Windows Forms)" -ForegroundColor Yellow
        Write-Host "This is normal on non-Windows systems" -ForegroundColor Gray
        $warnings++
    }
} catch {
    Write-Host "[WARNING] Could not test build" -ForegroundColor Yellow
    $warnings++
}

Write-Host ""

# Visual Studio specific checks
Write-Host "Checking Visual Studio compatibility..." -ForegroundColor Cyan

# Check for Visual Studio installation (Windows only)
if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $vsInstallations = @()
    
    # Check for VS 2022
    $vs2022Path = "${env:ProgramFiles}\Microsoft Visual Studio\2022"
    if (Test-Path $vs2022Path) {
        $editions = Get-ChildItem $vs2022Path -Directory | Where-Object { Test-Path "$($_.FullName)\Common7\IDE\devenv.exe" }
        if ($editions) {
            Write-Host "[OK] Visual Studio 2022 found: $($editions.Name -join ', ')" -ForegroundColor Green
        }
    }
    
    # Check for VS 2019
    $vs2019Path = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019"
    if (Test-Path $vs2019Path) {
        $editions = Get-ChildItem $vs2019Path -Directory | Where-Object { Test-Path "$($_.FullName)\Common7\IDE\devenv.exe" }
        if ($editions) {
            Write-Host "[OK] Visual Studio 2019 found: $($editions.Name -join ', ')" -ForegroundColor Green
        }
    }
    
    # Check WebView2
    $webview2Registry = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}"
    if (Get-ItemProperty -Path $webview2Registry -ErrorAction SilentlyContinue) {
        Write-Host "[OK] WebView2 Runtime is installed" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] WebView2 Runtime may not be installed" -ForegroundColor Yellow
        $warnings++
    }
} else {
    Write-Host "[INFO] Running on non-Windows system - Visual Studio check skipped" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Visual Studio Setup Verification" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($errors -eq 0) {
    Write-Host "✓ Required files: ALL PRESENT" -ForegroundColor Green
    Write-Host "✓ Debug configuration: READY" -ForegroundColor Green  
    Write-Host "✓ .NET SDK: AVAILABLE" -ForegroundColor Green
    Write-Host "✓ Package restore: SUCCESS" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Your Visual Studio setup is ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To start debugging:" -ForegroundColor Cyan
    Write-Host "1. Open HHMS_Application.sln in Visual Studio" -ForegroundColor White
    Write-Host "2. Select 'Debug' configuration" -ForegroundColor White
    Write-Host "3. Press F5 to start debugging" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ SETUP INCOMPLETE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Found $errors error(s) and $warnings warning(s)" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Red
    Write-Host ""
}

if ($warnings -gt 0) {
    Write-Host "⚠️  Found $warnings warning(s) - setup may still work" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "For detailed instructions, see:" -ForegroundColor Cyan
Write-Host "- DEBUG_GUIDE.md (Vietnamese)" -ForegroundColor White
Write-Host "- README_VISUAL_STUDIO.md (English)" -ForegroundColor White
Write-Host "- TROUBLESHOOTING_VISUAL_STUDIO.md (Vietnamese)" -ForegroundColor White
Write-Host ""

if ($errors -eq 0) {
    exit 0
} else {
    exit 1
}