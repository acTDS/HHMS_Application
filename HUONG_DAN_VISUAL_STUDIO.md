# Hướng Dẫn Chạy HHMS Application Trên Visual Studio

## Mục Lục
1. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
2. [Cài Đặt Visual Studio](#cài-đặt-visual-studio)
3. [Mở Project](#mở-project)
4. [Cấu Hình Project](#cấu-hình-project)
5. [Chạy Ứng Dụng](#chạy-ứng-dụng)
6. [Debug và Troubleshooting](#debug-và-troubleshooting)
7. [Build và Publish](#build-và-publish)

## Yêu Cầu Hệ Thống

### Phần Mềm Bắt Buộc
- **Hệ điều hành**: Windows 10 version 1903 trở lên hoặc Windows 11
- **Visual Studio**: Visual Studio 2022 (khuyến nghị) hoặc Visual Studio 2019 version 16.8+
- **.NET SDK**: .NET 6.0 SDK hoặc cao hơn
- **WebView2 Runtime**: Microsoft Edge WebView2 Runtime (thường đã cài sẵn trên Windows 11)

### Phần Cứng Khuyến Nghị
- **RAM**: Tối thiểu 4GB, khuyến nghị 8GB+
- **Ổ cứng**: Ít nhất 2GB dung lượng trống
- **CPU**: Intel Core i3 hoặc AMD tương đương trở lên

## Cài Đặt Visual Studio

### Bước 1: Tải Visual Studio
1. Truy cập [https://visualstudio.microsoft.com/](https://visualstudio.microsoft.com/)
2. Chọn **Visual Studio Community** (miễn phí) hoặc phiên bản phù hợp
3. Tải về và chạy file cài đặt

### Bước 2: Chọn Workloads
Trong Visual Studio Installer, chọn các workloads sau:
- ✅ **.NET Desktop Development** (Bắt buộc)
- ✅ **Data storage and processing** (Khuyến nghị cho SQL Server)
- ✅ **Web development** (Nếu cần chỉnh sửa UI files)

### Bước 3: Individual Components
Đảm bảo các components sau được chọn:
- ✅ **.NET 6.0 Runtime (Long Term Support)**
- ✅ **.NET 6.0 SDK**
- ✅ **Windows 10/11 SDK (latest version)**
- ✅ **Microsoft Edge WebView2**

## Mở Project

### Cách 1: Mở Solution File
1. Mở Visual Studio 2022
2. Chọn **File** → **Open** → **Project/Solution**
3. Duyệt đến thư mục project và chọn file `HHMS_Application.sln`
4. Click **Open**

### Cách 2: Clone từ Git (nếu chưa có)
1. Mở Visual Studio 2022
2. Chọn **Clone a repository**
3. Nhập URL repository: `https://github.com/acTDS/HHMS_Application.git`
4. Chọn thư mục lưu trữ
5. Click **Clone**

## Cấu Hình Project

### Bước 1: Restore NuGet Packages
1. Right-click vào Solution trong **Solution Explorer**
2. Chọn **Restore NuGet Packages**
3. Đợi quá trình download hoàn tất

### Bước 2: Kiểm tra Target Framework
1. Right-click vào project **HHMS_Application** trong Solution Explorer
2. Chọn **Properties**
3. Trong tab **Application**, đảm bảo:
   - **Target framework**: `.NET 6.0-windows`
   - **Output type**: `Windows Application`
   - **Use Windows Forms**: `Checked`

### Bước 3: Cấu Hình Database (nếu cần)
1. Mở file `App.config`
2. Kiểm tra connection string trong file
3. Cập nhật connection string phù hợp với SQL Server của bạn:
   ```xml
   <connectionStrings>
     <add name="DefaultConnection" 
          connectionString="Server=.;Database=HHMS;Integrated Security=true;" 
          providerName="Microsoft.Data.SqlClient" />
   </connectionStrings>
   ```

## Chạy Ứng Dụng

### Debug Mode
1. Đảm bảo configuration được set thành **Debug**
2. Nhấn **F5** hoặc click nút **Start Debugging** (▶️)
3. Ứng dụng sẽ được build và chạy

### Run Without Debugging
1. Nhấn **Ctrl+F5** hoặc chọn **Debug** → **Start Without Debugging**
2. Ứng dụng sẽ chạy mà không attach debugger

### Thiết Lập Startup Project
Nếu solution có nhiều project:
1. Right-click vào project **HHMS_Application** trong Solution Explorer
2. Chọn **Set as Startup Project**

## Debug và Troubleshooting

### Các Lỗi Thường Gặp

#### 1. Lỗi "WebView2 not found"
**Triệu chứng**: Ứng dụng crash khi mở forms có WebView2
**Giải pháp**:
- Tải và cài đặt Microsoft Edge WebView2 Runtime từ [Microsoft](https://developer.microsoft.com/microsoft-edge/webview2/)

#### 2. Lỗi NuGet Package
**Triệu chứng**: Build error về missing packages
**Giải pháp**:
```
Tools → NuGet Package Manager → Package Manager Console
Chạy lệnh: Update-Package -Reinstall
```

#### 3. Lỗi .NET Framework/SDK
**Triệu chứng**: "The target framework is not installed"
**Giải pháp**:
- Cài đặt .NET 6.0 SDK từ [Microsoft](https://dotnet.microsoft.com/download/dotnet/6.0)

#### 4. Lỗi SQL Connection
**Triệu chứng**: Cannot connect to database
**Giải pháp**:
- Kiểm tra SQL Server đang chạy
- Cập nhật connection string trong App.config
- Đảm bảo database HHMS tồn tại (chạy script Database.sql)

### Debug Techniques
1. **Breakpoints**: Click vào lề trái của code editor để đặt breakpoint
2. **Watch Window**: Debug → Windows → Watch để theo dõi biến
3. **Output Window**: View → Output để xem debug messages
4. **Exception Settings**: Debug → Windows → Exception Settings

## Build và Publish

### Build Solution
1. **Build** → **Build Solution** (Ctrl+Shift+B)
2. Kiểm tra **Output Window** để xem kết quả build
3. File .exe sẽ được tạo trong thư mục `bin\Debug\net6.0-windows\`

### Publish Application
1. Right-click vào project **HHMS_Application**
2. Chọn **Publish**
3. Chọn target:
   - **Folder**: Để tạo self-contained application
   - **Microsoft Store**: Để publish lên Store
4. Cấu hình publish settings:
   - **Target Runtime**: `win-x64` hoặc `win-x86`
   - **Deployment Mode**: 
     - `Self-contained`: Bao gồm .NET runtime
     - `Framework-dependent`: Yêu cầu .NET đã cài trên máy target
5. Click **Publish**

### Release Build
1. Chuyển configuration từ **Debug** sang **Release**
2. Build lại solution
3. File release sẽ có performance tốt hơn và kích thước nhỏ hơn

## Cấu Trúc Project

```
HHMS_Application/
├── HHMS_Application.sln          # Solution file
├── HHMS_Application.csproj       # Project file
├── Program.cs                    # Entry point
├── MainForm.cs                   # Main form
├── App.config                    # Configuration file
├── Forms/                        # Các Windows Forms
├── Models/                       # Data models
├── Services/                     # Business logic
├── API/                         # API related files
├── UI/                          # UI assets (HTML, CSS, JS)
└── Database.sql                 # Database schema
```

## Các Tính Năng Quan Trọng

### IntelliSense
- Auto-completion: Ctrl+Space
- Parameter hints: Ctrl+Shift+Space
- Quick info: Ctrl+K, Ctrl+I

### Refactoring
- Rename: F2
- Extract Method: Ctrl+R, Ctrl+M
- Organize Usings: Ctrl+R, Ctrl+G

### Source Control
- Team Explorer: View → Team Explorer
- Commit: Ctrl+0, Ctrl+G

## Lưu Ý Quan Trọng

1. **Luôn backup code** trước khi thực hiện thay đổi lớn
2. **Sử dụng version control** (Git) để track changes
3. **Test thoroughly** trước khi deploy
4. **Đọc error messages carefully** để troubleshoot hiệu quả
5. **Keep Visual Studio updated** để có experience tốt nhất

## Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra **Error List** (View → Error List)
2. Xem **Output Window** để có thêm thông tin
3. Tìm kiếm error message trên Google hoặc Stack Overflow
4. Kiểm tra documentation của các NuGet packages được sử dụng

---

*Hướng dẫn này được tạo để hỗ trợ việc phát triển HHMS Application trên Visual Studio. Vui lòng cập nhật tài liệu này khi có thay đổi trong project.*