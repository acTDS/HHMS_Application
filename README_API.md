# HHMS Application - API Integration

Dự án tích hợp API backend với UI frontend cho hệ thống quản lý nhân sự HHMS (Human Resources Management System).

## Cấu trúc dự án

```
HHMS_Application/
├── Database.sql          # Database schema SQL Server
├── UI/                   # Frontend HTML files
│   ├── DashBoard.html    # Dashboard chính (đã tích hợp API)
│   ├── StaffList.html    # Quản lý nhân viên
│   ├── api-test.html     # Trang test API
│   └── js/
│       └── api-client.js # API client library
└── API/                  # Backend ASP.NET Core Web API
    ├── Controllers/      # API endpoints
    ├── Models/          # Data models
    ├── Data/            # Entity Framework DbContext
    └── Services/        # Business logic & database seeder
```

## Cài đặt và chạy

### 1. Cài đặt Backend API

```bash
cd API
dotnet restore
dotnet build
```

### 2. Cấu hình Database

Sửa connection string trong `API/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=HHMS_NgoaiNgu68;Trusted_Connection=true;TrustServerCertificate=true;"
  }
}
```

### 3. Chạy API

```bash
cd API
dotnet run
```

API sẽ chạy tại: `https://localhost:7000` và `http://localhost:5000`

### 4. Chạy Frontend

Mở các file HTML trong thư mục `UI/` bằng trình duyệt web hoặc web server.

## Tính năng đã tích hợp

### API Endpoints

#### Dashboard API (`/api/dashboard/`)
- `GET /metrics` - Lấy metrics dashboard
- `GET /summary` - Tổng quan hệ thống
- `GET /activities` - Hoạt động trong ngày
- `GET /upcoming-classes` - Lớp học sắp tới
- `GET /pending-requests` - Yêu cầu chờ xử lý

#### Staff API (`/api/staff/`)
- `GET /` - Lấy danh sách nhân viên (có phân trang, tìm kiếm)
- `GET /{id}` - Lấy thông tin nhân viên theo ID
- `POST /` - Tạo nhân viên mới
- `PUT /{id}` - Cập nhật thông tin nhân viên
- `DELETE /{id}` - Xóa nhân viên (soft delete)

#### TCode API (`/api/tcode/`)
- `GET /` - Lấy danh sách T-Code theo quyền user
- `GET /{tcode}` - Lấy thông tin T-Code cụ thể
- `POST /validate` - Xác thực quyền truy cập T-Code

#### User API (`/api/user/`)
- `GET /info` - Lấy thông tin người dùng hiện tại
- `POST /login` - Đăng nhập
- `POST /logout` - Đăng xuất
- `POST /change-password` - Đổi mật khẩu

### Frontend Integration

#### JavaScript API Client
- File `UI/js/api-client.js` cung cấp API client dễ sử dụng
- Tự động fallback về mock data khi API không khả dụng
- Xử lý lỗi và timeout

#### Dashboard Updates
- `DashBoard.html` đã được cập nhật để sử dụng API
- Tự động load dữ liệu thực từ database
- Hiển thị thông báo lỗi khi không kết nối được API

## Testing

### API Test Page
Mở `UI/api-test.html` để test các API endpoints:
- Kiểm tra kết nối API
- Test từng endpoint riêng biệt
- Xem response data và error handling

### Database Seeding
API tự động seed database với dữ liệu mẫu khi khởi động lần đầu:
- 5 General Status
- 3 Branches (Chi nhánh)
- 5 Departments (Phòng ban)
- 4 Staff (Nhân viên)
- 8 T-Codes
- 3 Metric Types và Metrics

## Công nghệ sử dụng

### Backend
- ASP.NET Core 8.0 Web API
- Entity Framework Core
- SQL Server / LocalDB
- Swagger/OpenAPI documentation

### Frontend
- HTML5 + CSS3
- JavaScript ES6+
- Tailwind CSS
- Font Awesome icons

## Lưu ý phát triển

1. **CORS**: API đã được cấu hình để accept tất cả origins trong development
2. **Error Handling**: Frontend có fallback mechanism với mock data
3. **Database**: Sử dụng LocalDB để dễ dàng development
4. **Vietnamese Support**: Tất cả UI và API messages đều hỗ trợ tiếng Việt
5. **Responsive**: UI responsive hoạt động tốt trên mobile và desktop

## Roadmap

- [ ] Hoàn thiện tích hợp cho tất cả UI files
- [ ] Thêm authentication/authorization thực tế
- [ ] Implement Student, Class, Document APIs
- [ ] Add real-time notifications
- [ ] Performance optimization
- [ ] Production deployment configuration