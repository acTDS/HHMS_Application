# HHMS_Application

Hospital and Health Management System - Ứng dụng quản lý bệnh viện và sức khỏe

## Hướng Dẫn Cài Đặt Visual Studio

Để chạy ứng dụng trên Visual Studio, vui lòng xem các tài liệu sau:

### 📋 Kiểm Tra Hệ Thống
- **Quick Check**: Chạy `quick-check.bat` để kiểm tra nhanh
- **Detailed Check**: Chạy `check-system-requirements.ps1` trong PowerShell để kiểm tra chi tiết

### 📚 Hướng Dẫn Chi Tiết
- **[HUONG_DAN_VISUAL_STUDIO.md](HUONG_DAN_VISUAL_STUDIO.md)** - Hướng dẫn tiếng Việt
- **[README_VISUAL_STUDIO.md](README_VISUAL_STUDIO.md)** - English instructions
- **[TROUBLESHOOTING_VISUAL_STUDIO.md](TROUBLESHOOTING_VISUAL_STUDIO.md)** - Xử lý sự cố

### 🚀 Bắt Đầu Nhanh
1. Đảm bảo có Visual Studio 2022 và .NET 6.0 SDK
2. Mở file `HHMS_Application.sln` trong Visual Studio
3. Restore NuGet packages (right-click solution → Restore NuGet Packages)
4. Nhấn F5 để chạy ứng dụng

### 📁 Cấu Trúc Dự Án
```
HHMS_Application/
├── HHMS_Application.sln          # Visual Studio Solution
├── HHMS_Application.csproj       # Project File  
├── Program.cs                    # Entry Point
├── Forms/                        # Windows Forms
├── Models/                       # Data Models
├── Services/                     # Business Logic
└── UI/                          # Web UI Assets
```
