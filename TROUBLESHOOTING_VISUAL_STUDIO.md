# Hướng Dẫn Xử Lý Sự Cố Visual Studio - HHMS Application

## Các Lỗi Thường Gặp và Cách Khắc Phục

### 1. Lỗi Build và Compilation

#### Lỗi: "The target framework 'net6.0-windows' is not installed"
**Nguyên nhân**: Thiếu .NET 6.0 SDK
**Cách khắc phục**:
1. Tải .NET 6.0 SDK từ [Microsoft](https://dotnet.microsoft.com/download/dotnet/6.0)
2. Cài đặt và restart Visual Studio
3. Kiểm tra bằng cách chạy `dotnet --version` trong Command Prompt

#### Lỗi: "Could not load file or assembly 'Microsoft.Web.WebView2'"
**Nguyên nhân**: WebView2 runtime chưa được cài đặt
**Cách khắc phục**:
1. Tải Microsoft Edge WebView2 Runtime từ [Microsoft](https://developer.microsoft.com/microsoft-edge/webview2/)
2. Cài đặt phiên bản "Evergreen Standalone Installer"
3. Restart ứng dụng

#### Lỗi: "Package restore failed"
**Nguyên nhân**: Kết nối internet hoặc NuGet sources có vấn đề
**Cách khắc phục**:
```
Tools → NuGet Package Manager → Package Manager Console
Chạy lệnh:
Clear-Package-Cache
Update-Package -Reinstall
```

### 2. Lỗi Runtime

#### Lỗi: "System.ComponentModel.Win32Exception: The system cannot find the file specified"
**Nguyên nhân**: Thiếu dependencies hoặc đường dẫn không đúng
**Cách khắc phục**:
1. Kiểm tra thư mục bin/Debug có đầy đủ file không
2. Clean và Rebuild solution
3. Kiểm tra file App.config

#### Lỗi: "Could not connect to SQL Server"
**Nguyên nhân**: Database connection string hoặc SQL Server không khả dụng
**Cách khắc phục**:
1. Kiểm tra SQL Server đang chạy (SQL Server Configuration Manager)
2. Cập nhật connection string trong App.config:
   ```xml
   <connectionStrings>
     <add name="DefaultConnection" 
          connectionString="Server=localhost;Database=HHMS;Integrated Security=true;" 
          providerName="Microsoft.Data.SqlClient" />
   </connectionStrings>
   ```
3. Chạy script Database.sql để tạo database

### 3. Lỗi Visual Studio IDE

#### Lỗi: "IntelliSense không hoạt động"
**Cách khắc phục**:
1. Tools → Options → Text Editor → C# → IntelliSense
2. Đảm bảo "Show completion list after a character is typed" được check
3. Restart Visual Studio
4. Clear component cache: Xóa thư mục `%localappdata%\Microsoft\VisualStudio\17.0_[instance]\ComponentModelCache`

#### Lỗi: "Designer không mở được Windows Forms"
**Cách khắc phục**:
1. Right-click vào form file → "Open With" → "Windows Forms Designer"
2. Nếu vẫn lỗi: Close VS → Xóa thư mục .vs → Mở lại solution
3. Cập nhật Visual Studio lên phiên bản mới nhất

#### Lỗi: "Debugger không attach được"
**Cách khắc phục**:
1. Debug → Windows → Modules kiểm tra loaded assemblies
2. Project Properties → Debug → Check "Enable native code debugging"
3. Tools → Options → Debugging → General → Uncheck "Enable Just My Code"

### 4. Lỗi Performance

#### Visual Studio chạy chậm
**Cách tối ưu**:
1. Tools → Options → Environment → General
   - Uncheck "Automatically adjust visual experience based on client performance"
   - Check "Use hardware graphics acceleration if available"
2. Extensions → Manage Extensions → Disable các extension không cần thiết
3. Tools → Options → Projects and Solutions → General
   - Check "Track Active Item in Solution Explorer": False

#### Quá trình build chậm
**Cách tối ưu**:
1. Project Properties → Build → Advanced → Check "Prefer 32-bit": False
2. Tools → Options → Projects and Solutions → Build and Run
   - Tăng "Maximum number of parallel project builds"
3. Sử dụng SSD cho Visual Studio và project

### 5. Lỗi Git Integration

#### Git không hoạt động trong Visual Studio
**Cách khắc phục**:
1. View → Team Explorer
2. Connect → Local Git Repositories → Add repository path
3. Tools → Options → Source Control → Current source control plug-in: Git

#### Conflict khi merge
**Cách xử lý**:
1. Team Explorer → Changes → View Conflicts
2. Sử dụng Visual Studio Merge Tool để resolve
3. Hoặc sử dụng external tool như Beyond Compare

### 6. Các Lệnh Hữu Ích

#### Package Manager Console Commands
```powershell
# Xem danh sách packages
Get-Package

# Update tất cả packages
Update-Package

# Reinstall specific package
Update-Package Microsoft.Web.WebView2 -Reinstall

# Clear cache
Clear-Package-Cache
```

#### Developer Command Prompt Commands
```cmd
# Build project từ command line
msbuild HHMS_Application.sln /p:Configuration=Release

# Restore packages
dotnet restore

# Xem .NET versions installed
dotnet --list-sdks
```

### 7. Kiểm Tra Hệ Thống

#### Script PowerShell Kiểm Tra Requirements
```powershell
# Lưu thành check-requirements.ps1 và chạy trong PowerShell

Write-Host "=== HHMS Application System Check ===" -ForegroundColor Green

# Check .NET 6.0
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ .NET SDK không tìm thấy" -ForegroundColor Red
}

# Check Visual Studio
$vsPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\*\Common7\IDE\devenv.exe"
if (Test-Path $vsPath) {
    Write-Host "✓ Visual Studio 2022 đã cài đặt" -ForegroundColor Green
} else {
    Write-Host "✗ Visual Studio 2022 không tìm thấy" -ForegroundColor Red
}

# Check WebView2
$webview2 = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" -ErrorAction SilentlyContinue
if ($webview2) {
    Write-Host "✓ WebView2 Runtime đã cài đặt" -ForegroundColor Green
} else {
    Write-Host "✗ WebView2 Runtime chưa cài đặt" -ForegroundColor Red
}

Write-Host "=== Kiểm tra hoàn tất ===" -ForegroundColor Green
```

### 8. Liên Hệ Hỗ Trợ

Nếu vẫn gặp vấn đề:
1. **Tạo issue mới** trên GitHub repository với thông tin:
   - Version Visual Studio
   - Thông báo lỗi đầy đủ
   - Steps to reproduce
   - Screenshots nếu có

2. **Thông tin hệ thống cần cung cấp**:
   - Windows version: `winver`
   - .NET version: `dotnet --version`
   - Visual Studio version: Help → About Microsoft Visual Studio

3. **Log files hữu ích**:
   - Visual Studio Activity Log: `%APPDATA%\Microsoft\VisualStudio\17.0_[instance]\ActivityLog.xml`
   - Build output từ Output Window
   - Exception details từ Debug → Windows → Exception Settings

---

*Tài liệu này được cập nhật thường xuyên. Vui lòng kiểm tra phiên bản mới nhất trên repository.*