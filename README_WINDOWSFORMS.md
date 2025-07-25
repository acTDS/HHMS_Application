# HHMS Application - WindowsForms with WebView2

## Tổng quan
Ứng dụng HHMS (Hệ thống Quản lý Trung Tâm Ngoại Ngữ) được xây dựng bằng WindowsForms với WebView2 để hiển thị các giao diện HTML.

## Cấu trúc Project

### Files chính:
- **Program.cs**: Entry point của ứng dụng
- **MainForm.cs**: Form điều hướng chính với tất cả các nút truy cập
- **BaseWebViewForm.cs**: Lớp cơ sở cho tất cả các form sử dụng WebView2
- **Forms/**: Thư mục chứa các form riêng biệt cho từng HTML

### Đặc điểm:
1. **Tự động căn chỉnh kích thước**: Mỗi form sử dụng WebView2 với Dock = Fill và xử lý sự kiện Resize
2. **Form riêng biệt**: Mỗi HTML file có một form riêng biệt kế thừa từ BaseWebViewForm
3. **WebView2 Integration**: Sử dụng Microsoft.Web.WebView2 để hiển thị HTML với đầy đủ tính năng web

## Danh sách các Form:

1. LoginForm - Đăng nhập
2. DashBoardForm - Bảng điều khiển
3. AccountandAccessManagementForm - Quản lý Tài khoản
4. BranchManagementForm - Quản lý Chi nhánh
5. ChangePassWordForm - Đổi mật khẩu
6. ClassDescriptionForm - Mô tả Lớp học
7. ClassListForm - Danh sách Lớp học
8. DepartmentManagementForm - Quản lý Phòng ban
9. DocumentListForm - Danh sách Tài liệu
10. EditSalaryTableForm - Chỉnh sửa Bảng lương
11. FinancialDashBoardForm - Bảng điều khiển Tài chính
12. KeepingtimeForm - Chấm công
13. LogForm - Nhật ký Hệ thống
14. MajorListForm - Danh sách Chuyên ngành
15. ReportCreateForm - Tạo Báo cáo
16. RequestCreateForm - Tạo Yêu cầu
17. RequestSummaryForm - Tóm tắt Yêu cầu
18. SalaryDescriptionForm - Mô tả Lương
19. StaffListForm - Danh sách Nhân viên
20. StudentListForm - Danh sách Học sinh
21. TCodeDefinitionVersion3Form - Định nghĩa TCode v3
22. TeacherEditShiftLearnForm - Chỉnh sửa Ca học Giáo viên
23. TusisionForm - Tusision

## Cách chạy:

### Yêu cầu:
- .NET 6.0 hoặc cao hơn
- Windows OS
- WebView2 Runtime (thường đã có sẵn trên Windows 10/11)

### Lệnh build và chạy:
```bash
dotnet build
dotnet run
```

## Tính năng Auto-Resize:

BaseWebViewForm implement các event handlers:
- `Resize`: Tự động điều chỉnh kích thước WebView2
- `SizeChanged`: Đảm bảo WebView2 luôn lấp đầy client area
- WebView2 được thiết lập với `Dock = DockStyle.Fill`

## Cấu trúc HTML Files:
Tất cả HTML files nằm trong thư mục `UI/` và được copy vào output directory khi build.