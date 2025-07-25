# HHMS Application System Requirements Checker
# Run this script in PowerShell to verify your system is ready for development

param(
    [switch]$Detailed = $false
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  HHMS Application System Checker   " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Function to check if a program is installed
function Test-ProgramInstalled {
    param([string]$ProgramName, [string]$RegistryPath)
    
    try {
        if (Test-Path $RegistryPath) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

# Check Windows Version
Write-Host "Checking Windows Version..." -ForegroundColor Yellow
$windowsVersion = [System.Environment]::OSVersion.Version
$windowsBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId -ErrorAction SilentlyContinue).ReleaseId

if ($windowsVersion.Major -ge 10) {
    if ($windowsBuild -ge 1903 -or $windowsVersion.Build -ge 22000) {
        Write-Host "✓ Windows Version: $($windowsVersion) (Build $($windowsBuild)) - SUPPORTED" -ForegroundColor Green
    } else {
        Write-Host "⚠ Windows Version: $($windowsVersion) (Build $($windowsBuild)) - UPDATE RECOMMENDED" -ForegroundColor Yellow
        Write-Host "  Recommended: Windows 10 version 1903+ or Windows 11" -ForegroundColor Gray
    }
} else {
    Write-Host "✗ Windows Version: $($windowsVersion) - NOT SUPPORTED" -ForegroundColor Red
    Write-Host "  Required: Windows 10 version 1903+ or Windows 11" -ForegroundColor Gray
    $allGood = $false
}

# Check .NET 6.0 SDK
Write-Host "`nChecking .NET 6.0 SDK..." -ForegroundColor Yellow
try {
    $dotnetVersion = & dotnet --version 2>$null
    if ($dotnetVersion -and $dotnetVersion.StartsWith("6.") -or $dotnetVersion.StartsWith("7.") -or $dotnetVersion.StartsWith("8.")) {
        Write-Host "✓ .NET SDK Version: $dotnetVersion - COMPATIBLE" -ForegroundColor Green
    } elseif ($dotnetVersion) {
        Write-Host "⚠ .NET SDK Version: $dotnetVersion - UPGRADE RECOMMENDED" -ForegroundColor Yellow
        Write-Host "  Recommended: .NET 6.0 SDK or newer" -ForegroundColor Gray
    } else {
        Write-Host "✗ .NET SDK: NOT FOUND" -ForegroundColor Red
        Write-Host "  Download from: https://dotnet.microsoft.com/download/dotnet/6.0" -ForegroundColor Gray
        $allGood = $false
    }
} catch {
    Write-Host "✗ .NET SDK: NOT FOUND" -ForegroundColor Red
    Write-Host "  Download from: https://dotnet.microsoft.com/download/dotnet/6.0" -ForegroundColor Gray
    $allGood = $false
}

# Check Visual Studio 2022
Write-Host "`nChecking Visual Studio 2022..." -ForegroundColor Yellow
$vs2022Paths = @(
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe",
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe",
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe"
)

$vs2022Found = $false
foreach ($path in $vs2022Paths) {
    if (Test-Path $path) {
        $vs2022Found = $true
        $vsVersion = (Get-ItemProperty $path).VersionInfo.FileVersion
        Write-Host "✓ Visual Studio 2022: Found at $path" -ForegroundColor Green
        if ($Detailed) {
            Write-Host "  Version: $vsVersion" -ForegroundColor Gray
        }
        break
    }
}

if (-not $vs2022Found) {
    # Check for VS 2019 as fallback
    $vs2019Paths = @(
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe"
    )
    
    $vs2019Found = $false
    foreach ($path in $vs2019Paths) {
        if (Test-Path $path) {
            $vs2019Found = $true
            Write-Host "⚠ Visual Studio 2019: Found (VS 2022 recommended)" -ForegroundColor Yellow
            break
        }
    }
    
    if (-not $vs2019Found) {
        Write-Host "✗ Visual Studio: NOT FOUND" -ForegroundColor Red
        Write-Host "  Download from: https://visualstudio.microsoft.com/" -ForegroundColor Gray
        $allGood = $false
    }
}

# Check WebView2 Runtime
Write-Host "`nChecking Microsoft Edge WebView2 Runtime..." -ForegroundColor Yellow
$webview2Registries = @(
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}",
    "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}"
)

$webview2Found = $false
foreach ($registry in $webview2Registries) {
    try {
        $webview2Info = Get-ItemProperty -Path $registry -ErrorAction SilentlyContinue
        if ($webview2Info -and $webview2Info.pv) {
            $webview2Found = $true
            Write-Host "✓ WebView2 Runtime: Version $($webview2Info.pv)" -ForegroundColor Green
            break
        }
    } catch {
        continue
    }
}

if (-not $webview2Found) {
    Write-Host "✗ WebView2 Runtime: NOT FOUND" -ForegroundColor Red
    Write-Host "  Download from: https://developer.microsoft.com/microsoft-edge/webview2/" -ForegroundColor Gray
    $allGood = $false
}

# Check SQL Server (optional but recommended)
Write-Host "`nChecking SQL Server..." -ForegroundColor Yellow
$sqlServices = @("MSSQLSERVER", "SQLEXPRESS", "MSSQL`$SQLEXPRESS")
$sqlFound = $false

foreach ($service in $sqlServices) {
    try {
        $serviceInfo = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($serviceInfo) {
            $sqlFound = $true
            Write-Host "✓ SQL Server Service: $service ($($serviceInfo.Status))" -ForegroundColor Green
            break
        }
    } catch {
        continue
    }
}

if (-not $sqlFound) {
    Write-Host "⚠ SQL Server: NOT FOUND (Optional but recommended for database features)" -ForegroundColor Yellow
    Write-Host "  Download SQL Server Express from: https://www.microsoft.com/sql-server/sql-server-downloads" -ForegroundColor Gray
}

# Check available RAM
Write-Host "`nChecking System Resources..." -ForegroundColor Yellow
$ram = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
if ($ram -ge 8) {
    Write-Host "✓ RAM: $ram GB - EXCELLENT" -ForegroundColor Green
} elseif ($ram -ge 4) {
    Write-Host "⚠ RAM: $ram GB - SUFFICIENT (8GB+ recommended)" -ForegroundColor Yellow
} else {
    Write-Host "✗ RAM: $ram GB - INSUFFICIENT (minimum 4GB required)" -ForegroundColor Red
    $allGood = $false
}

# Check available disk space
$disk = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq "C:"}
$freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
if ($freeSpaceGB -ge 10) {
    Write-Host "✓ Free Disk Space: $freeSpaceGB GB - SUFFICIENT" -ForegroundColor Green
} elseif ($freeSpaceGB -ge 5) {
    Write-Host "⚠ Free Disk Space: $freeSpaceGB GB - LIMITED (10GB+ recommended)" -ForegroundColor Yellow
} else {
    Write-Host "✗ Free Disk Space: $freeSpaceGB GB - INSUFFICIENT (minimum 5GB required)" -ForegroundColor Red
    $allGood = $false
}

# Summary
Write-Host "`n=====================================" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "   ✓ SYSTEM READY FOR DEVELOPMENT    " -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your system meets all requirements for HHMS Application development!" -ForegroundColor Green
    Write-Host "You can now open the project in Visual Studio and start developing." -ForegroundColor White
} else {
    Write-Host "   ⚠ SYSTEM NEEDS UPDATES             " -ForegroundColor Yellow  
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please install the missing components shown above before continuing." -ForegroundColor Yellow
    Write-Host "After installation, run this script again to verify your setup." -ForegroundColor White
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Open HHMS_Application.sln in Visual Studio" -ForegroundColor White
Write-Host "2. Restore NuGet packages (right-click solution → Restore NuGet Packages)" -ForegroundColor White
Write-Host "3. Build the solution (Ctrl+Shift+B)" -ForegroundColor White
Write-Host "4. Run the application (F5)" -ForegroundColor White
Write-Host ""
Write-Host "For detailed setup instructions, see:" -ForegroundColor Cyan
Write-Host "- HUONG_DAN_VISUAL_STUDIO.md (Vietnamese)" -ForegroundColor White
Write-Host "- README_VISUAL_STUDIO.md (English)" -ForegroundColor White
Write-Host ""