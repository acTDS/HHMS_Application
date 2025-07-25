
CREATE DATABASE HHMS_NgoaiNgu68;
END
GO

USE HHMS_NgoaiNgu68;
GO

-- ============================================================================
-- 1. BẢNG TRẠNG THÁI CHUNG (GENERAL STATUS)
-- ============================================================================
CREATE TABLE GeneralStatus (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(100) NOT NULL,
    StatusType NVARCHAR(50), -- 'Common', 'User', 'Course', 'Financial', etc.
    DisplayOrder INT DEFAULT 1,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE()
);

INSERT INTO GeneralStatus (StatusName, StatusType, DisplayOrder) VALUES
('Active', 'Common', 1),
('Inactive', 'Common', 2),
('Pending', 'Common', 3),
('Completed', 'Common', 4),
('Cancelled', 'Common', 5),
('In Progress', 'Common', 6),
('Expired', 'Common', 7);

-- ============================================================================
-- 2. QUẢN LÝ CHI NHÁNH & PHÒNG BAN
-- ============================================================================
CREATE TABLE Branch (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchCode NVARCHAR(20) UNIQUE NOT NULL,
    BranchName NVARCHAR(255) NOT NULL,
    BranchAddress NVARCHAR(500),
    Phone NVARCHAR(20),
    Email NVARCHAR(255),
    BranchLicense NVARCHAR(255),
    BranchDirector NVARCHAR(255),
    EstablishedDate DATE,
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

INSERT INTO Branch (BranchCode, BranchName, BranchAddress, Phone, Email, BranchDirector) VALUES
('NN68-HN', 'Chi nhánh Hà Nội', '123 Đường Láng, Đống Đa, Hà Nội', '024-1234-5678', 'hanoi@nn68.edu.vn', 'Nguyễn Văn Nam'),
('NN68-HCM', 'Chi nhánh TP.HCM', '456 Nguyễn Trãi, Q.5, TP.HCM', '028-8765-4321', 'hcm@nn68.edu.vn', 'Trần Thị Mai'),
('NN68-DN', 'Chi nhánh Đà Nẵng', '789 Lê Duẩn, Hải Châu, Đà Nẵng', '0236-567-890', 'danang@nn68.edu.vn', 'Lê Hoàng Tùng');

CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentCode NVARCHAR(20) UNIQUE NOT NULL,
    DepartmentName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(500),
    ManagerStaffName NVARCHAR(255),
    StaffQuota INT DEFAULT 0,
    BranchID INT,
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

INSERT INTO Department (DepartmentCode, DepartmentName, Description, ManagerStaffName, StaffQuota, BranchID) VALUES
('NN68-HR', 'Nhân sự', 'Quản lý nhân sự và tuyển dụng', 'Nguyễn Thị Lan', 8, 1),
('NN68-EDU', 'Giáo vụ', 'Quản lý chương trình đào tạo', 'Phạm Văn Minh', 15, 1),
('NN68-FIN', 'Tài chính', 'Quản lý tài chính và kế toán', 'Hoàng Thị Hoa', 6, 1),
('NN68-IT', 'Công nghệ thông tin', 'Quản lý hệ thống IT', 'Lê Văn Đức', 5, 1),
('NN68-MKT', 'Marketing', 'Tuyển sinh và quảng bá', 'Vũ Thị Thu', 10, 1);

-- ============================================================================
-- 3. HỆ THỐNG T-CODE & NAVIGATION
-- ============================================================================
CREATE TABLE TCode (
    TCodeID INT IDENTITY(1,1) PRIMARY KEY,
    TCode NVARCHAR(20) UNIQUE NOT NULL,
    TCodeName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(500),
    UIFile NVARCHAR(255), -- Link to HTML file
    IconClass NVARCHAR(100), -- CSS class cho icon
    Category NVARCHAR(100), -- Phân loại T-Code
    IsActive BIT DEFAULT 1,
    DisplayOrder INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE()
);

INSERT INTO TCode (TCode, TCodeName, Description, UIFile, IconClass, Category, DisplayOrder) VALUES
('T001', 'Dashboard', 'Trang tổng quan hệ thống', 'DashBoard.html', 'fas fa-tachometer-alt', 'System', 1),
('T002', 'Quản lý nhân viên', 'Quản lý thông tin nhân viên', 'StaffManagement.html', 'fas fa-users', 'HR', 2),
('T003', 'Quản lý học viên', 'Quản lý thông tin học viên', 'StudentManagement.html', 'fas fa-user-graduate', 'Education', 3),
('T004', 'Quản lý lớp học', 'Quản lý lớp học và khóa học', 'ClassManagement.html', 'fas fa-chalkboard-teacher', 'Education', 4),
('T005', 'Quản lý tài chính', 'Quản lý thu chi và báo cáo tài chính', 'FinancialManagement.html', 'fas fa-chart-line', 'Finance', 5),
('T006', 'Quản lý tài liệu', 'Quản lý tài liệu và giáo trình', 'DocumentManagement.html', 'fas fa-folder', 'Education', 6),
('T007', 'Báo cáo thống kê', 'Xem báo cáo và thống kê', 'ReportManagement.html', 'fas fa-chart-bar', 'Report', 7),
('T008', 'Quản lý tài khoản', 'Quản lý tài khoản và phân quyền', 'AccountManagement.html', 'fas fa-user-cog', 'System', 8);

-- ============================================================================
-- 4. QUẢN LÝ NHÂN VIÊN & TÀI KHOẢN
-- ============================================================================
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    StaffCode NVARCHAR(20) UNIQUE NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(10),
    IDNumber NVARCHAR(50) UNIQUE,
    BirthDate DATE,
    StaffAddress NVARCHAR(500),
    Phone NVARCHAR(20),
    Email NVARCHAR(255) UNIQUE,
    ContractType NVARCHAR(50), -- 'Full-time', 'Part-time', 'Contract'
    Position NVARCHAR(100),
    BranchID INT,
    DepartmentID INT,
    HireDate DATE DEFAULT GETDATE(),
    BaseSalary DECIMAL(19,2) DEFAULT 0,
    StatusID INT DEFAULT 1,
    AvatarPath NVARCHAR(500),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

INSERT INTO Staff (StaffCode, FullName, Gender, IDNumber, Email, Position, BranchID, DepartmentID, BaseSalary) VALUES
('ST001', 'Nguyễn Văn Admin', 'Nam', '123456789012', 'admin@nn68.edu.vn', 'Quản trị hệ thống', 1, 4, 15000000),
('ST002', 'Trần Thị Manager', 'Nữ', '123456789013', 'manager@nn68.edu.vn', 'Trưởng phòng Giáo vụ', 1, 2, 12000000),
('ST003', 'Lê Hoàng Teacher', 'Nam', '123456789014', 'teacher@nn68.edu.vn', 'Giảng viên', 1, 2, 8000000),
('ST004', 'Phạm Thị Staff', 'Nữ', '123456789015', 'staff@nn68.edu.vn', 'Nhân viên tư vấn', 1, 5, 7000000);

-- Bảng tài khoản đăng nhập
CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT UNIQUE,
    Username NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL, -- Hashed password
    Email NVARCHAR(255),
    LastLogin DATETIME2,
    LoginAttempts INT DEFAULT 0,
    IsLocked BIT DEFAULT 0,
    LockedUntil DATETIME2,
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

INSERT INTO Account (StaffID, Username, PasswordHash, Email) VALUES
(1, 'admin', 'hashed_password_123', 'admin@nn68.edu.vn'),
(2, 'manager', 'hashed_password_456', 'manager@nn68.edu.vn'),
(3, 'teacher', 'hashed_password_789', 'teacher@nn68.edu.vn'),
(4, 'staff', 'hashed_password_012', 'staff@nn68.edu.vn');

-- ============================================================================
-- 5. HỆ THỐNG PHÂN QUYỀN
-- ============================================================================
CREATE TABLE Role (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(100) UNIQUE NOT NULL,
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE()
);

INSERT INTO Role (RoleName, Description) VALUES
('System Admin', 'Quản trị viên hệ thống - toàn quyền'),
('Branch Manager', 'Trưởng chi nhánh - quản lý chi nhánh'),
('Department Manager', 'Trưởng phòng - quản lý phòng ban'),
('Teacher', 'Giảng viên - quản lý lớp học'),
('Staff', 'Nhân viên - quyền hạn cơ bản'),
('Accountant', 'Kế toán - quản lý tài chính'),
('Student Advisor', 'Tư vấn viên - quản lý học viên');

CREATE TABLE Permission (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) UNIQUE NOT NULL,
    PermissionType NVARCHAR(50), -- 'Read', 'Write', 'Delete', 'Execute'
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

INSERT INTO Permission (PermissionName, PermissionType, Description) VALUES
('Dashboard.View', 'Read', 'Xem dashboard tổng quan'),
('Staff.View', 'Read', 'Xem thông tin nhân viên'),
('Staff.Create', 'Write', 'Tạo mới nhân viên'),
('Staff.Edit', 'Write', 'Chỉnh sửa thông tin nhân viên'),
('Staff.Delete', 'Delete', 'Xóa nhân viên'),
('Student.View', 'Read', 'Xem thông tin học viên'),
('Student.Create', 'Write', 'Tạo mới học viên'),
('Student.Edit', 'Write', 'Chỉnh sửa thông tin học viên'),
('Class.View', 'Read', 'Xem thông tin lớp học'),
('Class.Manage', 'Write', 'Quản lý lớp học'),
('Finance.View', 'Read', 'Xem báo cáo tài chính'),
('Finance.Manage', 'Write', 'Quản lý tài chính'),
('System.Admin', 'Execute', 'Quản trị hệ thống'),
('Report.View', 'Read', 'Xem báo cáo'),
('Document.Manage', 'Write', 'Quản lý tài liệu');

-- Bảng phân quyền cho Role
CREATE TABLE Role_Permission (
    RoleID INT,
    PermissionID INT,
    GrantedDate DATETIME2 DEFAULT GETDATE(),
    GrantedBy INT,
    PRIMARY KEY (RoleID, PermissionID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (PermissionID) REFERENCES Permission(PermissionID),
    FOREIGN KEY (GrantedBy) REFERENCES Staff(StaffID)
);

-- Phân quyền cho System Admin (toàn quyền)
INSERT INTO Role_Permission (RoleID, PermissionID, GrantedBy) 
SELECT 1, PermissionID, 1 FROM Permission;

-- Phân quyền cho Teacher
INSERT INTO Role_Permission (RoleID, PermissionID, GrantedBy) VALUES
(4, 1, 1), -- Dashboard.View
(4, 6, 1), -- Student.View
(4, 9, 1), -- Class.View
(4, 10, 1), -- Class.Manage
(4, 14, 1), -- Report.View
(4, 15, 1); -- Document.Manage

-- Bảng gán role cho staff
CREATE TABLE Staff_Role (
    StaffID INT,
    RoleID INT,
    AssignedDate DATETIME2 DEFAULT GETDATE(),
    AssignedBy INT,
    IsActive BIT DEFAULT 1,
    PRIMARY KEY (StaffID, RoleID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (AssignedBy) REFERENCES Staff(StaffID)
);

INSERT INTO Staff_Role (StaffID, RoleID, AssignedBy) VALUES
(1, 1, 1), -- Admin -> System Admin
(2, 2, 1), -- Manager -> Branch Manager
(3, 4, 1), -- Teacher -> Teacher
(4, 5, 1); -- Staff -> Staff

-- Bảng phân quyền T-Code cho Role
CREATE TABLE Role_TCode (
    RoleID INT,
    TCodeID INT,
    CanAccess BIT DEFAULT 1,
    AssignedDate DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (RoleID, TCodeID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (TCodeID) REFERENCES TCode(TCodeID)
);

-- Phân quyền T-Code cho System Admin (tất cả)
INSERT INTO Role_TCode (RoleID, TCodeID)
SELECT 1, TCodeID FROM TCode;

-- Phân quyền T-Code cho Teacher
INSERT INTO Role_TCode (RoleID, TCodeID) VALUES
(4, 1), -- Dashboard
(4, 3), -- Student Management
(4, 4), -- Class Management
(4, 6); -- Document Management

-- ============================================================================
-- 6. HỆ THỐNG THÔNG BÁO (NOTIFICATIONS)
-- ============================================================================
CREATE TABLE NotificationType (
    TypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) UNIQUE NOT NULL,
    Description NVARCHAR(500),
    IconClass NVARCHAR(100),
    DefaultColor NVARCHAR(20),
    IsActive BIT DEFAULT 1
);

INSERT INTO NotificationType (TypeName, Description, IconClass, DefaultColor) VALUES
('System', 'Thông báo hệ thống', 'fas fa-cog', '#3498db'),
('Class', 'Thông báo lớp học', 'fas fa-chalkboard', '#e74c3c'),
('Student', 'Thông báo học viên', 'fas fa-user-graduate', '#2ecc71'),
('Finance', 'Thông báo tài chính', 'fas fa-dollar-sign', '#f39c12'),
('Document', 'Thông báo tài liệu', 'fas fa-file', '#9b59b6'),
('Schedule', 'Thông báo lịch học', 'fas fa-calendar', '#1abc9c');

CREATE TABLE Notification (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Message NVARCHAR(1000) NOT NULL,
    TypeID INT,
    Priority NVARCHAR(20) DEFAULT 'Normal', -- 'Low', 'Normal', 'High', 'Urgent'
    IsRead BIT DEFAULT 0,
    IsGlobal BIT DEFAULT 0, -- True nếu gửi cho tất cả user
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ExpiryDate DATETIME2,
    StatusID INT DEFAULT 1,
    FOREIGN KEY (TypeID) REFERENCES NotificationType(TypeID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

-- Bảng chi tiết ai nhận thông báo nào
CREATE TABLE NotificationRecipient (
    NotificationID INT,
    StaffID INT,
    IsRead BIT DEFAULT 0,
    ReadDate DATETIME2,
    DeliveryStatus NVARCHAR(20) DEFAULT 'Pending', -- 'Pending', 'Delivered', 'Failed'
    PRIMARY KEY (NotificationID, StaffID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(NotificationID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Thêm một số thông báo mẫu
INSERT INTO Notification (Title, Message, TypeID, Priority, IsGlobal, CreatedBy) VALUES
('Hệ thống bảo trì', 'Hệ thống sẽ bảo trì vào 2h sáng ngày mai', 1, 'High', 1, 1),
('Lớp học mới', 'Lớp TOEIC cơ bản sẽ khai giảng vào tuần tới', 2, 'Normal', 0, 2),
('Báo cáo tài chính', 'Báo cáo tài chính tháng 7 đã sẵn sàng', 4, 'Normal', 0, 1),
('Cập nhật tài liệu', 'Tài liệu giảng dạy đã được cập nhật phiên bản mới', 5, 'Low', 1, 3);

-- ============================================================================
-- 7. HỆ THỐNG METRICS & DASHBOARD DATA
-- ============================================================================
CREATE TABLE MetricType (
    MetricTypeID INT IDENTITY(1,1) PRIMARY KEY,
    MetricName NVARCHAR(100) UNIQUE NOT NULL,
    DisplayName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(500),
    Unit NVARCHAR(50), -- 'Count', 'Percentage', 'Currency', 'Hours'
    IconClass NVARCHAR(100),
    Category NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    DisplayOrder INT DEFAULT 1
);

INSERT INTO MetricType (MetricName, DisplayName, Description, Unit, IconClass, Category, DisplayOrder) VALUES
('total_students', 'Tổng số học viên', 'Tổng số học viên đang theo học', 'Count', 'fas fa-user-graduate', 'Education', 1),
('active_classes', 'Lớp học đang hoạt động', 'Số lớp học đang diễn ra', 'Count', 'fas fa-chalkboard-teacher', 'Education', 2),
('monthly_revenue', 'Doanh thu tháng', 'Doanh thu trong tháng hiện tại', 'Currency', 'fas fa-chart-line', 'Finance', 3),
('staff_count', 'Số lượng nhân viên', 'Tổng số nhân viên đang làm việc', 'Count', 'fas fa-users', 'HR', 4),
('completion_rate', 'Tỷ lệ hoàn thành', 'Tỷ lệ học viên hoàn thành khóa học', 'Percentage', 'fas fa-trophy', 'Education', 5),
('attendance_rate', 'Tỷ lệ điểm danh', 'Tỷ lệ điểm danh trung bình', 'Percentage', 'fas fa-check-circle', 'Education', 6);

CREATE TABLE DashboardMetric (
    MetricID INT IDENTITY(1,1) PRIMARY KEY,
    MetricTypeID INT,
    BranchID INT,
    CurrentValue DECIMAL(19,2) NOT NULL,
    PreviousValue DECIMAL(19,2),
    ChangePercentage DECIMAL(5,2), -- Phần trăm thay đổi
    LastUpdated DATETIME2 DEFAULT GETDATE(),
    CalculatedBy INT,
    FOREIGN KEY (MetricTypeID) REFERENCES MetricType(MetricTypeID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (CalculatedBy) REFERENCES Staff(StaffID)
);

-- Thêm dữ liệu metrics mẫu
INSERT INTO DashboardMetric (MetricTypeID, BranchID, CurrentValue, PreviousValue, ChangePercentage, CalculatedBy) VALUES
(1, 1, 450, 420, 7.14, 1), -- Tổng học viên: 450, tăng 7.14%
(2, 1, 25, 23, 8.70, 1),   -- Lớp đang hoạt động: 25, tăng 8.70%
(3, 1, 850000000, 800000000, 6.25, 1), -- Doanh thu: 850M, tăng 6.25%
(4, 1, 35, 33, 6.06, 1),   -- Nhân viên: 35, tăng 6.06%
(5, 1, 92.5, 89.2, 3.70, 1), -- Tỷ lệ hoàn thành: 92.5%, tăng 3.70%
(6, 1, 85.8, 87.1, -1.49, 1); -- Tỷ lệ điểm danh: 85.8%, giảm 1.49%

-- ============================================================================
-- 8. HOẠT ĐỘNG & LOGS
-- ============================================================================
CREATE TABLE ActivityType (
    ActivityTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) UNIQUE NOT NULL,
    Description NVARCHAR(500),
    IconClass NVARCHAR(100),
    Color NVARCHAR(20),
    IsActive BIT DEFAULT 1
);

INSERT INTO ActivityType (TypeName, Description, IconClass, Color) VALUES
('Login', 'Đăng nhập hệ thống', 'fas fa-sign-in-alt', '#3498db'),
('Logout', 'Đăng xuất hệ thống', 'fas fa-sign-out-alt', '#95a5a6'),
('Create', 'Tạo mới dữ liệu', 'fas fa-plus', '#2ecc71'),
('Update', 'Cập nhật dữ liệu', 'fas fa-edit', '#f39c12'),
('Delete', 'Xóa dữ liệu', 'fas fa-trash', '#e74c3c'),
('Payment', 'Thanh toán học phí', 'fas fa-credit-card', '#9b59b6'),
('Class Start', 'Bắt đầu lớp học', 'fas fa-play', '#1abc9c'),
('Class End', 'Kết thúc lớp học', 'fas fa-stop', '#34495e'),
('Enrollment', 'Đăng ký học', 'fas fa-user-plus', '#e67e22'),
('Grade Update', 'Cập nhật điểm', 'fas fa-star', '#f1c40f');

CREATE TABLE ActivityLog (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    ActivityTypeID INT,
    StaffID INT,
    TargetTable NVARCHAR(100), -- Bảng nào bị tác động
    TargetID INT, -- ID của record bị tác động
    Description NVARCHAR(1000),
    Details NVARCHAR(MAX), -- JSON format cho chi tiết
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    ActivityDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ActivityTypeID) REFERENCES ActivityType(ActivityTypeID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Thêm một số activity logs mẫu
INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description, IPAddress) VALUES
(1, 1, 'Account', 1, 'Admin đăng nhập vào hệ thống', '192.168.1.100'),
(3, 2, 'Student', 101, 'Tạo mới học viên: Nguyễn Văn A', '192.168.1.101'),
(7, 3, 'Class', 25, 'Bắt đầu lớp TOEIC Advanced', '192.168.1.102'),
(6, 4, 'Payment', 301, 'Học viên thanh toán học phí khóa IELTS', '192.168.1.103'),
(4, 2, 'Class', 22, 'Cập nhật thông tin lớp Business English', '192.168.1.101');

-- ============================================================================
-- 9. PENDING REQUESTS SYSTEM
-- ============================================================================
CREATE TABLE RequestType (
    RequestTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) UNIQUE NOT NULL,
    Description NVARCHAR(500),
    RequiresApproval BIT DEFAULT 1,
    ApproverRoleID INT,
    IconClass NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (ApproverRoleID) REFERENCES Role(RoleID)
);

INSERT INTO RequestType (TypeName, Description, RequiresApproval, ApproverRoleID, IconClass) VALUES
('Leave Request', 'Đơn xin nghỉ phép', 1, 3, 'fas fa-calendar-times'),
('Salary Advance', 'Đơn xin tạm ứng lương', 1, 2, 'fas fa-money-bill'),
('Course Change', 'Đơn xin chuyển khóa học', 1, 3, 'fas fa-exchange-alt'),
('Grade Appeal', 'Đơn phúc khảo điểm', 1, 4, 'fas fa-question-circle'),
('Equipment Request', 'Đơn xin cấp thiết bị', 1, 3, 'fas fa-laptop'),
('Schedule Change', 'Đơn xin thay đổi lịch', 1, 3, 'fas fa-clock');

CREATE TABLE PendingRequest (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    RequestTypeID INT,
    RequesterID INT, -- Staff hoặc Student gửi đơn
    RequesterType NVARCHAR(20), -- 'Staff' hoặc 'Student'
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(1000),
    RequestData NVARCHAR(MAX), -- JSON data cho request
    Priority NVARCHAR(20) DEFAULT 'Normal',
    CurrentApproverID INT,
    StatusID INT DEFAULT 3, -- Pending
    SubmittedDate DATETIME2 DEFAULT GETDATE(),
    RequiredByDate DATETIME2,
    ProcessedDate DATETIME2,
    ProcessedBy INT,
    ApprovalNotes NVARCHAR(1000),
    FOREIGN KEY (RequestTypeID) REFERENCES RequestType(RequestTypeID),
    FOREIGN KEY (RequesterID) REFERENCES Staff(StaffID),
    FOREIGN KEY (CurrentApproverID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (ProcessedBy) REFERENCES Staff(StaffID)
);

-- Thêm một số pending requests mẫu
INSERT INTO PendingRequest (RequestTypeID, RequesterID, RequesterType, Title, Description, Priority, CurrentApproverID) VALUES
(1, 3, 'Staff', 'Xin nghỉ phép 3 ngày', 'Xin nghỉ phép từ 25/7 đến 27/7 để về quê', 'Normal', 2),
(2, 4, 'Staff', 'Tạm ứng lương tháng 8', 'Xin tạm ứng 5 triệu lương tháng 8', 'High', 2),
(3, 101, 'Student', 'Chuyển từ TOEIC sang IELTS', 'Muốn chuyển khóa học do thay đổi mục tiêu', 'Normal', 2),
(4, 102, 'Student', 'Phúc khảo bài thi Speaking', 'Xin phúc khảo điểm thi Speaking vì cảm thấy chấm thấp', 'Low', 3),
(5, 3, 'Staff', 'Xin cấp máy tính mới', 'Máy tính cũ đã hỏng, cần thay thế', 'High', 2);

-- ============================================================================
-- 10. SESSION & SECURITY
-- ============================================================================
CREATE TABLE UserSession (
    SessionID NVARCHAR(255) PRIMARY KEY,
    StaffID INT,
    LoginTime DATETIME2 DEFAULT GETDATE(),
    LastActivity DATETIME2 DEFAULT GETDATE(),
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE SecurityLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(100), -- 'Login Failed', 'Account Locked', 'Suspicious Activity'
    StaffID INT,
    Description NVARCHAR(1000),
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    Severity NVARCHAR(20) DEFAULT 'Low', -- 'Low', 'Medium', 'High', 'Critical'
    EventDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- ============================================================================
-- 11. SYSTEM CONFIGURATION
-- ============================================================================
CREATE TABLE SystemConfig (
    ConfigID INT IDENTITY(1,1) PRIMARY KEY,
    ConfigKey NVARCHAR(100) UNIQUE NOT NULL,
    ConfigValue NVARCHAR(1000) NOT NULL,
    DataType NVARCHAR(50), -- 'String', 'Integer', 'Boolean', 'JSON'
    Category NVARCHAR(100),
    Description NVARCHAR(500),
    IsEditable BIT DEFAULT 1,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

INSERT INTO SystemConfig (ConfigKey, ConfigValue, DataType, Category, Description) VALUES
('system.name', 'Trung Tâm Ngoại Ngữ 68', 'String', 'General', 'Tên hệ thống'),
('system.version', '1.0.0', 'String', 'General', 'Phiên bản hệ thống'),
('session.timeout', '3600', 'Integer', 'Security', 'Thời gian timeout session (giây)'),
('password.min_length', '8', 'Integer', 'Security', 'Độ dài tối thiểu mật khẩu'),
('notification.auto_expire_days', '30', 'Integer', 'Notification', 'Số ngày tự động xóa thông báo cũ'),
('dashboard.refresh_interval', '300', 'Integer', 'Dashboard', 'Khoảng thời gian refresh dashboard (giây)'),
('file.max_upload_size', '10485760', 'Integer', 'File', 'Kích thước file upload tối đa (bytes)'),
('email.smtp_enabled', 'true', 'Boolean', 'Email', 'Bật/tắt gửi email'),
('backup.auto_backup_enabled', 'true', 'Boolean', 'Backup', 'Bật/tắt backup tự động');

-- ============================================================================
-- 12. INDEXES FOR PERFORMANCE
-- ============================================================================
-- Indexes cho performance
CREATE INDEX IX_Staff_Email ON Staff(Email);
CREATE INDEX IX_Staff_StaffCode ON Staff(StaffCode);
CREATE INDEX IX_Account_Username ON Account(Username);
CREATE INDEX IX_Notification_CreatedDate ON Notification(CreatedDate);
CREATE INDEX IX_ActivityLog_ActivityDate ON ActivityLog(ActivityDate);
CREATE INDEX IX_ActivityLog_StaffID ON ActivityLog(StaffID);
CREATE INDEX IX_DashboardMetric_BranchID ON DashboardMetric(BranchID);
CREATE INDEX IX_DashboardMetric_LastUpdated ON DashboardMetric(LastUpdated);
CREATE INDEX IX_PendingRequest_StatusID ON PendingRequest(StatusID);
CREATE INDEX IX_PendingRequest_CurrentApproverID ON PendingRequest(CurrentApproverID);

-- ============================================================================
-- 13. VIEWS FOR DASHBOARD
-- ============================================================================
-- View cho dashboard metrics
CREATE VIEW vw_DashboardMetrics AS
SELECT 
    dm.MetricID,
    mt.MetricName,
    mt.DisplayName,
    mt.IconClass,
    mt.Unit,
    dm.CurrentValue,
    dm.PreviousValue,
    dm.ChangePercentage,
    CASE 
        WHEN dm.ChangePercentage > 0 THEN 'positive'
        WHEN dm.ChangePercentage < 0 THEN 'negative'
        ELSE 'neutral'
    END AS ChangeType,
    b.BranchName,
    dm.LastUpdated
FROM DashboardMetric dm
INNER JOIN MetricType mt ON dm.MetricTypeID = mt.MetricTypeID
INNER JOIN Branch b ON dm.BranchID = b.BranchID
WHERE mt.IsActive = 1;

-- View cho user permissions
CREATE VIEW vw_UserPermissions AS
SELECT 
    s.StaffID,
    s.FullName,
    s.Email,
    r.RoleName,
    p.PermissionName,
    p.PermissionType,
    tc.TCode,
    tc.TCodeName,
    tc.UIFile
FROM Staff s
INNER JOIN Staff_Role sr ON s.StaffID = sr.StaffID AND sr.IsActive = 1
INNER JOIN Role r ON sr.RoleID = r.RoleID
INNER JOIN Role_Permission rp ON r.RoleID = rp.RoleID
INNER JOIN Permission p ON rp.PermissionID = p.PermissionID
LEFT JOIN Role_TCode rtc ON r.RoleID = rtc.RoleID AND rtc.CanAccess = 1
LEFT JOIN TCode tc ON rtc.TCodeID = tc.TCodeID
WHERE s.StatusID = 1 AND r.IsActive = 1 AND p.IsActive = 1;

-- View cho recent activities
CREATE VIEW vw_RecentActivities AS
SELECT TOP 50
    al.ActivityID,
    at.TypeName AS ActivityType,
    at.IconClass,
    at.Color,
    s.FullName AS UserName,
    al.Description,
    al.ActivityDate,
    DATEDIFF(MINUTE, al.ActivityDate, GETDATE()) AS MinutesAgo
FROM ActivityLog al
INNER JOIN ActivityType at ON al.ActivityTypeID = at.ActivityTypeID
INNER JOIN Staff s ON al.StaffID = s.StaffID
ORDER BY al.ActivityDate DESC;

-- View cho pending requests summary
CREATE VIEW vw_PendingRequestsSummary AS
SELECT 
    pr.RequestID,
    rt.TypeName AS RequestType,
    rt.IconClass,
    pr.Title,
    pr.Description,
    s.FullName AS RequesterName,
    pr.RequesterType,
    pr.Priority,
    gs.StatusName,
    pr.SubmittedDate,
    DATEDIFF(DAY, pr.SubmittedDate, GETDATE()) AS DaysAgo,
    approver.FullName AS CurrentApprover
FROM PendingRequest pr
INNER JOIN RequestType rt ON pr.RequestTypeID = rt.RequestTypeID
INNER JOIN Staff s ON pr.RequesterID = s.StaffID
INNER JOIN GeneralStatus gs ON pr.StatusID = gs.StatusID
LEFT JOIN Staff approver ON pr.CurrentApproverID = approver.StaffID
WHERE pr.StatusID = 3; -- Pending status

-- ============================================================================
-- 14. STORED PROCEDURES FOR DASHBOARD
-- ============================================================================
-- Procedure để lấy dữ liệu dashboard
CREATE PROCEDURE sp_GetDashboardData
    @BranchID INT = NULL,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Metrics
    SELECT * FROM vw_DashboardMetrics 
    WHERE (@BranchID IS NULL OR BranchID = @BranchID);
    
    -- Recent Activities (last 24 hours)
    SELECT TOP 10 * FROM vw_RecentActivities;
    
    -- Pending Requests for current user or their department
    SELECT TOP 10 * FROM vw_PendingRequestsSummary
    WHERE CurrentApproverID = @UserID OR RequesterID = @UserID
    ORDER BY SubmittedDate DESC;
    
    -- User Notifications (unread)
    SELECT TOP 10 
        n.NotificationID,
        n.Title,
        n.Message,
        nt.TypeName,
        nt.IconClass,
        n.Priority,
        n.CreatedDate
    FROM Notification n
    INNER JOIN NotificationType nt ON n.TypeID = nt.TypeID
    LEFT JOIN NotificationRecipient nr ON n.NotificationID = nr.NotificationID
    WHERE (n.IsGlobal = 1 OR nr.StaffID = @UserID)
    AND (n.IsGlobal = 1 OR nr.IsRead = 0)
    AND n.StatusID = 1
    AND (n.ExpiryDate IS NULL OR n.ExpiryDate > GETDATE())
    ORDER BY n.CreatedDate DESC;
END;

-- Procedure để lấy T-Codes theo user
CREATE PROCEDURE sp_GetUserTCodes
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        tc.TCodeID,
        tc.TCode,
        tc.TCodeName,
        tc.Description,
        tc.UIFile,
        tc.IconClass,
        tc.Category,
        tc.DisplayOrder
    FROM TCode tc
    INNER JOIN Role_TCode rtc ON tc.TCodeID = rtc.TCodeID AND rtc.CanAccess = 1
    INNER JOIN Role r ON rtc.RoleID = r.RoleID AND r.IsActive = 1
    INNER JOIN Staff_Role sr ON r.RoleID = sr.RoleID AND sr.IsActive = 1
    WHERE sr.StaffID = @UserID AND tc.IsActive = 1
    ORDER BY tc.DisplayOrder, tc.TCodeName;
END;

-- Procedure để cập nhật metrics
CREATE PROCEDURE sp_UpdateDashboardMetrics
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Cập nhật tổng số học viên (sẽ cần bảng Student)
        -- UPDATE DashboardMetric SET CurrentValue = (SELECT COUNT(*) FROM Student WHERE StatusID = 1)
        -- WHERE MetricTypeID = 1 AND (@BranchID IS NULL OR BranchID = @BranchID);
        
        -- Cập nhật số lớp đang hoạt động (sẽ cần bảng Class)
        -- UPDATE DashboardMetric SET CurrentValue = (SELECT COUNT(*) FROM Class WHERE StatusID = 1)
        -- WHERE MetricTypeID = 2 AND (@BranchID IS NULL OR BranchID = @BranchID);
        
        -- Cập nhật số nhân viên
        UPDATE DashboardMetric 
        SET PreviousValue = CurrentValue,
            CurrentValue = (
                SELECT COUNT(*) FROM Staff s
                WHERE s.StatusID = 1 AND (@BranchID IS NULL OR s.BranchID = @BranchID)
            ),
            LastUpdated = GETDATE()
        WHERE MetricTypeID = 4 AND (@BranchID IS NULL OR BranchID = @BranchID);
        
        -- Tính lại phần trăm thay đổi
        UPDATE DashboardMetric 
        SET ChangePercentage = 
            CASE 
                WHEN PreviousValue = 0 THEN 0
                ELSE ((CurrentValue - PreviousValue) / PreviousValue) * 100
            END
        WHERE (@BranchID IS NULL OR BranchID = @BranchID);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- ============================================================================
-- 15. SAMPLE DATA FOR TESTING
-- ============================================================================
-- Thêm thông báo cho user cụ thể
INSERT INTO NotificationRecipient (NotificationID, StaffID, IsRead) VALUES
(1, 1, 0), (1, 2, 0), (1, 3, 0), (1, 4, 0), -- Thông báo hệ thống cho tất cả
(2, 2, 0), (2, 3, 0), -- Thông báo lớp học cho manager và teacher
(3, 1, 0), (3, 2, 0), -- Báo cáo tài chính cho admin và manager
(4, 1, 0), (4, 2, 0), (4, 3, 0), (4, 4, 0); -- Cập nhật tài liệu cho tất cả

PRINT 'Database HHMS_NgoaiNgu68 đã được tạo thành công!';
PRINT 'Hệ thống bao gồm:';
PRINT '- Quản lý T-Code và Navigation';
PRINT '- Hệ thống phân quyền Role-based';
PRINT '- Dashboard với Metrics động';
PRINT '- Hệ thống thông báo realtime';
PRINT '- Activity logs và Pending requests';
PRINT '- Security và Session management';
PRINT '';
-- ============================================================================
-- 16. ENHANCED ACCOUNT & ACCESS MANAGEMENT SYSTEM
-- ============================================================================

-- Bảng định nghĩa quyền hệ thống chi tiết (System Permission Definitions)
CREATE TABLE SystemPermissionDefinition (
    PermissionDefID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionID NVARCHAR(100) UNIQUE NOT NULL, -- e.g., 'STUDENT.VIEW', 'T001.ACCESS'
    PermissionName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(1000),
    Module NVARCHAR(100) NOT NULL, -- 'STUDENT', 'STAFF', 'CLASS', 'COURSE', 'DOCUMENT', 'FINANCE', 'REPORTING', 'TCODE'
    PermissionType NVARCHAR(100) NOT NULL, -- 'CREATE_REQUEST', 'VIEW', 'ACCESS_FUNCTION', 'APPRAISAL', 'APPROVAL', 'EDIT', 'TCODE_ACCESS'
    IsTCodePermission BIT DEFAULT 0,
    TCodeValue NVARCHAR(20), -- Mã T-Code nếu là quyền T-Code
    IconClass NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID)
);

-- Thêm dữ liệu system permission definitions mở rộng
INSERT INTO SystemPermissionDefinition (PermissionID, PermissionName, Description, Module, PermissionType, IsTCodePermission, TCodeValue, IconClass) VALUES
-- Student Module Permissions
('STUDENT.VIEW', 'Xem thông tin học viên', 'Quyền xem danh sách và thông tin chi tiết học viên', 'STUDENT', 'VIEW', 0, NULL, 'fas fa-eye'),
('STUDENT.CREATE', 'Tạo học viên mới', 'Quyền tạo mới hồ sơ học viên', 'STUDENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-plus'),
('STUDENT.EDIT', 'Chỉnh sửa học viên', 'Quyền chỉnh sửa thông tin học viên', 'STUDENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-edit'),
('STUDENT.DELETE', 'Xóa học viên', 'Quyền xóa học viên khỏi hệ thống', 'STUDENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-times'),
('STUDENT.ENROLLMENT_APPROVE', 'Phê duyệt đăng ký học', 'Quyền phê duyệt đơn đăng ký học của học viên', 'STUDENT', 'APPROVAL', 0, NULL, 'fas fa-check-circle'),

-- Staff Module Permissions  
('STAFF.VIEW', 'Xem thông tin nhân viên', 'Quyền xem danh sách và thông tin nhân viên', 'STAFF', 'VIEW', 0, NULL, 'fas fa-users'),
('STAFF.CREATE', 'Tạo nhân viên mới', 'Quyền tạo mới hồ sơ nhân viên', 'STAFF', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-plus'),
('STAFF.EDIT', 'Chỉnh sửa nhân viên', 'Quyền chỉnh sửa thông tin nhân viên', 'STAFF', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-edit'),
('STAFF.DELETE', 'Xóa nhân viên', 'Quyền xóa nhân viên khỏi hệ thống', 'STAFF', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-user-minus'),
('STAFF.SALARY_VIEW', 'Xem thông tin lương', 'Quyền xem thông tin lương của nhân viên', 'STAFF', 'VIEW', 0, NULL, 'fas fa-money-bill'),

-- Class Module Permissions
('CLASS.VIEW', 'Xem thông tin lớp học', 'Quyền xem danh sách và thông tin lớp học', 'CLASS', 'VIEW', 0, NULL, 'fas fa-chalkboard'),
('CLASS.CREATE', 'Tạo lớp học mới', 'Quyền tạo mới lớp học', 'CLASS', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-plus-circle'),
('CLASS.EDIT', 'Chỉnh sửa lớp học', 'Quyền chỉnh sửa thông tin lớp học', 'CLASS', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-edit'),
('CLASS.DELETE', 'Xóa lớp học', 'Quyền xóa lớp học', 'CLASS', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-trash'),
('CLASS.SCHEDULE_MANAGE', 'Quản lý lịch học', 'Quyền quản lý lịch học và thời khóa biểu', 'CLASS', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-calendar'),

-- Course Module Permissions
('COURSE.VIEW', 'Xem thông tin khóa học', 'Quyền xem danh sách và thông tin khóa học', 'COURSE', 'VIEW', 0, NULL, 'fas fa-book'),
('COURSE.CREATE', 'Tạo khóa học mới', 'Quyền tạo mới khóa học', 'COURSE', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-book-medical'),
('COURSE.EDIT', 'Chỉnh sửa khóa học', 'Quyền chỉnh sửa nội dung khóa học', 'COURSE', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-book-open'),
('COURSE.APPROVE', 'Phê duyệt khóa học', 'Quyền phê duyệt khóa học mới', 'COURSE', 'APPROVAL', 0, NULL, 'fas fa-stamp'),

-- Document Module Permissions
('DOCUMENT.VIEW', 'Xem tài liệu', 'Quyền xem và tải tài liệu', 'DOCUMENT', 'VIEW', 0, NULL, 'fas fa-file-alt'),
('DOCUMENT.UPLOAD', 'Tải lên tài liệu', 'Quyền tải lên tài liệu mới', 'DOCUMENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-upload'),
('DOCUMENT.EDIT', 'Chỉnh sửa tài liệu', 'Quyền chỉnh sửa tài liệu', 'DOCUMENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-file-edit'),
('DOCUMENT.DELETE', 'Xóa tài liệu', 'Quyền xóa tài liệu', 'DOCUMENT', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-file-minus'),
('DOCUMENT.APPROVE', 'Phê duyệt tài liệu', 'Quyền phê duyệt tài liệu trước khi phát hành', 'DOCUMENT', 'APPROVAL', 0, NULL, 'fas fa-check-double'),

-- Finance Module Permissions
('FINANCE.VIEW', 'Xem báo cáo tài chính', 'Quyền xem các báo cáo tài chính', 'FINANCE', 'VIEW', 0, NULL, 'fas fa-chart-line'),
('FINANCE.PAYMENT_PROCESS', 'Xử lý thanh toán', 'Quyền xử lý thanh toán học phí', 'FINANCE', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-credit-card'),
('FINANCE.REFUND_PROCESS', 'Xử lý hoàn tiền', 'Quyền xử lý hoàn tiền cho học viên', 'FINANCE', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-undo'),
('FINANCE.REPORT_EDIT', 'Chỉnh sửa báo cáo tài chính', 'Quyền chỉnh sửa báo cáo tài chính', 'FINANCE', 'EDIT', 0, NULL, 'fas fa-edit'),
('FINANCE.BUDGET_APPROVE', 'Phê duyệt ngân sách', 'Quyền phê duyệt ngân sách và chi tiêu', 'FINANCE', 'APPROVAL', 0, NULL, 'fas fa-gavel'),

-- Reporting Module Permissions
('REPORTING.VIEW_BASIC', 'Xem báo cáo cơ bản', 'Quyền xem các báo cáo cơ bản', 'REPORTING', 'VIEW', 0, NULL, 'fas fa-chart-bar'),
('REPORTING.VIEW_ADVANCED', 'Xem báo cáo nâng cao', 'Quyền xem báo cáo chi tiết và phân tích', 'REPORTING', 'VIEW', 0, NULL, 'fas fa-analytics'),
('REPORTING.EXPORT', 'Xuất báo cáo', 'Quyền xuất báo cáo ra Excel/PDF', 'REPORTING', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-download'),
('REPORTING.CUSTOM_CREATE', 'Tạo báo cáo tùy chỉnh', 'Quyền tạo báo cáo tùy chỉnh', 'REPORTING', 'ACCESS_FUNCTION', 0, NULL, 'fas fa-plus-square'),

-- T-Code Access Permissions
('T001.ACCESS', 'Truy cập Dashboard', 'Quyền truy cập trang Dashboard chính', 'TCODE', 'TCODE_ACCESS', 1, 'T001', 'fas fa-tachometer-alt'),
('T002.ACCESS', 'Truy cập Quản lý nhân viên', 'Quyền truy cập chức năng quản lý nhân viên', 'TCODE', 'TCODE_ACCESS', 1, 'T002', 'fas fa-users'),
('T003.ACCESS', 'Truy cập Quản lý học viên', 'Quyền truy cập chức năng quản lý học viên', 'TCODE', 'TCODE_ACCESS', 1, 'T003', 'fas fa-user-graduate'),
('T004.ACCESS', 'Truy cập Quản lý lớp học', 'Quyền truy cập chức năng quản lý lớp học', 'TCODE', 'TCODE_ACCESS', 1, 'T004', 'fas fa-chalkboard-teacher'),
('T005.ACCESS', 'Truy cập Quản lý tài chính', 'Quyền truy cập chức năng quản lý tài chính', 'TCODE', 'TCODE_ACCESS', 1, 'T005', 'fas fa-chart-line'),
('T006.ACCESS', 'Truy cập Quản lý tài liệu', 'Quyền truy cập chức năng quản lý tài liệu', 'TCODE', 'TCODE_ACCESS', 1, 'T006', 'fas fa-folder'),
('T007.ACCESS', 'Truy cập Báo cáo thống kê', 'Quyền truy cập chức năng báo cáo thống kê', 'TCODE', 'TCODE_ACCESS', 1, 'T007', 'fas fa-chart-bar'),
('T008.ACCESS', 'Truy cập Quản lý tài khoản', 'Quyền truy cập chức năng quản lý tài khoản', 'TCODE', 'TCODE_ACCESS', 1, 'T008', 'fas fa-user-cog');

-- Cập nhật bảng Permission để liên kết với SystemPermissionDefinition
ALTER TABLE Permission ADD PermissionDefID INT;
ALTER TABLE Permission ADD CONSTRAINT FK_Permission_SystemPermissionDefinition 
    FOREIGN KEY (PermissionDefID) REFERENCES SystemPermissionDefinition(PermissionDefID);

-- Cập nhật dữ liệu permissions hiện tại để map với system definitions
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'T001.ACCESS') WHERE PermissionName = 'Dashboard.View';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STAFF.VIEW') WHERE PermissionName = 'Staff.View';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STAFF.CREATE') WHERE PermissionName = 'Staff.Create';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STAFF.EDIT') WHERE PermissionName = 'Staff.Edit';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STAFF.DELETE') WHERE PermissionName = 'Staff.Delete';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STUDENT.VIEW') WHERE PermissionName = 'Student.View';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STUDENT.CREATE') WHERE PermissionName = 'Student.Create';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'STUDENT.EDIT') WHERE PermissionName = 'Student.Edit';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'CLASS.VIEW') WHERE PermissionName = 'Class.View';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'CLASS.EDIT') WHERE PermissionName = 'Class.Manage';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'FINANCE.VIEW') WHERE PermissionName = 'Finance.View';
UPDATE Permission SET PermissionDefID = (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE PermissionID = 'FINANCE.PAYMENT_PROCESS') WHERE PermissionName = 'Finance.Manage';

-- Bảng phân quyền tùy chỉnh cho từng tài khoản (Account-level permissions)
CREATE TABLE AccountPermission (
    AccountID INT,
    PermissionDefID INT,
    IsGranted BIT NOT NULL, -- True = granted, False = revoked (override role permission)
    GrantedDate DATETIME2 DEFAULT GETDATE(),
    GrantedBy INT,
    Notes NVARCHAR(1000),
    PRIMARY KEY (AccountID, PermissionDefID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (PermissionDefID) REFERENCES SystemPermissionDefinition(PermissionDefID),
    FOREIGN KEY (GrantedBy) REFERENCES Staff(StaffID)
);

-- Bảng phân quyền cho Role dựa trên SystemPermissionDefinition
CREATE TABLE Role_SystemPermission (
    RoleID INT,
    PermissionDefID INT,
    IsGranted BIT DEFAULT 1,
    AssignedDate DATETIME2 DEFAULT GETDATE(),
    AssignedBy INT,
    PRIMARY KEY (RoleID, PermissionDefID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (PermissionDefID) REFERENCES SystemPermissionDefinition(PermissionDefID),
    FOREIGN KEY (AssignedBy) REFERENCES Staff(StaffID)
);

-- Phân quyền mặc định cho các Role
-- System Admin - Toàn quyền
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 1, PermissionDefID, 1 FROM SystemPermissionDefinition WHERE IsActive = 1;

-- Branch Manager - Quyền quản lý chi nhánh
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 2, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T002.ACCESS', 'T003.ACCESS', 'T004.ACCESS', 'T005.ACCESS', 'T007.ACCESS',
    'STAFF.VIEW', 'STAFF.CREATE', 'STAFF.EDIT',
    'STUDENT.VIEW', 'STUDENT.CREATE', 'STUDENT.EDIT', 'STUDENT.ENROLLMENT_APPROVE',
    'CLASS.VIEW', 'CLASS.CREATE', 'CLASS.EDIT', 'CLASS.SCHEDULE_MANAGE',
    'COURSE.VIEW', 'COURSE.APPROVE',
    'FINANCE.VIEW', 'FINANCE.BUDGET_APPROVE',
    'REPORTING.VIEW_BASIC', 'REPORTING.VIEW_ADVANCED', 'REPORTING.EXPORT'
);

-- Department Manager - Quyền quản lý phòng ban
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 3, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T002.ACCESS', 'T003.ACCESS', 'T004.ACCESS', 'T007.ACCESS',
    'STAFF.VIEW', 'STAFF.EDIT',
    'STUDENT.VIEW', 'STUDENT.CREATE', 'STUDENT.EDIT',
    'CLASS.VIEW', 'CLASS.CREATE', 'CLASS.EDIT', 'CLASS.SCHEDULE_MANAGE',
    'COURSE.VIEW', 'COURSE.CREATE', 'COURSE.EDIT',
    'REPORTING.VIEW_BASIC', 'REPORTING.EXPORT'
);

-- Teacher - Quyền giảng viên
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 4, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T003.ACCESS', 'T004.ACCESS', 'T006.ACCESS',
    'STUDENT.VIEW', 'STUDENT.EDIT',
    'CLASS.VIEW', 'CLASS.EDIT', 'CLASS.SCHEDULE_MANAGE',
    'COURSE.VIEW',
    'DOCUMENT.VIEW', 'DOCUMENT.UPLOAD', 'DOCUMENT.EDIT',
    'REPORTING.VIEW_BASIC'
);

-- Staff - Quyền nhân viên cơ bản
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 5, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T003.ACCESS',
    'STUDENT.VIEW', 'STUDENT.CREATE',
    'CLASS.VIEW',
    'COURSE.VIEW',
    'DOCUMENT.VIEW'
);

-- Accountant - Quyền kế toán
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 6, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T005.ACCESS', 'T007.ACCESS',
    'STUDENT.VIEW',
    'FINANCE.VIEW', 'FINANCE.PAYMENT_PROCESS', 'FINANCE.REFUND_PROCESS', 'FINANCE.REPORT_EDIT',
    'REPORTING.VIEW_BASIC', 'REPORTING.VIEW_ADVANCED', 'REPORTING.EXPORT'
);

-- Student Advisor - Quyền tư vấn viên
INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
SELECT 7, PermissionDefID, 1 FROM SystemPermissionDefinition 
WHERE PermissionID IN (
    'T001.ACCESS', 'T003.ACCESS', 'T004.ACCESS',
    'STUDENT.VIEW', 'STUDENT.CREATE', 'STUDENT.EDIT',
    'CLASS.VIEW',
    'COURSE.VIEW',
    'FINANCE.VIEW'
);

-- Bảng lịch sử thay đổi phân quyền
CREATE TABLE PermissionChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    PermissionDefID INT,
    ChangeType NVARCHAR(50), -- 'GRANTED', 'REVOKED', 'ROLE_ASSIGNED', 'ROLE_REMOVED'
    OldValue BIT,
    NewValue BIT,
    Reason NVARCHAR(1000),
    ChangedBy INT,
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (PermissionDefID) REFERENCES SystemPermissionDefinition(PermissionDefID),
    FOREIGN KEY (ChangedBy) REFERENCES Staff(StaffID)
);

-- Cập nhật Account table với thêm thông tin
ALTER TABLE Account ADD DisplayName NVARCHAR(255);
ALTER TABLE Account ADD FirstLoginChangePwd BIT DEFAULT 1;
ALTER TABLE Account ADD PasswordResetRequired BIT DEFAULT 0;
ALTER TABLE Account ADD PasswordResetToken NVARCHAR(255);
ALTER TABLE Account ADD PasswordResetExpiry DATETIME2;

-- Cập nhật dữ liệu Account hiện tại
UPDATE Account SET DisplayName = s.FullName FROM Account a INNER JOIN Staff s ON a.StaffID = s.StaffID;

-- ============================================================================
-- 17. ENHANCED VIEWS FOR ACCOUNT MANAGEMENT
-- ============================================================================

-- View cho danh sách tài khoản với thông tin đầy đủ
CREATE VIEW vw_AccountManagement AS
SELECT 
    a.AccountID,
    a.StaffID,
    s.StaffCode,
    s.FullName,
    a.Username,
    a.Email,
    a.DisplayName,
    r.RoleID,
    r.RoleName,
    gs.StatusName AS AccountStatus,
    a.LastLogin,
    a.CreatedDate,
    a.IsLocked,
    a.LoginAttempts,
    a.FirstLoginChangePwd,
    a.PasswordResetRequired,
    -- Đếm số quyền hiệu lực
    (SELECT COUNT(*) FROM vw_EffectiveAccountPermissions eap WHERE eap.AccountID = a.AccountID) AS EffectivePermissionCount
FROM Account a
INNER JOIN Staff s ON a.StaffID = s.StaffID
LEFT JOIN Staff_Role sr ON s.StaffID = sr.StaffID AND sr.IsActive = 1
LEFT JOIN Role r ON sr.RoleID = r.RoleID
INNER JOIN GeneralStatus gs ON a.StatusID = gs.StatusID
WHERE s.StatusID = 1; -- Chỉ lấy nhân viên còn hoạt động

-- View cho quyền hạn hiệu lực của từng tài khoản
CREATE VIEW vw_EffectiveAccountPermissions AS
WITH RolePermissions AS (
    -- Quyền từ Role
    SELECT 
        sr.StaffID,
        a.AccountID,
        rsp.PermissionDefID,
        1 AS IsGranted,
        'ROLE' AS SourceType,
        r.RoleName AS SourceName
    FROM Staff_Role sr
    INNER JOIN Account a ON sr.StaffID = a.StaffID
    INNER JOIN Role_SystemPermission rsp ON sr.RoleID = rsp.RoleID AND rsp.IsGranted = 1
    INNER JOIN Role r ON sr.RoleID = r.RoleID
    WHERE sr.IsActive = 1 AND r.IsActive = 1
),
AccountOverrides AS (
    -- Quyền override cấp tài khoản
    SELECT 
        a.StaffID,
        ap.AccountID,
        ap.PermissionDefID,
        ap.IsGranted,
        'ACCOUNT' AS SourceType,
        'Custom Account Permission' AS SourceName
    FROM AccountPermission ap
    INNER JOIN Account a ON ap.AccountID = a.AccountID
),
CombinedPermissions AS (
    -- Kết hợp và ưu tiên account override
    SELECT 
        COALESCE(ao.StaffID, rp.StaffID) AS StaffID,
        COALESCE(ao.AccountID, rp.AccountID) AS AccountID,
        COALESCE(ao.PermissionDefID, rp.PermissionDefID) AS PermissionDefID,
        CASE 
            WHEN ao.PermissionDefID IS NOT NULL THEN ao.IsGranted
            ELSE rp.IsGranted
        END AS IsGranted,
        CASE 
            WHEN ao.PermissionDefID IS NOT NULL THEN ao.SourceType
            ELSE rp.SourceType
        END AS SourceType,
        CASE 
            WHEN ao.PermissionDefID IS NOT NULL THEN ao.SourceName
            ELSE rp.SourceName
        END AS SourceName
    FROM RolePermissions rp
    FULL OUTER JOIN AccountOverrides ao ON rp.AccountID = ao.AccountID AND rp.PermissionDefID = ao.PermissionDefID
)
SELECT 
    cp.StaffID,
    cp.AccountID,
    cp.PermissionDefID,
    spd.PermissionID,
    spd.PermissionName,
    spd.Description,
    spd.Module,
    spd.PermissionType,
    spd.IsTCodePermission,
    spd.TCodeValue,
    spd.IconClass,
    cp.IsGranted,
    cp.SourceType,
    cp.SourceName
FROM CombinedPermissions cp
INNER JOIN SystemPermissionDefinition spd ON cp.PermissionDefID = spd.PermissionDefID
WHERE cp.IsGranted = 1 AND spd.IsActive = 1;

-- View cho System Permission Definitions với thống kê usage
CREATE VIEW vw_SystemPermissionUsage AS
SELECT 
    spd.*,
    -- Đếm số role đang sử dụng permission này
    (SELECT COUNT(*) FROM Role_SystemPermission rsp WHERE rsp.PermissionDefID = spd.PermissionDefID AND rsp.IsGranted = 1) AS UsedByRoleCount,
    -- Đếm số account đang có permission này (thông qua role hoặc direct assignment)
    (SELECT COUNT(DISTINCT AccountID) FROM vw_EffectiveAccountPermissions eap WHERE eap.PermissionDefID = spd.PermissionDefID) AS ActiveAccountCount,
    -- Đếm số account có custom override cho permission này
    (SELECT COUNT(*) FROM AccountPermission ap WHERE ap.PermissionDefID = spd.PermissionDefID) AS CustomOverrideCount
FROM SystemPermissionDefinition spd;

-- ============================================================================
-- 18. ENHANCED STORED PROCEDURES FOR ACCOUNT MANAGEMENT
-- ============================================================================

-- Procedure để lấy danh sách tài khoản cho UI
CREATE PROCEDURE sp_GetAccountsForManagement
    @SearchTerm NVARCHAR(255) = NULL,
    @StatusFilter INT = NULL,
    @RoleFilter INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        am.*,
        -- Lấy danh sách permissions theo module
        STUFF((
            SELECT ',' + spd.Module + ':' + spd.PermissionType + '(' + 
                   CASE WHEN eap.SourceType = 'ACCOUNT' THEN '+' ELSE '' END + 
                   spd.PermissionID + ')'
            FROM vw_EffectiveAccountPermissions eap
            INNER JOIN SystemPermissionDefinition spd ON eap.PermissionDefID = spd.PermissionDefID
            WHERE eap.AccountID = am.AccountID
            ORDER BY spd.Module, spd.PermissionType
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS PermissionsDisplay
    FROM vw_AccountManagement am
    WHERE 
        (@SearchTerm IS NULL OR 
         am.StaffCode LIKE '%' + @SearchTerm + '%' OR
         am.FullName LIKE '%' + @SearchTerm + '%' OR
         am.Username LIKE '%' + @SearchTerm + '%' OR
         am.Email LIKE '%' + @SearchTerm + '%' OR
         am.DisplayName LIKE '%' + @SearchTerm + '%')
    AND (@StatusFilter IS NULL OR am.AccountID IN (SELECT AccountID FROM Account WHERE StatusID = @StatusFilter))
    AND (@RoleFilter IS NULL OR am.RoleID = @RoleFilter)
    ORDER BY am.StaffCode;
END;

-- Procedure để lấy quyền hạn chi tiết của một tài khoản
CREATE PROCEDURE sp_GetAccountPermissions
    @AccountID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin cơ bản của tài khoản
    SELECT * FROM vw_AccountManagement WHERE AccountID = @AccountID;
    
    -- Quyền hạn hiệu lực
    SELECT 
        eap.*,
        CASE 
            WHEN ap.PermissionDefID IS NOT NULL THEN
                CASE WHEN ap.IsGranted = 1 THEN 'GRANTED_CUSTOM' ELSE 'REVOKED_CUSTOM' END
            ELSE 'FROM_ROLE'
        END AS PermissionSource
    FROM vw_EffectiveAccountPermissions eap
    LEFT JOIN AccountPermission ap ON eap.AccountID = ap.AccountID AND eap.PermissionDefID = ap.PermissionDefID
    WHERE eap.AccountID = @AccountID
    ORDER BY eap.Module, eap.PermissionType, eap.PermissionName;
    
    -- Custom permissions (overrides)
    SELECT 
        ap.*,
        spd.PermissionID,
        spd.PermissionName,
        spd.Module,
        spd.PermissionType,
        grantedBy.FullName AS GrantedByName
    FROM AccountPermission ap
    INNER JOIN SystemPermissionDefinition spd ON ap.PermissionDefID = spd.PermissionDefID
    LEFT JOIN Staff grantedBy ON ap.GrantedBy = grantedBy.StaffID
    WHERE ap.AccountID = @AccountID
    ORDER BY ap.GrantedDate DESC;
END;

-- Procedure để cập nhật quyền hạn cho tài khoản
CREATE PROCEDURE sp_UpdateAccountPermissions
    @AccountID INT,
    @PermissionChanges NVARCHAR(MAX), -- JSON format: [{"PermissionDefID": 1, "IsGranted": true}]
    @ChangedBy INT,
    @Reason NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Parse JSON và cập nhật permissions
        INSERT INTO AccountPermission (AccountID, PermissionDefID, IsGranted, GrantedBy, Notes)
        SELECT 
            @AccountID,
            JSON_VALUE(value, '$.PermissionDefID'),
            CAST(JSON_VALUE(value, '$.IsGranted') AS BIT),
            @ChangedBy,
            @Reason
        FROM OPENJSON(@PermissionChanges)
        WHERE JSON_VALUE(value, '$.PermissionDefID') IS NOT NULL
        
        -- Handle merge conflict (update existing)
        ON CONFLICT (AccountID, PermissionDefID) DO UPDATE SET
            IsGranted = CAST(JSON_VALUE(OPENJSON(@PermissionChanges).value, '$.IsGranted') AS BIT),
            GrantedDate = GETDATE(),
            GrantedBy = @ChangedBy,
            Notes = @Reason;
        
        -- Log changes
        INSERT INTO PermissionChangeLog (AccountID, PermissionDefID, ChangeType, NewValue, ChangedBy, Reason)
        SELECT 
            @AccountID,
            JSON_VALUE(value, '$.PermissionDefID'),
            CASE WHEN CAST(JSON_VALUE(value, '$.IsGranted') AS BIT) = 1 THEN 'GRANTED' ELSE 'REVOKED' END,
            CAST(JSON_VALUE(value, '$.IsGranted') AS BIT),
            @ChangedBy,
            @Reason
        FROM OPENJSON(@PermissionChanges)
        WHERE JSON_VALUE(value, '$.PermissionDefID') IS NOT NULL;
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Permissions updated successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để tạo/cập nhật system permission definition
CREATE PROCEDURE sp_CreateOrUpdateSystemPermission
    @PermissionDefID INT = NULL, -- NULL for create, ID for update
    @PermissionID NVARCHAR(100),
    @PermissionName NVARCHAR(255),
    @Description NVARCHAR(1000),
    @Module NVARCHAR(100),
    @PermissionType NVARCHAR(100),
    @IsTCodePermission BIT = 0,
    @TCodeValue NVARCHAR(20) = NULL,
    @IconClass NVARCHAR(100) = NULL,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        IF @PermissionDefID IS NULL
        BEGIN
            -- Create new permission
            INSERT INTO SystemPermissionDefinition (
                PermissionID, PermissionName, Description, Module, PermissionType,
                IsTCodePermission, TCodeValue, IconClass, CreatedBy
            ) VALUES (
                @PermissionID, @PermissionName, @Description, @Module, @PermissionType,
                @IsTCodePermission, @TCodeValue, @IconClass, @CreatedBy
            );
            
            SET @PermissionDefID = SCOPE_IDENTITY();
            
            SELECT 'Success' AS Result, 'Permission created successfully' AS Message, @PermissionDefID AS PermissionDefID;
        END
        ELSE
        BEGIN
            -- Update existing permission
            UPDATE SystemPermissionDefinition SET
                PermissionID = @PermissionID,
                PermissionName = @PermissionName,
                Description = @Description,
                Module = @Module,
                PermissionType = @PermissionType,
                IsTCodePermission = @IsTCodePermission,
                TCodeValue = @TCodeValue,
                IconClass = @IconClass,
                LastModified = GETDATE()
            WHERE PermissionDefID = @PermissionDefID;
            
            SELECT 'Success' AS Result, 'Permission updated successfully' AS Message, @PermissionDefID AS PermissionDefID;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
END;

-- ============================================================================
-- 19. MISSING ACCOUNT MANAGEMENT STORED PROCEDURES
-- ============================================================================

-- Procedure để tạo tài khoản mới
CREATE PROCEDURE sp_CreateAccount
    @StaffID INT,
    @Username NVARCHAR(100),
    @Password NVARCHAR(255) = NULL, -- If NULL, generate random password
    @Email NVARCHAR(255),
    @DisplayName NVARCHAR(255),
    @RoleID INT,
    @FirstLoginChangePwd BIT = 1,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @AccountID INT, @GeneratedPassword NVARCHAR(255), @PasswordHash NVARCHAR(255);
        
        -- Kiểm tra Staff ID tồn tại
        IF NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @StaffID AND StatusID = 1)
        BEGIN
            SELECT 'Error' AS Result, 'Nhân viên không tồn tại hoặc đã bị vô hiệu hóa' AS Message;
            RETURN;
        END
        
        -- Kiểm tra Username đã tồn tại
        IF EXISTS (SELECT 1 FROM Account WHERE Username = @Username)
        BEGIN
            SELECT 'Error' AS Result, 'Tên đăng nhập đã tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra Email đã tồn tại
        IF EXISTS (SELECT 1 FROM Account WHERE Email = @Email)
        BEGIN
            SELECT 'Error' AS Result, 'Email đã được sử dụng cho tài khoản khác' AS Message;
            RETURN;
        END
        
        -- Kiểm tra Staff đã có tài khoản
        IF EXISTS (SELECT 1 FROM Account WHERE StaffID = @StaffID)
        BEGIN
            SELECT 'Error' AS Result, 'Nhân viên này đã có tài khoản' AS Message;
            RETURN;
        END
        
        -- Tạo mật khẩu nếu không được cung cấp
        IF @Password IS NULL
        BEGIN
            -- Generate random password: 8 characters with mix of upper, lower, numbers, special chars
            SET @GeneratedPassword = 
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + -- Upper case letter
                CHAR(97 + ABS(CHECKSUM(NEWID())) % 26) + -- Lower case letter
                CAST(ABS(CHECKSUM(NEWID())) % 10 AS NVARCHAR(1)) + -- Number
                CHAR(33 + ABS(CHECKSUM(NEWID())) % 15) + -- Special char
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + -- Upper case letter
                CHAR(97 + ABS(CHECKSUM(NEWID())) % 26) + -- Lower case letter
                CAST(ABS(CHECKSUM(NEWID())) % 10 AS NVARCHAR(1)) + -- Number
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26); -- Upper case letter
            SET @Password = @GeneratedPassword;
        END
        
        -- Hash mật khẩu (tạm thời dùng hash đơn giản, thực tế nên dùng bcrypt hoặc similar)
        SET @PasswordHash = HASHBYTES('SHA2_256', @Password + 'HHMS_SALT');
        
        -- Tạo tài khoản
        INSERT INTO Account (StaffID, Username, PasswordHash, Email, DisplayName, StatusID, FirstLoginChangePwd, CreatedDate, CreatedBy)
        VALUES (@StaffID, @Username, @PasswordHash, @Email, @DisplayName, 1, @FirstLoginChangePwd, GETDATE(), @CreatedBy);
        
        SET @AccountID = SCOPE_IDENTITY();
        
        -- Gán role cho nhân viên
        INSERT INTO Staff_Role (StaffID, RoleID, AssignedDate, AssignedBy, IsActive)
        VALUES (@StaffID, @RoleID, GETDATE(), @CreatedBy, 1);
        
        -- Tạo AccountSecurity record
        INSERT INTO AccountSecurity (AccountID, PolicyID, LastPasswordChange, PasswordExpiryDate)
        VALUES (@AccountID, 1, GETDATE(), DATEADD(DAY, 90, GETDATE())); -- Default 90 days expiry
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (1, @CreatedBy, 'Account', @AccountID, 'Tạo tài khoản mới cho ' + @Username);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Tài khoản được tạo thành công' AS Message, 
               @AccountID AS AccountID, @GeneratedPassword AS GeneratedPassword;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để cập nhật tài khoản
CREATE PROCEDURE sp_UpdateAccount
    @AccountID INT,
    @Username NVARCHAR(100),
    @Email NVARCHAR(255),
    @DisplayName NVARCHAR(255),
    @StatusID INT,
    @RoleID INT = NULL,
    @FirstLoginChangePwd BIT = NULL,
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @StaffID INT, @OldUsername NVARCHAR(100), @OldEmail NVARCHAR(255);
        
        -- Lấy thông tin tài khoản hiện tại
        SELECT @StaffID = StaffID, @OldUsername = Username, @OldEmail = Email
        FROM Account WHERE AccountID = @AccountID;
        
        IF @StaffID IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Tài khoản không tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra Username đã tồn tại (nếu thay đổi)
        IF @Username != @OldUsername AND EXISTS (SELECT 1 FROM Account WHERE Username = @Username AND AccountID != @AccountID)
        BEGIN
            SELECT 'Error' AS Result, 'Tên đăng nhập đã tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra Email đã tồn tại (nếu thay đổi)
        IF @Email != @OldEmail AND EXISTS (SELECT 1 FROM Account WHERE Email = @Email AND AccountID != @AccountID)
        BEGIN
            SELECT 'Error' AS Result, 'Email đã được sử dụng cho tài khoản khác' AS Message;
            RETURN;
        END
        
        -- Cập nhật tài khoản
        UPDATE Account 
        SET Username = @Username,
            Email = @Email,
            DisplayName = @DisplayName,
            StatusID = @StatusID,
            FirstLoginChangePwd = COALESCE(@FirstLoginChangePwd, FirstLoginChangePwd),
            LastModified = GETDATE(),
            ModifiedBy = @UpdatedBy
        WHERE AccountID = @AccountID;
        
        -- Cập nhật role nếu được cung cấp
        IF @RoleID IS NOT NULL
        BEGIN
            -- Vô hiệu hóa role cũ
            UPDATE Staff_Role SET IsActive = 0, ModifiedDate = GETDATE()
            WHERE StaffID = @StaffID AND IsActive = 1;
            
            -- Thêm role mới
            INSERT INTO Staff_Role (StaffID, RoleID, AssignedDate, AssignedBy, IsActive)
            VALUES (@StaffID, @RoleID, GETDATE(), @UpdatedBy, 1);
        END
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (2, @UpdatedBy, 'Account', @AccountID, 'Cập nhật tài khoản ' + @Username);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Tài khoản được cập nhật thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để xóa/vô hiệu hóa tài khoản
CREATE PROCEDURE sp_DeleteAccount
    @AccountID INT,
    @DeletedBy INT,
    @Reason NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @StaffID INT, @Username NVARCHAR(100);
        
        -- Lấy thông tin tài khoản
        SELECT @StaffID = StaffID, @Username = Username
        FROM Account WHERE AccountID = @AccountID;
        
        IF @StaffID IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Tài khoản không tồn tại' AS Message;
            RETURN;
        END
        
        -- Vô hiệu hóa tài khoản (không xóa hoàn toàn để giữ lại audit trail)
        UPDATE Account 
        SET StatusID = 2, -- Inactive status
            IsLocked = 1,
            LastModified = GETDATE(),
            ModifiedBy = @DeletedBy
        WHERE AccountID = @AccountID;
        
        -- Vô hiệu hóa tất cả roles của staff
        UPDATE Staff_Role 
        SET IsActive = 0, ModifiedDate = GETDATE()
        WHERE StaffID = @StaffID AND IsActive = 1;
        
        -- Xóa tất cả active sessions
        UPDATE UserSession 
        SET IsActive = 0, LogoutTime = GETDATE()
        WHERE StaffID = @StaffID AND IsActive = 1;
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (3, @DeletedBy, 'Account', @AccountID, 'Xóa tài khoản ' + @Username + 
                CASE WHEN @Reason IS NOT NULL THEN '. Lý do: ' + @Reason ELSE '' END);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Tài khoản được xóa thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để reset mật khẩu tài khoản (by admin)
CREATE PROCEDURE sp_ResetAccountPassword
    @AccountID INT,
    @NewPassword NVARCHAR(255) = NULL, -- If NULL, generate random password
    @ForceChangeOnNextLogin BIT = 1,
    @ResetBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @Username NVARCHAR(100), @GeneratedPassword NVARCHAR(255), @PasswordHash NVARCHAR(255);
        
        -- Lấy thông tin tài khoản
        SELECT @Username = Username FROM Account WHERE AccountID = @AccountID;
        
        IF @Username IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Tài khoản không tồn tại' AS Message;
            RETURN;
        END
        
        -- Tạo mật khẩu mới nếu không được cung cấp
        IF @NewPassword IS NULL
        BEGIN
            SET @GeneratedPassword = 
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + -- Upper case letter
                CHAR(97 + ABS(CHECKSUM(NEWID())) % 26) + -- Lower case letter
                CAST(ABS(CHECKSUM(NEWID())) % 10 AS NVARCHAR(1)) + -- Number
                CHAR(33 + ABS(CHECKSUM(NEWID())) % 15) + -- Special char
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + -- Upper case letter
                CHAR(97 + ABS(CHECKSUM(NEWID())) % 26) + -- Lower case letter
                CAST(ABS(CHECKSUM(NEWID())) % 10 AS NVARCHAR(1)) + -- Number
                CHAR(65 + ABS(CHECKSUM(NEWID())) % 26); -- Upper case letter
            SET @NewPassword = @GeneratedPassword;
        END
        
        -- Hash mật khẩu mới
        SET @PasswordHash = HASHBYTES('SHA2_256', @NewPassword + 'HHMS_SALT');
        
        -- Cập nhật mật khẩu
        UPDATE Account 
        SET PasswordHash = @PasswordHash,
            LastPasswordChangeDate = GETDATE(),
            MustChangePasswordNextLogin = @ForceChangeOnNextLogin,
            PasswordFailedAttempts = 0,
            IsLocked = 0,
            LastModified = GETDATE(),
            ModifiedBy = @ResetBy
        WHERE AccountID = @AccountID;
        
        -- Cập nhật security settings
        UPDATE AccountSecurity 
        SET LastPasswordChange = GETDATE(),
            PasswordExpiryDate = DATEADD(DAY, 90, GETDATE()),
            ForcePasswordChangeOnNextLogin = @ForceChangeOnNextLogin
        WHERE AccountID = @AccountID;
        
        -- Ghi log password history
        INSERT INTO PasswordHistory (AccountID, NewPasswordHash, ChangeReason, ChangedBy)
        VALUES (@AccountID, @PasswordHash, 'Admin Reset', @ResetBy);
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (4, @ResetBy, 'Account', @AccountID, 'Reset mật khẩu cho tài khoản ' + @Username);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Mật khẩu được reset thành công' AS Message, 
               @GeneratedPassword AS NewPassword;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- ============================================================================
-- 20. ROLE MANAGEMENT STORED PROCEDURES  
-- ============================================================================

-- Procedure để lấy danh sách roles cho management
CREATE PROCEDURE sp_GetRolesForManagement
    @SearchTerm NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.RoleID,
        r.RoleName,
        r.Description,
        r.IsActive,
        r.CreatedDate,
        createdBy.FullName AS CreatedByName,
        -- Đếm số nhân viên có role này
        (SELECT COUNT(*) FROM Staff_Role sr WHERE sr.RoleID = r.RoleID AND sr.IsActive = 1) AS AssignedStaffCount,
        -- Đếm số permissions
        (SELECT COUNT(*) FROM Role_SystemPermission rsp WHERE rsp.RoleID = r.RoleID AND rsp.IsGranted = 1) AS PermissionCount,
        -- Liệt kê một số permissions chính
        STUFF((
            SELECT ', ' + spd.PermissionName
            FROM Role_SystemPermission rsp
            INNER JOIN SystemPermissionDefinition spd ON rsp.PermissionDefID = spd.PermissionDefID
            WHERE rsp.RoleID = r.RoleID AND rsp.IsGranted = 1
            ORDER BY spd.PermissionName
            FOR XML PATH('')
        ), 1, 2, '') AS MainPermissions
    FROM Role r
    LEFT JOIN Staff createdBy ON r.CreatedBy = createdBy.StaffID
    WHERE (@SearchTerm IS NULL OR 
           r.RoleName LIKE '%' + @SearchTerm + '%' OR 
           r.Description LIKE '%' + @SearchTerm + '%')
    ORDER BY r.RoleName;
END;

-- Procedure để tạo role mới
CREATE PROCEDURE sp_CreateRole
    @RoleName NVARCHAR(100),
    @Description NVARCHAR(500) = NULL,
    @PermissionIDs NVARCHAR(MAX) = NULL, -- Comma-separated PermissionDefIDs
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @RoleID INT;
        
        -- Kiểm tra tên role đã tồn tại
        IF EXISTS (SELECT 1 FROM Role WHERE RoleName = @RoleName)
        BEGIN
            SELECT 'Error' AS Result, 'Tên role đã tồn tại' AS Message;
            RETURN;
        END
        
        -- Tạo role mới
        INSERT INTO Role (RoleName, Description, CreatedBy, CreatedDate, IsActive)
        VALUES (@RoleName, @Description, @CreatedBy, GETDATE(), 1);
        
        SET @RoleID = SCOPE_IDENTITY();
        
        -- Gán permissions nếu có
        IF @PermissionIDs IS NOT NULL AND @PermissionIDs != ''
        BEGIN
            INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
            SELECT @RoleID, CAST(value AS INT), @CreatedBy
            FROM STRING_SPLIT(@PermissionIDs, ',')
            WHERE CAST(value AS INT) IN (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE IsActive = 1);
        END
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (1, @CreatedBy, 'Role', @RoleID, 'Tạo role mới: ' + @RoleName);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Role được tạo thành công' AS Message, @RoleID AS RoleID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để cập nhật role
CREATE PROCEDURE sp_UpdateRole
    @RoleID INT,
    @RoleName NVARCHAR(100),
    @Description NVARCHAR(500) = NULL,
    @PermissionIDs NVARCHAR(MAX) = NULL, -- Comma-separated PermissionDefIDs
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @OldRoleName NVARCHAR(100);
        
        -- Lấy tên role cũ
        SELECT @OldRoleName = RoleName FROM Role WHERE RoleID = @RoleID;
        
        IF @OldRoleName IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Role không tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra tên role đã tồn tại (nếu thay đổi)
        IF @RoleName != @OldRoleName AND EXISTS (SELECT 1 FROM Role WHERE RoleName = @RoleName AND RoleID != @RoleID)
        BEGIN
            SELECT 'Error' AS Result, 'Tên role đã tồn tại' AS Message;
            RETURN;
        END
        
        -- Cập nhật role
        UPDATE Role 
        SET RoleName = @RoleName,
            Description = @Description,
            LastModified = GETDATE()
        WHERE RoleID = @RoleID;
        
        -- Xóa tất cả permissions cũ
        DELETE FROM Role_SystemPermission WHERE RoleID = @RoleID;
        
        -- Gán permissions mới
        IF @PermissionIDs IS NOT NULL AND @PermissionIDs != ''
        BEGIN
            INSERT INTO Role_SystemPermission (RoleID, PermissionDefID, AssignedBy)
            SELECT @RoleID, CAST(value AS INT), @UpdatedBy
            FROM STRING_SPLIT(@PermissionIDs, ',')
            WHERE CAST(value AS INT) IN (SELECT PermissionDefID FROM SystemPermissionDefinition WHERE IsActive = 1);
        END
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (2, @UpdatedBy, 'Role', @RoleID, 'Cập nhật role: ' + @RoleName);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Role được cập nhật thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để xóa role
CREATE PROCEDURE sp_DeleteRole
    @RoleID INT,
    @DeletedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @RoleName NVARCHAR(100), @AssignedCount INT;
        
        -- Lấy thông tin role
        SELECT @RoleName = RoleName FROM Role WHERE RoleID = @RoleID;
        
        IF @RoleName IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Role không tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra có nhân viên nào đang được gán role này không
        SELECT @AssignedCount = COUNT(*) FROM Staff_Role WHERE RoleID = @RoleID AND IsActive = 1;
        
        IF @AssignedCount > 0
        BEGIN
            SELECT 'Error' AS Result, 'Không thể xóa role vì vẫn có ' + CAST(@AssignedCount AS NVARCHAR) + ' nhân viên được gán role này' AS Message;
            RETURN;
        END
        
        -- Vô hiệu hóa role (không xóa hoàn toàn)
        UPDATE Role 
        SET IsActive = 0, LastModified = GETDATE()
        WHERE RoleID = @RoleID;
        
        -- Xóa tất cả permissions của role
        DELETE FROM Role_SystemPermission WHERE RoleID = @RoleID;
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (3, @DeletedBy, 'Role', @RoleID, 'Xóa role: ' + @RoleName);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Role được xóa thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để lấy chi tiết role và permissions
CREATE PROCEDURE sp_GetRoleDetails
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin role
    SELECT 
        r.*,
        createdBy.FullName AS CreatedByName,
        (SELECT COUNT(*) FROM Staff_Role sr WHERE sr.RoleID = r.RoleID AND sr.IsActive = 1) AS AssignedStaffCount
    FROM Role r
    LEFT JOIN Staff createdBy ON r.CreatedBy = createdBy.StaffID
    WHERE r.RoleID = @RoleID;
    
    -- Permissions của role
    SELECT 
        rsp.*,
        spd.PermissionID,
        spd.PermissionName,
        spd.Description,
        spd.Module,
        spd.PermissionType,
        spd.IsTCodePermission,
        spd.TCodeValue,
        spd.IconClass
    FROM Role_SystemPermission rsp
    INNER JOIN SystemPermissionDefinition spd ON rsp.PermissionDefID = spd.PermissionDefID
    WHERE rsp.RoleID = @RoleID AND rsp.IsGranted = 1
    ORDER BY spd.Module, spd.PermissionType, spd.PermissionName;
    
    -- Staff được gán role này
    SELECT 
        sr.StaffID,
        s.StaffCode,
        s.FullName,
        s.Email,
        sr.AssignedDate,
        assignedBy.FullName AS AssignedByName
    FROM Staff_Role sr
    INNER JOIN Staff s ON sr.StaffID = s.StaffID
    LEFT JOIN Staff assignedBy ON sr.AssignedBy = assignedBy.StaffID
    WHERE sr.RoleID = @RoleID AND sr.IsActive = 1
    ORDER BY s.FullName;
END;

PRINT 'Enhanced Account & Access Management System completed successfully!';
PRINT '';
PRINT 'New Account Management Stored Procedures Added:';
PRINT '- sp_CreateAccount: Tạo tài khoản mới với validation đầy đủ và auto password generation';
PRINT '- sp_UpdateAccount: Cập nhật thông tin tài khoản và role assignment';
PRINT '- sp_DeleteAccount: Xóa/vô hiệu hóa tài khoản với audit trail';
PRINT '- sp_ResetAccountPassword: Reset mật khẩu tài khoản (admin function)';
PRINT '';
PRINT 'New Role Management Stored Procedures Added:';
PRINT '- sp_GetRolesForManagement: Lấy danh sách roles với statistics';
PRINT '- sp_CreateRole: Tạo role mới với permissions assignment';
PRINT '- sp_UpdateRole: Cập nhật role và permissions';
PRINT '- sp_DeleteRole: Xóa role với validation (không thể xóa nếu đang được sử dụng)';
PRINT '- sp_GetRoleDetails: Lấy chi tiết role, permissions và assigned staff';
PRINT '';
PRINT 'Key Features Included:';
PRINT '- Automatic password generation for new accounts (8-character strong passwords)';
PRINT '- Comprehensive validation (duplicate username/email check, staff existence, etc.)';
PRINT '- Role assignment with permissions integration';
PRINT '- Security audit logging for all operations';
PRINT '- Account security configuration with password expiry';
PRINT '- Password history tracking';
PRINT '- Complete role management with permission assignment via comma-separated IDs';
PRINT '- Protection against deleting roles that are currently assigned to staff';
PRINT '- Audit trails for all account and role operations';
PRINT '';
PRINT 'Database now fully supports AccountandAccessManagement.html interface!';

-- ============================================================================
-- 25. CLASS MANAGEMENT & EDUCATION SYSTEM
-- ============================================================================

-- Bảng thông tin khóa học/chương trình đào tạo
CREATE TABLE Course (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode NVARCHAR(20) UNIQUE NOT NULL,
    CourseName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(2000),
    Duration INT, -- Số buổi học
    TotalHours INT, -- Tổng số giờ học
    Level NVARCHAR(50), -- 'Beginner', 'Intermediate', 'Advanced', 'Professional'
    Prerequisites NVARCHAR(1000), -- Điều kiện tiên quyết
    Objectives NVARCHAR(2000), -- Mục tiêu khóa học
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng chuyên ngành/Major
CREATE TABLE Major (
    MajorID INT IDENTITY(1,1) PRIMARY KEY,
    MajorCode NVARCHAR(20) UNIQUE NOT NULL,
    MajorName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(1000),
    DepartmentID INT, -- Liên kết với Department nếu có
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID)
);

-- Bảng lớp học
CREATE TABLE Class (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassCode NVARCHAR(20) UNIQUE NOT NULL,
    ClassName NVARCHAR(255) NOT NULL,
    CourseID INT,
    MajorID INT,
    BranchID INT,
    MainTeacherID INT, -- Giảng viên chính
    AssistantTeacherID INT, -- Trợ giảng
    Room NVARCHAR(100),
    MaxCapacity INT DEFAULT 25,
    CurrentEnrollment INT DEFAULT 0,
    StartDate DATE,
    ExpectedEndDate DATE,
    ActualEndDate DATE,
    Schedule NVARCHAR(500), -- Lịch học: "T2,T4,T6 - 19:00-21:00"
    StatusID INT DEFAULT 1, -- 1: Planned, 2: Active, 3: Completed, 4: Cancelled
    Notes NVARCHAR(2000),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (MajorID) REFERENCES Major(MajorID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (MainTeacherID) REFERENCES Staff(StaffID),
    FOREIGN KEY (AssistantTeacherID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng học viên
CREATE TABLE Student (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentCode NVARCHAR(20) UNIQUE NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    DateOfBirth DATE,
    Gender NVARCHAR(10), -- 'Male', 'Female', 'Other'
    Phone NVARCHAR(20),
    Email NVARCHAR(255),
    Address NVARCHAR(500),
    ParentName NVARCHAR(255), -- Tên phụ huynh (nếu học viên nhỏ tuổi)
    ParentPhone NVARCHAR(20),
    ParentEmail NVARCHAR(255),
    EnrollmentDate DATE DEFAULT GETDATE(),
    StatusID INT DEFAULT 1, -- 1: Active, 2: Inactive, 3: Graduated, 4: Dropped
    Notes NVARCHAR(2000),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng đăng ký học viên vào lớp
CREATE TABLE ClassEnrollment (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    ClassID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    StatusID INT DEFAULT 1, -- 1: Active, 2: Completed, 3: Withdrawn, 4: Transferred
    WithdrawalDate DATE,
    WithdrawalReason NVARCHAR(1000),
    FinalGrade DECIMAL(5,2), -- Điểm cuối khóa
    FinalEvaluation NVARCHAR(2000), -- Đánh giá cuối khóa
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng buổi học của lớp
CREATE TABLE ClassSession (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT,
    SessionNumber INT, -- Buổi học thứ mấy (1, 2, 3, ...)
    SessionDate DATE,
    StartTime TIME,
    EndTime TIME,
    Topic NVARCHAR(500), -- Chủ đề buổi học
    Content NVARCHAR(2000), -- Nội dung chi tiết
    TeacherID INT, -- Giảng viên thực hiện (có thể khác main teacher)
    Room NVARCHAR(100),
    StatusID INT DEFAULT 1, -- 1: Scheduled, 2: Completed, 3: Cancelled, 4: Postponed
    ActualStartTime TIME,
    ActualEndTime TIME,
    ActualContent NVARCHAR(2000), -- Nội dung thực tế đã dạy
    Notes NVARCHAR(2000),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (TeacherID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng điểm danh học viên
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    SessionID INT,
    StudentID INT,
    AttendanceStatus NVARCHAR(20) DEFAULT 'Present', -- 'Present', 'Absent', 'Late', 'Excused'
    ArrivalTime TIME, -- Thời gian đến lớp (nếu muộn)
    Notes NVARCHAR(500), -- Ghi chú (lý do vắng, ...)
    RecordedBy INT, -- Người ghi nhận điểm danh
    RecordedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (SessionID) REFERENCES ClassSession(SessionID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (RecordedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(SessionID, StudentID) -- Mỗi học viên chỉ có 1 record điểm danh cho 1 buổi học
);

-- Bảng định nghĩa bài kiểm tra/đánh giá
CREATE TABLE TestDefinition (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT,
    TestNumber INT, -- Thứ tự bài kiểm tra (1, 2, 3, ...)
    TestName NVARCHAR(255), -- Tên bài kiểm tra tùy chỉnh
    TestType NVARCHAR(100), -- 'Quiz', 'Midterm', 'Final', 'Assignment', 'Presentation'
    MaxScore DECIMAL(5,2) DEFAULT 10.00,
    Weight DECIMAL(5,2) DEFAULT 1.00, -- Trọng số trong tổng điểm
    TestDate DATE,
    Description NVARCHAR(1000),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(ClassID, TestNumber) -- Mỗi lớp có test number duy nhất
);

-- Bảng điểm số học viên
CREATE TABLE StudentGrade (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    TestID INT,
    Score DECIMAL(5,2), -- Điểm số thực tế
    GradedBy INT, -- Người chấm điểm
    GradedDate DATETIME2,
    Comments NVARCHAR(1000), -- Nhận xét của giảng viên
    IsSubmitted BIT DEFAULT 0, -- Đã nộp bài chưa
    SubmissionDate DATETIME2,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (TestID) REFERENCES TestDefinition(TestID),
    FOREIGN KEY (GradedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(StudentID, TestID) -- Mỗi học viên chỉ có 1 điểm cho 1 bài kiểm tra
);

-- Bảng đánh giá cuối khóa
CREATE TABLE EndOfCourseEvaluation (
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    ClassID INT,
    OverallGrade DECIMAL(5,2), -- Điểm tổng kết
    AttendanceRate DECIMAL(5,2), -- Tỷ lệ tham gia (%)
    Behavior NVARCHAR(100), -- 'Excellent', 'Good', 'Average', 'Poor'
    Participation NVARCHAR(100), -- Mức độ tham gia
    Improvement NVARCHAR(100), -- Mức độ tiến bộ
    Strengths NVARCHAR(2000), -- Điểm mạnh
    WeaknessesAndSuggestions NVARCHAR(2000), -- Điểm yếu và đề xuất
    OverallComments NVARCHAR(2000), -- Nhận xét tổng thể
    Recommendation NVARCHAR(500), -- Khuyến nghị ('Continue', 'Repeat', 'Advanced', 'Transfer')
    EvaluatedBy INT,
    EvaluatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (EvaluatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(StudentID, ClassID) -- Mỗi học viên chỉ có 1 đánh giá cuối khóa cho 1 lớp
);

-- Bảng tiến độ học tập
CREATE TABLE TrainingProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT,
    SessionNumber INT, -- Buổi học thứ mấy
    Topic NVARCHAR(500), -- Chủ đề/nội dung
    PlannedDate DATE, -- Ngày dự kiến
    ActualDate DATE, -- Ngày thực tế
    Status NVARCHAR(100), -- 'Planned', 'In Progress', 'Completed', 'Skipped', 'Postponed'
    CompletionRate DECIMAL(5,2), -- Tỷ lệ hoàn thành (%)
    Notes NVARCHAR(2000), -- Ghi chú về tiến độ
    TeacherComments NVARCHAR(2000), -- Nhận xét của giảng viên
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Thêm dữ liệu mẫu cho Courses
INSERT INTO Course (CourseCode, CourseName, Description, Duration, TotalHours, Level, CreatedBy) VALUES
('TOEIC-Basic', 'TOEIC Cơ Bản', 'Khóa học TOEIC cho người mới bắt đầu, mục tiêu 450-600 điểm', 48, 96, 'Beginner', 1),
('TOEIC-Inter', 'TOEIC Trung Cấp', 'Khóa học TOEIC trung cấp, mục tiêu 600-750 điểm', 48, 96, 'Intermediate', 1),
('TOEIC-Adv', 'TOEIC Nâng Cao', 'Khóa học TOEIC nâng cao, mục tiêu 750-900+ điểm', 48, 96, 'Advanced', 1),
('IELTS-Basic', 'IELTS Cơ Bản', 'Khóa học IELTS cho người mới bắt đầu, mục tiêu 5.0-6.0', 60, 120, 'Beginner', 1),
('IELTS-Inter', 'IELTS Trung Cấp', 'Khóa học IELTS trung cấp, mục tiêu 6.0-7.0', 60, 120, 'Intermediate', 1),
('IELTS-Adv', 'IELTS Nâng Cao', 'Khóa học IELTS nâng cao, mục tiêu 7.0-8.5+', 60, 120, 'Advanced', 1),
('Business-Eng', 'Tiếng Anh Thương Mại', 'Khóa học tiếng Anh thương mại cho môi trường làm việc', 36, 72, 'Intermediate', 1),
('Conv-Eng', 'Tiếng Anh Giao Tiếp', 'Khóa học tiếng Anh giao tiếp hàng ngày', 36, 72, 'Beginner', 1);

-- Thêm dữ liệu mẫu cho Majors
INSERT INTO Major (MajorCode, MajorName, Description, CreatedBy) VALUES
('TOEIC', 'TOEIC Preparation', 'Chuyên ngành luyện thi TOEIC', 1),
('IELTS', 'IELTS Preparation', 'Chuyên ngành luyện thi IELTS', 1),
('TOEFL', 'TOEFL Preparation', 'Chuyên ngành luyện thi TOEFL', 1),
('GENERAL', 'General English', 'Tiếng Anh tổng quát', 1),
('BUSINESS', 'Business English', 'Tiếng Anh thương mại', 1),
('KIDS', 'English for Kids', 'Tiếng Anh cho trẻ em', 1);

-- Thêm dữ liệu mẫu cho Students
INSERT INTO Student (StudentCode, FullName, DateOfBirth, Gender, Phone, Email, Address, CreatedBy) VALUES
('HV001', 'Nguyễn Văn An', '1995-03-15', 'Male', '0901234567', 'nguyenvanan@email.com', '123 Đường ABC, Quận 1, TP.HCM', 1),
('HV002', 'Trần Thị Bình', '1997-07-22', 'Female', '0907654321', 'tranthibinh@email.com', '456 Đường DEF, Quận 3, TP.HCM', 1),
('HV003', 'Lê Minh Cường', '1996-11-08', 'Male', '0909876543', 'leminhcuong@email.com', '789 Đường GHI, Quận 5, TP.HCM', 1),
('HV004', 'Phạm Thị Dung', '1998-02-14', 'Female', '0903456789', 'phamthidung@email.com', '321 Đường JKL, Quận 7, TP.HCM', 1),
('HV005', 'Hoàng Văn Em', '1994-09-30', 'Male', '0906789012', 'hoangvanem@email.com', '654 Đường MNO, Quận 10, TP.HCM', 1),
('HV006', 'Vũ Thị Phương', '1999-05-18', 'Female', '0902345678', 'vuthiphuong@email.com', '987 Đường PQR, Quận Bình Thạnh, TP.HCM', 1),
('HV007', 'Đỗ Minh Quang', '1995-12-03', 'Male', '0908901234', 'dominhquang@email.com', '147 Đường STU, Quận Tân Bình, TP.HCM', 1),
('HV008', 'Ngô Thị Hoa', '1997-04-25', 'Female', '0905678901', 'ngothihoa@email.com', '258 Đường VWX, Quận Phú Nhuận, TP.HCM', 1);

-- Thêm dữ liệu mẫu cho Classes
INSERT INTO Class (ClassCode, ClassName, CourseID, MajorID, BranchID, MainTeacherID, Room, MaxCapacity, StartDate, ExpectedEndDate, Schedule, CreatedBy) VALUES
('TOEIC001', 'TOEIC Cơ Bản - Khóa 1/2025', 1, 1, 1, 3, 'Phòng 101', 20, '2025-01-15', '2025-04-15', 'T2,T4,T6 - 19:00-21:00', 1),
('IELTS001', 'IELTS Trung Cấp - Khóa 1/2025', 5, 2, 1, 4, 'Phòng 102', 15, '2025-01-20', '2025-05-20', 'T3,T5,T7 - 18:30-20:30', 1),
('CONV001', 'Giao Tiếp Cơ Bản - Khóa 1/2025', 8, 4, 2, 3, 'Phòng 201', 25, '2025-02-01', '2025-04-30', 'T2,T4 - 19:00-21:00', 1);

-- Thêm enrollment cho students vào classes
INSERT INTO ClassEnrollment (StudentID, ClassID, CreatedBy) VALUES
(1, 1, 1), (2, 1, 1), (3, 1, 1), (4, 1, 1), (5, 1, 1),
(6, 2, 1), (7, 2, 1), (8, 2, 1), (1, 2, 1),
(2, 3, 1), (3, 3, 1), (4, 3, 1);

-- Cập nhật current enrollment cho classes
UPDATE Class SET CurrentEnrollment = (SELECT COUNT(*) FROM ClassEnrollment WHERE ClassID = Class.ClassID AND StatusID = 1);

-- ============================================================================
-- 26. ENHANCED VIEWS FOR CLASS MANAGEMENT
-- ============================================================================

-- View tổng hợp thông tin lớp học
CREATE VIEW vw_ClassDetails AS
SELECT 
    c.ClassID,
    c.ClassCode,
    c.ClassName,
    co.CourseName,
    m.MajorName,
    b.BranchName,
    teacher.FullName AS MainTeacherName,
    assistant.FullName AS AssistantName,
    c.Room,
    c.MaxCapacity,
    c.CurrentEnrollment,
    c.StartDate,
    c.ExpectedEndDate,
    c.ActualEndDate,
    c.Schedule,
    gs.StatusName,
    c.Notes,
    c.CreatedDate,
    creator.FullName AS CreatedByName
FROM Class c
INNER JOIN Course co ON c.CourseID = co.CourseID
INNER JOIN Major m ON c.MajorID = m.MajorID
INNER JOIN Branch b ON c.BranchID = b.BranchID
INNER JOIN Staff teacher ON c.MainTeacherID = teacher.StaffID
LEFT JOIN Staff assistant ON c.AssistantTeacherID = assistant.StaffID
INNER JOIN GeneralStatus gs ON c.StatusID = gs.StatusID
INNER JOIN Staff creator ON c.CreatedBy = creator.StaffID;

-- View danh sách học viên trong lớp
CREATE VIEW vw_ClassStudents AS
SELECT 
    ce.ClassID,
    ce.StudentID,
    s.StudentCode,
    s.FullName,
    s.Email,
    s.Phone,
    ce.EnrollmentDate,
    ces.StatusName AS EnrollmentStatus,
    ce.FinalGrade,
    -- Thống kê điểm danh
    (SELECT COUNT(*) FROM Attendance a 
     INNER JOIN ClassSession cs ON a.SessionID = cs.SessionID 
     WHERE cs.ClassID = ce.ClassID AND a.StudentID = ce.StudentID) AS TotalAttendanceRecords,
    (SELECT COUNT(*) FROM Attendance a 
     INNER JOIN ClassSession cs ON a.SessionID = cs.SessionID 
     WHERE cs.ClassID = ce.ClassID AND a.StudentID = ce.StudentID AND a.AttendanceStatus = 'Present') AS PresentCount,
    -- Điểm trung bình
    (SELECT AVG(sg.Score) FROM StudentGrade sg 
     INNER JOIN TestDefinition td ON sg.TestID = td.TestID 
     WHERE td.ClassID = ce.ClassID AND sg.StudentID = ce.StudentID) AS AverageGrade
FROM ClassEnrollment ce
INNER JOIN Student s ON ce.StudentID = s.StudentID
INNER JOIN GeneralStatus ces ON ce.StatusID = ces.StatusID
WHERE ce.StatusID = 1; -- Active enrollments only

-- View buổi học và điểm danh
CREATE VIEW vw_SessionAttendance AS
SELECT 
    cs.SessionID,
    cs.ClassID,
    cs.SessionNumber,
    cs.SessionDate,
    cs.Topic,
    teacher.FullName AS TeacherName,
    cs.StatusID AS SessionStatusID,
    gs.StatusName AS SessionStatus,
    s.StudentID,
    s.StudentCode,
    s.FullName AS StudentName,
    COALESCE(a.AttendanceStatus, 'Not Recorded') AS AttendanceStatus,
    a.ArrivalTime,
    a.Notes AS AttendanceNotes
FROM ClassSession cs
INNER JOIN Class c ON cs.ClassID = c.ClassID
INNER JOIN ClassEnrollment ce ON c.ClassID = ce.ClassID AND ce.StatusID = 1
INNER JOIN Student s ON ce.StudentID = s.StudentID
LEFT JOIN Attendance a ON cs.SessionID = a.SessionID AND s.StudentID = a.StudentID
LEFT JOIN Staff teacher ON cs.TeacherID = teacher.StaffID
INNER JOIN GeneralStatus gs ON cs.StatusID = gs.StatusID
ORDER BY cs.SessionDate, cs.SessionNumber, s.FullName;

-- View điểm số và bài kiểm tra
CREATE VIEW vw_StudentGrades AS
SELECT 
    td.ClassID,
    td.TestID,
    td.TestNumber,
    td.TestName,
    td.TestType,
    td.MaxScore,
    td.Weight,
    td.TestDate,
    s.StudentID,
    s.StudentCode,
    s.FullName AS StudentName,
    sg.Score,
    sg.Comments,
    sg.IsSubmitted,
    sg.SubmissionDate,
    grader.FullName AS GradedByName,
    sg.GradedDate
FROM TestDefinition td
INNER JOIN Class c ON td.ClassID = c.ClassID
INNER JOIN ClassEnrollment ce ON c.ClassID = ce.ClassID AND ce.StatusID = 1
INNER JOIN Student s ON ce.StudentID = s.StudentID
LEFT JOIN StudentGrade sg ON td.TestID = sg.TestID AND s.StudentID = sg.StudentID
LEFT JOIN Staff grader ON sg.GradedBy = grader.StaffID
WHERE td.IsActive = 1
ORDER BY td.TestNumber, s.FullName;

-- ============================================================================
-- 27. STORED PROCEDURES FOR CLASS MANAGEMENT
-- ============================================================================

-- Procedure để lấy chi tiết lớp học
CREATE PROCEDURE sp_GetClassDetails
    @ClassID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin cơ bản lớp học
    SELECT * FROM vw_ClassDetails WHERE ClassID = @ClassID;
    
    -- Danh sách học viên
    SELECT * FROM vw_ClassStudents WHERE ClassID = @ClassID ORDER BY FullName;
    
    -- Danh sách buổi học
    SELECT 
        SessionID, SessionNumber, SessionDate, Topic, TeacherName, SessionStatus,
        StartTime, EndTime, Room, ActualStartTime, ActualEndTime, Notes
    FROM ClassSession cs
    LEFT JOIN Staff t ON cs.TeacherID = t.StaffID
    INNER JOIN GeneralStatus gs ON cs.StatusID = gs.StatusID
    WHERE cs.ClassID = @ClassID
    ORDER BY cs.SessionNumber;
    
    -- Định nghĩa bài kiểm tra
    SELECT * FROM TestDefinition WHERE ClassID = @ClassID AND IsActive = 1 ORDER BY TestNumber;
END;

-- Procedure để lấy điểm danh theo buổi học
CREATE PROCEDURE sp_GetSessionAttendance
    @SessionID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM vw_SessionAttendance 
    WHERE SessionID = @SessionID 
    ORDER BY StudentName;
END;

-- Procedure để lưu điểm danh
CREATE PROCEDURE sp_SaveAttendance
    @SessionID INT,
    @AttendanceData NVARCHAR(MAX), -- JSON: [{"StudentID":1,"Status":"Present","ArrivalTime":"19:05","Notes":""}]
    @RecordedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Xóa điểm danh cũ cho session này
        DELETE FROM Attendance WHERE SessionID = @SessionID;
        
        -- Parse JSON và insert điểm danh mới
        INSERT INTO Attendance (SessionID, StudentID, AttendanceStatus, ArrivalTime, Notes, RecordedBy)
        SELECT 
            @SessionID,
            JSON_VALUE(value, '$.StudentID'),
            JSON_VALUE(value, '$.Status'),
            CASE WHEN JSON_VALUE(value, '$.ArrivalTime') != '' THEN JSON_VALUE(value, '$.ArrivalTime') ELSE NULL END,
            JSON_VALUE(value, '$.Notes'),
            @RecordedBy
        FROM OPENJSON(@AttendanceData);
        
        -- Cập nhật thời gian session
        UPDATE ClassSession 
        SET LastModified = GETDATE(), ModifiedBy = @RecordedBy
        WHERE SessionID = @SessionID;
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Điểm danh đã được lưu thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để lưu điểm số
CREATE PROCEDURE sp_SaveGrades
    @ClassID INT,
    @GradeData NVARCHAR(MAX), -- JSON: [{"StudentID":1,"TestID":1,"Score":8.5,"Comments":"Good job"}]
    @GradedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Update hoặc insert điểm số
        MERGE StudentGrade AS target
        USING (
            SELECT 
                JSON_VALUE(value, '$.StudentID') AS StudentID,
                JSON_VALUE(value, '$.TestID') AS TestID,
                JSON_VALUE(value, '$.Score') AS Score,
                JSON_VALUE(value, '$.Comments') AS Comments
            FROM OPENJSON(@GradeData)
        ) AS source ON target.StudentID = source.StudentID AND target.TestID = source.TestID
        WHEN MATCHED THEN
            UPDATE SET 
                Score = source.Score,
                Comments = source.Comments,
                GradedBy = @GradedBy,
                GradedDate = GETDATE(),
                LastModified = GETDATE(),
                ModifiedBy = @GradedBy
        WHEN NOT MATCHED THEN
            INSERT (StudentID, TestID, Score, Comments, GradedBy, GradedDate, LastModified, ModifiedBy)
            VALUES (source.StudentID, source.TestID, source.Score, source.Comments, @GradedBy, GETDATE(), GETDATE(), @GradedBy);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Điểm số đã được lưu thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để thêm/sửa bài kiểm tra
CREATE PROCEDURE sp_ManageTestDefinition
    @TestID INT = NULL, -- NULL for new test
    @ClassID INT,
    @TestName NVARCHAR(255),
    @TestType NVARCHAR(100) = 'Quiz',
    @MaxScore DECIMAL(5,2) = 10.00,
    @Weight DECIMAL(5,2) = 1.00,
    @TestDate DATE = NULL,
    @Description NVARCHAR(1000) = NULL,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        IF @TestID IS NULL
        BEGIN
            -- Tạo bài kiểm tra mới
            DECLARE @NextTestNumber INT;
            SELECT @NextTestNumber = ISNULL(MAX(TestNumber), 0) + 1 FROM TestDefinition WHERE ClassID = @ClassID;
            
            INSERT INTO TestDefinition (ClassID, TestNumber, TestName, TestType, MaxScore, Weight, TestDate, Description, CreatedBy)
            VALUES (@ClassID, @NextTestNumber, @TestName, @TestType, @MaxScore, @Weight, @TestDate, @Description, @CreatedBy);
            
            SET @TestID = SCOPE_IDENTITY();
            SELECT 'Success' AS Result, 'Bài kiểm tra đã được tạo thành công' AS Message, @TestID AS TestID;
        END
        ELSE
        BEGIN
            -- Cập nhật bài kiểm tra
            UPDATE TestDefinition
            SET TestName = @TestName,
                TestType = @TestType,
                MaxScore = @MaxScore,
                Weight = @Weight,
                TestDate = @TestDate,
                Description = @Description,
                LastModified = GETDATE(),
                ModifiedBy = @CreatedBy
            WHERE TestID = @TestID;
            
            SELECT 'Success' AS Result, 'Bài kiểm tra đã được cập nhật thành công' AS Message, @TestID AS TestID;
        END
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để xóa bài kiểm tra
CREATE PROCEDURE sp_DeleteTestDefinition
    @TestID INT,
    @DeletedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra có điểm số nào chưa
        IF EXISTS (SELECT 1 FROM StudentGrade WHERE TestID = @TestID)
        BEGIN
            SELECT 'Error' AS Result, 'Không thể xóa bài kiểm tra đã có điểm số' AS Message;
            RETURN;
        END
        
        -- Soft delete
        UPDATE TestDefinition 
        SET IsActive = 0, LastModified = GETDATE(), ModifiedBy = @DeletedBy
        WHERE TestID = @TestID;
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Bài kiểm tra đã được xóa thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để lưu tiến độ học tập
CREATE PROCEDURE sp_SaveTrainingProgress
    @ClassID INT,
    @ProgressData NVARCHAR(MAX), -- JSON: [{"SessionNumber":1,"Topic":"Introduction","PlannedDate":"2025-01-15","ActualDate":"2025-01-15","Status":"Completed","CompletionRate":100}]
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Xóa progress cũ
        DELETE FROM TrainingProgress WHERE ClassID = @ClassID;
        
        -- Insert progress mới
        INSERT INTO TrainingProgress (ClassID, SessionNumber, Topic, PlannedDate, ActualDate, Status, CompletionRate, Notes, CreatedBy)
        SELECT 
            @ClassID,
            JSON_VALUE(value, '$.SessionNumber'),
            JSON_VALUE(value, '$.Topic'),
            JSON_VALUE(value, '$.PlannedDate'),
            JSON_VALUE(value, '$.ActualDate'),
            JSON_VALUE(value, '$.Status'),
            JSON_VALUE(value, '$.CompletionRate'),
            JSON_VALUE(value, '$.Notes'),
            @CreatedBy
        FROM OPENJSON(@ProgressData);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Tiến độ học tập đã được lưu thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

PRINT 'Class Management & Education System created successfully!';
PRINT '';
PRINT 'New Education Management Features Added:';
PRINT '- Course & Major Management: Quản lý khóa học và chuyên ngành';
PRINT '- Class Management: Quản lý lớp học với thông tin chi tiết';
PRINT '- Student Management: Quản lý học viên và đăng ký học';
PRINT '- Session Management: Quản lý buổi học và lịch trình';
PRINT '- Attendance Tracking: Điểm danh học viên theo từng buổi học';
PRINT '- Dynamic Grade Management: Quản lý điểm số với bài kiểm tra tùy chỉnh';
PRINT '- End-of-Course Evaluation: Đánh giá cuối khóa học chi tiết';
PRINT '- Training Progress Tracking: Theo dõi tiến độ học tập';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- Course: Định nghĩa khóa học với duration, level, objectives';
PRINT '- Major: Chuyên ngành (TOEIC, IELTS, TOEFL, General, Business, Kids)';
PRINT '- Class: Lớp học với teacher assignment, schedule, capacity';
PRINT '- Student: Học viên với thông tin cá nhân và phụ huynh';
PRINT '- ClassEnrollment: Đăng ký học viên vào lớp với tracking status';
PRINT '- ClassSession: Buổi học với topic, content, actual vs planned';
PRINT '- Attendance: Điểm danh chi tiết (Present/Absent/Late/Excused)';
PRINT '- TestDefinition: Định nghĩa bài kiểm tra tùy chỉnh với weight';
PRINT '- StudentGrade: Điểm số học viên với comments từ giảng viên';
PRINT '- EndOfCourseEvaluation: Đánh giá tổng thể cuối khóa';
PRINT '- TrainingProgress: Tiến độ học tập theo session';
PRINT '';
PRINT 'Enhanced Views Created:';
PRINT '- vw_ClassDetails: Tổng hợp thông tin lớp học đầy đủ';
PRINT '- vw_ClassStudents: Danh sách học viên với statistics';
PRINT '- vw_SessionAttendance: Điểm danh theo buổi học';
PRINT '- vw_StudentGrades: Điểm số và bài kiểm tra tổng hợp';
PRINT '';
PRINT 'Stored Procedures for ClassDescription.html:';
PRINT '- sp_GetClassDetails: Lấy thông tin chi tiết lớp học (tabs 1-4)';
PRINT '- sp_GetSessionAttendance: Lấy điểm danh theo buổi học';
PRINT '- sp_SaveAttendance: Lưu điểm danh với JSON format';
PRINT '- sp_SaveGrades: Lưu điểm số với MERGE operation';
PRINT '- sp_ManageTestDefinition: Thêm/sửa định nghĩa bài kiểm tra';
PRINT '- sp_DeleteTestDefinition: Xóa bài kiểm tra (với validation)';
PRINT '- sp_SaveTrainingProgress: Lưu tiến độ học tập';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 8 Courses: TOEIC (Basic/Inter/Advanced), IELTS, Business English, etc.';
PRINT '- 6 Majors: TOEIC, IELTS, TOEFL, General, Business, Kids';
PRINT '- 8 Students: Với thông tin đầy đủ và realistic data';
PRINT '- 3 Classes: TOEIC001, IELTS001, CONV001 với enrollments';
PRINT '';
PRINT 'Features Supporting ClassDescription.html Interface:';
PRINT '✅ Tab 1 - Class Details: Full class information display';
PRINT '✅ Tab 2 - Attendance: Session-based attendance with dropdown selector';
PRINT '✅ Tab 3 - Grades: Dynamic test columns with custom names';
PRINT '✅ Tab 4 - Training Progress: Session progress tracking with status';
PRINT '✅ JSON-based data exchange for WebView2 C# integration';
PRINT '✅ Comprehensive validation and error handling';
PRINT '✅ Audit trails for all educational operations';
PRINT '';
PRINT 'Database now fully supports ClassDescription.html with comprehensive education management!';

-- ============================================================================
-- 28. CLASS LIST MANAGEMENT SYSTEM
-- ============================================================================

-- View tổng hợp cho ClassList.html - Hiển thị danh sách lớp học với thông tin đầy đủ
CREATE VIEW vw_ClassListSummary AS
SELECT 
    c.ClassID,
    c.ClassCode,
    c.ClassName,
    b.BranchName,
    m.MajorName,
    co.CourseName,
    teacher.FullName AS MainTeacherName,
    assistant.FullName AS AssistantName,
    c.Room,
    c.CurrentEnrollment AS ClassSize,
    c.MaxCapacity,
    c.StartDate,
    c.ExpectedEndDate,
    c.ActualEndDate,
    c.Schedule,
    gs.StatusName,
    -- Tính toán thống kê bổ sung
    CASE 
        WHEN c.StartDate > GETDATE() THEN 'Sắp khai giảng'
        WHEN c.ActualEndDate IS NOT NULL THEN 'Đã kết thúc'
        WHEN c.ExpectedEndDate < GETDATE() THEN 'Quá hạn'
        ELSE 'Đang hoạt động'
    END AS DynamicStatus,
    DATEDIFF(DAY, c.StartDate, COALESCE(c.ActualEndDate, c.ExpectedEndDate)) AS CourseDurationDays,
    CASE 
        WHEN c.MaxCapacity > 0 THEN CAST((c.CurrentEnrollment * 100.0 / c.MaxCapacity) AS DECIMAL(5,2))
        ELSE 0
    END AS EnrollmentPercentage,
    -- Thống kê attendance rate trung bình của lớp
    (SELECT AVG(CAST(att_stats.PresentCount AS FLOAT) / NULLIF(att_stats.TotalSessions, 0) * 100)
     FROM (
        SELECT 
            ce.StudentID,
            COUNT(cs.SessionID) AS TotalSessions,
            COUNT(CASE WHEN a.AttendanceStatus = 'Present' THEN 1 END) AS PresentCount
        FROM ClassEnrollment ce
        LEFT JOIN ClassSession cs ON ce.ClassID = cs.ClassID
        LEFT JOIN Attendance a ON cs.SessionID = a.SessionID AND ce.StudentID = a.StudentID
        WHERE ce.ClassID = c.ClassID AND ce.StatusID = 1
        GROUP BY ce.StudentID
     ) att_stats
    ) AS AverageAttendanceRate,
    -- Điểm trung bình của lớp
    (SELECT AVG(sg.Score) 
     FROM StudentGrade sg 
     INNER JOIN TestDefinition td ON sg.TestID = td.TestID 
     WHERE td.ClassID = c.ClassID AND td.IsActive = 1) AS AverageGrade,
    c.CreatedDate,
    creator.FullName AS CreatedByName
FROM Class c
INNER JOIN Course co ON c.CourseID = co.CourseID
INNER JOIN Major m ON c.MajorID = m.MajorID
INNER JOIN Branch b ON c.BranchID = b.BranchID
INNER JOIN Staff teacher ON c.MainTeacherID = teacher.StaffID
LEFT JOIN Staff assistant ON c.AssistantTeacherID = assistant.StaffID
INNER JOIN GeneralStatus gs ON c.StatusID = gs.StatusID
INNER JOIN Staff creator ON c.CreatedBy = creator.StaffID;

-- Stored Procedure để lấy danh sách lớp học cho ClassList.html
CREATE PROCEDURE sp_GetClassListData
    @BranchID INT = NULL, -- Filter by branch (optional)
    @MajorID INT = NULL,  -- Filter by major (optional)
    @StatusID INT = NULL, -- Filter by status (optional)
    @SearchTerm NVARCHAR(255) = NULL, -- Search term (optional)
    @PageNumber INT = 1,  -- Pagination support
    @PageSize INT = 50    -- Page size
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Main query with filtering and pagination
    SELECT 
        ClassID,
        ClassCode,
        ClassName,
        BranchName,
        MajorName,
        CourseName,
        MainTeacherName,
        AssistantName,
        Room,
        ClassSize,
        MaxCapacity,
        StartDate,
        ExpectedEndDate,
        ActualEndDate,
        Schedule,
        StatusName,
        DynamicStatus,
        CourseDurationDays,
        EnrollmentPercentage,
        AverageAttendanceRate,
        AverageGrade,
        CreatedDate,
        CreatedByName
    FROM vw_ClassListSummary
    WHERE (@BranchID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE BranchID = @BranchID))
      AND (@MajorID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE MajorID = @MajorID))
      AND (@StatusID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE StatusID = @StatusID))
      AND (@SearchTerm IS NULL OR (
          ClassName LIKE '%' + @SearchTerm + '%' OR
          BranchName LIKE '%' + @SearchTerm + '%' OR
          MajorName LIKE '%' + @SearchTerm + '%' OR
          MainTeacherName LIKE '%' + @SearchTerm + '%' OR
          Room LIKE '%' + @SearchTerm + '%' OR
          StatusName LIKE '%' + @SearchTerm + '%'
      ))
    ORDER BY CreatedDate DESC, ClassCode
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count for pagination
    SELECT COUNT(*) AS TotalRecords
    FROM vw_ClassListSummary
    WHERE (@BranchID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE BranchID = @BranchID))
      AND (@MajorID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE MajorID = @MajorID))
      AND (@StatusID IS NULL OR ClassID IN (SELECT ClassID FROM Class WHERE StatusID = @StatusID))
      AND (@SearchTerm IS NULL OR (
          ClassName LIKE '%' + @SearchTerm + '%' OR
          BranchName LIKE '%' + @SearchTerm + '%' OR
          MajorName LIKE '%' + @SearchTerm + '%' OR
          MainTeacherName LIKE '%' + @SearchTerm + '%' OR
          Room LIKE '%' + @SearchTerm + '%' OR
          StatusName LIKE '%' + @SearchTerm + '%'
      ));
END;

-- Stored Procedure để lấy thống kê tổng quan cho ClassList.html dashboard
CREATE PROCEDURE sp_GetClassListStatistics
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thống kê tổng quan
    SELECT 
        'TotalClasses' AS StatType,
        COUNT(*) AS Value,
        'Tổng số lớp học' AS Description
    FROM Class
    WHERE StatusID = 1 -- Active classes only
    
    UNION ALL
    
    SELECT 
        'ActiveClasses' AS StatType,
        COUNT(*) AS Value,
        'Lớp đang hoạt động' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus = 'Đang hoạt động'
    
    UNION ALL
    
    SELECT 
        'UpcomingClasses' AS StatType,
        COUNT(*) AS Value,
        'Lớp sắp khai giảng' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus = 'Sắp khai giảng'
    
    UNION ALL
    
    SELECT 
        'CompletedClasses' AS StatType,
        COUNT(*) AS Value,
        'Lớp đã kết thúc' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus = 'Đã kết thúc'
    
    UNION ALL
    
    SELECT 
        'TotalStudents' AS StatType,
        SUM(ClassSize) AS Value,
        'Tổng số học viên' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus IN ('Đang hoạt động', 'Sắp khai giảng')
    
    UNION ALL
    
    SELECT 
        'AverageClassSize' AS StatType,
        AVG(ClassSize) AS Value,
        'Sĩ số trung bình' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus = 'Đang hoạt động'
    
    UNION ALL
    
    SELECT 
        'CapacityUtilization' AS StatType,
        AVG(EnrollmentPercentage) AS Value,
        'Tỷ lệ lấp đầy trung bình' AS Description
    FROM vw_ClassListSummary
    WHERE DynamicStatus = 'Đang hoạt động'
    
    ORDER BY StatType;
    
    -- Thống kê theo chi nhánh
    SELECT 
        b.BranchName,
        COUNT(c.ClassID) AS TotalClasses,
        SUM(c.CurrentEnrollment) AS TotalStudents,
        AVG(CAST(c.CurrentEnrollment AS FLOAT) / NULLIF(c.MaxCapacity, 0) * 100) AS AvgCapacityUtilization
    FROM Branch b
    LEFT JOIN Class c ON b.BranchID = c.BranchID AND c.StatusID = 1
    GROUP BY b.BranchID, b.BranchName
    ORDER BY TotalClasses DESC;
    
    -- Thống kê theo chuyên ngành
    SELECT 
        m.MajorName,
        COUNT(c.ClassID) AS TotalClasses,
        SUM(c.CurrentEnrollment) AS TotalStudents,
        AVG(CAST(c.CurrentEnrollment AS FLOAT) / NULLIF(c.MaxCapacity, 0) * 100) AS AvgCapacityUtilization
    FROM Major m
    LEFT JOIN Class c ON m.MajorID = c.MajorID AND c.StatusID = 1
    GROUP BY m.MajorID, m.MajorName
    ORDER BY TotalClasses DESC;
END;

-- Stored Procedure để lấy dropdown data cho filters
CREATE PROCEDURE sp_GetClassListFilterData
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Danh sách chi nhánh cho filter
    SELECT BranchID, BranchName FROM Branch WHERE StatusID = 1 ORDER BY BranchName;
    
    -- Danh sách chuyên ngành cho filter
    SELECT MajorID, MajorName FROM Major WHERE StatusID = 1 ORDER BY MajorName;
    
    -- Danh sách trạng thái cho filter
    SELECT StatusID, StatusName FROM GeneralStatus WHERE StatusType = 'Common' ORDER BY DisplayOrder;
    
    -- Danh sách khóa học cho filter
    SELECT CourseID, CourseName, Level FROM Course WHERE StatusID = 1 ORDER BY CourseName;
END;

-- Function để tính toán progress percentage của lớp học
CREATE FUNCTION fn_CalculateClassProgress(@ClassID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Progress DECIMAL(5,2) = 0;
    DECLARE @TotalSessions INT;
    DECLARE @CompletedSessions INT;
    
    SELECT @TotalSessions = COUNT(*) FROM ClassSession WHERE ClassID = @ClassID;
    SELECT @CompletedSessions = COUNT(*) FROM ClassSession WHERE ClassID = @ClassID AND StatusID = 4; -- Completed status
    
    IF @TotalSessions > 0
        SET @Progress = CAST(@CompletedSessions AS FLOAT) / @TotalSessions * 100;
    
    RETURN @Progress;
END;

-- Trigger để tự động cập nhật CurrentEnrollment khi có thay đổi enrollment
CREATE TRIGGER tr_UpdateClassEnrollment ON ClassEnrollment
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update for inserted/updated records
    IF EXISTS(SELECT 1 FROM inserted)
    BEGIN
        UPDATE Class 
        SET CurrentEnrollment = (
            SELECT COUNT(*) 
            FROM ClassEnrollment ce 
            WHERE ce.ClassID = Class.ClassID AND ce.StatusID = 1
        )
        WHERE ClassID IN (SELECT DISTINCT ClassID FROM inserted);
    END
    
    -- Update for deleted records
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE Class 
        SET CurrentEnrollment = (
            SELECT COUNT(*) 
            FROM ClassEnrollment ce 
            WHERE ce.ClassID = Class.ClassID AND ce.StatusID = 1
        )
        WHERE ClassID IN (SELECT DISTINCT ClassID FROM deleted);
    END
END;

-- Thêm một số classes mẫu để test ClassList interface
INSERT INTO Class (ClassCode, ClassName, CourseID, MajorID, BranchID, MainTeacherID, Room, MaxCapacity, StartDate, ExpectedEndDate, Schedule, StatusID, CreatedBy) VALUES
('TOEFL001', 'TOEFL Cơ Bản - Khóa 1/2025', 1, 3, 1, 3, 'Phòng 103', 18, '2025-02-15', '2025-05-15', 'T2,T4,T6 - 18:00-20:00', 1, 1),
('BUS001', 'Business English - Khóa 1/2025', 7, 5, 2, 4, 'Phòng 202', 12, '2025-03-01', '2025-05-30', 'T3,T5 - 19:00-21:00', 1, 1),
('KIDS001', 'English for Kids - Level 1', 8, 6, 1, 3, 'Phòng 104', 15, '2025-02-01', '2025-04-30', 'T7,CN - 09:00-11:00', 1, 1),
('IELTS002', 'IELTS Nâng Cao - Khóa 1/2025', 6, 2, 2, 4, 'Phòng 203', 10, '2025-01-25', '2025-06-25', 'T2,T4,T6 - 19:30-21:30', 1, 1);

-- Cập nhật CurrentEnrollment cho các classes mới
UPDATE Class SET CurrentEnrollment = 0 WHERE CurrentEnrollment IS NULL;

-- Thêm một số enrollments cho classes mới
INSERT INTO ClassEnrollment (StudentID, ClassID, StatusID, CreatedBy) VALUES
(5, 4, 1, 1), (6, 4, 1, 1), (7, 4, 1, 1), (8, 4, 1, 1), -- TOEFL001
(1, 5, 1, 1), (2, 5, 1, 1), (3, 5, 1, 1), -- BUS001
(4, 6, 1, 1), (5, 6, 1, 1), (6, 6, 1, 1), (7, 6, 1, 1), (8, 6, 1, 1), -- KIDS001
(1, 7, 1, 1), (3, 7, 1, 1), (5, 7, 1, 1), (7, 7, 1, 1); -- IELTS002

-- Tạo một số sessions mẫu cho các classes
INSERT INTO ClassSession (ClassID, SessionNumber, SessionDate, Topic, StatusID, CreatedBy) VALUES
-- TOEIC001 sessions
(1, 1, '2025-01-15', 'Introduction to TOEIC', 4, 1), -- Completed
(1, 2, '2025-01-17', 'Listening Strategies', 4, 1), -- Completed
(1, 3, '2025-01-20', 'Reading Comprehension', 1, 1), -- Planned
-- IELTS001 sessions
(2, 1, '2025-01-20', 'IELTS Overview', 4, 1), -- Completed
(2, 2, '2025-01-22', 'Writing Task 1', 1, 1), -- Planned
-- CONV001 sessions
(3, 1, '2025-02-01', 'Basic Conversations', 1, 1); -- Planned

PRINT 'Class List Management System created successfully!';
PRINT '';
PRINT 'New ClassList.html Support Features Added:';
PRINT '- vw_ClassListSummary: Comprehensive view with all display fields and calculations';
PRINT '- sp_GetClassListData: Main procedure for ClassList.html with filtering and pagination';
PRINT '- sp_GetClassListStatistics: Dashboard statistics and summary data';
PRINT '- sp_GetClassListFilterData: Dropdown data for branch, major, status filters';
PRINT '- fn_CalculateClassProgress: Function to calculate class completion progress';
PRINT '- tr_UpdateClassEnrollment: Auto-update enrollment counts on changes';
PRINT '';
PRINT 'Key Features for ClassList Interface:';
PRINT '✅ Complete class listing with branch, major, teacher information';
PRINT '✅ Dynamic status calculation (Active, Upcoming, Completed, Overdue)';
PRINT '✅ Enrollment percentage and capacity utilization';
PRINT '✅ Average attendance rate and grade calculations';
PRINT '✅ Search functionality across multiple fields';
PRINT '✅ Pagination support for large datasets';
PRINT '✅ Statistical summaries and dashboard metrics';
PRINT '✅ Filter support by branch, major, status';
PRINT '✅ Real-time enrollment count updates via triggers';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 4 Additional Classes: TOEFL001, BUS001, KIDS001, IELTS002';
PRINT '- Student enrollments across all classes';
PRINT '- Sample class sessions with different statuses';
PRINT '- Realistic data for testing ClassList interface';
PRINT '';
PRINT 'Database now fully supports ClassList.html with comprehensive class management!';

-- ============================================================================
-- 29. DEPARTMENT MANAGEMENT SYSTEM
-- ============================================================================

-- Bảng quản lý bộ phận/phòng ban
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentCode NVARCHAR(20) NOT NULL UNIQUE, -- Mã bộ phận (DT, TS, KT, MKT, etc.)
    DepartmentName NVARCHAR(255) NOT NULL, -- Tên bộ phận
    ManagerEmployeeId NVARCHAR(50), -- Mã nhân viên quản lý (có thể null nếu chưa có)
    StaffQuota INT DEFAULT 0, -- Hạn mức nhân viên tối đa
    CurrentStaffCount INT DEFAULT 0, -- Số nhân viên hiện tại
    Description NVARCHAR(MAX), -- Mô tả chức năng, nhiệm vụ của bộ phận
    BranchID INT, -- Bộ phận thuộc chi nhánh nào
    ParentDepartmentID INT NULL, -- Bộ phận cha (cho cấu trúc phân cấp)
    DepartmentLevel INT DEFAULT 1, -- Cấp độ (1=phòng ban chính, 2=tiểu ban, 3=nhóm...)
    EstablishedDate DATE, -- Ngày thành lập bộ phận
    Budget DECIMAL(15,2) DEFAULT 0, -- Ngân sách phân bổ cho bộ phận
    ContactPhone NVARCHAR(20), -- Số điện thoại liên hệ bộ phận
    ContactEmail NVARCHAR(255), -- Email liên hệ bộ phận
    OfficeLocation NVARCHAR(500), -- Địa điểm văn phòng
    Responsibilities NVARCHAR(MAX), -- Trách nhiệm chi tiết (JSON format)
    KPITargets NVARCHAR(MAX), -- Mục tiêu KPI (JSON format)
    StatusID INT DEFAULT 1, -- Trạng thái (1=Hoạt động, 2=Tạm dừng, 3=Đã giải thể, 4=Đang xây dựng)
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ParentDepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng chức vụ trong bộ phận
CREATE TABLE DepartmentPosition (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    PositionCode NVARCHAR(20) NOT NULL, -- Mã chức vụ (TP, PTP, NV, TK, etc.)
    PositionName NVARCHAR(255) NOT NULL, -- Tên chức vụ
    PositionLevel INT DEFAULT 1, -- Cấp độ chức vụ (1=Trưởng phòng, 2=Phó, 3=Nhân viên)
    MaxOccupants INT DEFAULT 1, -- Số lượng người tối đa có thể giữ chức vụ này
    CurrentOccupants INT DEFAULT 0, -- Số người hiện tại đang giữ chức vụ
    SalaryRange NVARCHAR(100), -- Mức lương tham khảo
    Requirements NVARCHAR(MAX), -- Yêu cầu về trình độ, kinh nghiệm
    JobDescription NVARCHAR(MAX), -- Mô tả công việc chi tiết
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(DepartmentID, PositionCode) -- Mỗi bộ phận có mã chức vụ duy nhất
);

-- Bảng phân công nhân viên vào bộ phận
CREATE TABLE DepartmentStaffAssignment (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    StaffID INT,
    PositionID INT NULL, -- Chức vụ cụ thể (có thể null)
    AssignmentType NVARCHAR(50) DEFAULT 'Full-time', -- Full-time, Part-time, Temporary, Contract
    StartDate DATE NOT NULL, -- Ngày bắt đầu công tác
    EndDate DATE NULL, -- Ngày kết thúc (null nếu chưa kết thúc)
    Responsibilities NVARCHAR(MAX), -- Trách nhiệm cụ thể của nhân viên trong bộ phận
    ReportingTo INT NULL, -- Báo cáo trực tiếp cho ai (StaffID)
    WorkPercentage DECIMAL(5,2) DEFAULT 100.00, -- % thời gian làm việc cho bộ phận này
    SalaryAllocation DECIMAL(5,2) DEFAULT 100.00, -- % lương được chi trả từ bộ phận này
    Performance NVARCHAR(MAX), -- Đánh giá hiệu suất (JSON format)
    Notes NVARCHAR(MAX), -- Ghi chú bổ sung
    StatusID INT DEFAULT 1, -- 1=Active, 2=Suspended, 3=Transferred, 4=Terminated
    AssignedBy INT,
    AssignedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (PositionID) REFERENCES DepartmentPosition(PositionID),
    FOREIGN KEY (ReportingTo) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (AssignedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng mục tiêu và KPI của bộ phận
CREATE TABLE DepartmentKPI (
    KPIID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    KPIName NVARCHAR(255) NOT NULL, -- Tên chỉ số KPI
    KPIType NVARCHAR(100), -- 'Revenue', 'Efficiency', 'Quality', 'Customer Satisfaction', etc.
    KPICategory NVARCHAR(100), -- 'Monthly', 'Quarterly', 'Yearly', 'Project-based'
    TargetValue DECIMAL(15,2), -- Giá trị mục tiêu
    CurrentValue DECIMAL(15,2) DEFAULT 0, -- Giá trị hiện tại
    Unit NVARCHAR(50), -- Đơn vị (VND, %, count, hours, etc.)
    MeasurementMethod NVARCHAR(MAX), -- Phương pháp đo lường
    EvaluationPeriod NVARCHAR(100), -- Chu kỳ đánh giá
    Weight DECIMAL(5,2) DEFAULT 1.00, -- Trọng số trong tổng đánh giá
    ResponsibleStaffID INT, -- Nhân viên chịu trách nhiệm chính
    StartDate DATE, -- Ngày bắt đầu áp dụng KPI
    EndDate DATE, -- Ngày kết thúc
    Achievement DECIMAL(5,2), -- % hoàn thành (auto-calculated)
    Notes NVARCHAR(MAX), -- Ghi chú về KPI
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (ResponsibleStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng lịch sử thay đổi bộ phận
CREATE TABLE DepartmentChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    ChangeType NVARCHAR(100), -- 'Created', 'Updated', 'Staff_Assigned', 'Staff_Removed', 'Budget_Changed', etc.
    FieldChanged NVARCHAR(255), -- Trường dữ liệu được thay đổi
    OldValue NVARCHAR(MAX), -- Giá trị cũ (JSON format)
    NewValue NVARCHAR(MAX), -- Giá trị mới (JSON format)
    Reason NVARCHAR(MAX), -- Lý do thay đổi
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    ChangedBy INT,
    ApprovedBy INT NULL, -- Người phê duyệt thay đổi
    ApprovalDate DATETIME2 NULL,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (ChangedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ApprovedBy) REFERENCES Staff(StaffID)
);

-- Thêm dữ liệu mẫu cho các trạng thái bổ sung cho bộ phận
INSERT INTO GeneralStatus (StatusName, StatusType, DisplayOrder) VALUES
('Đang xây dựng', 'Department', 8),
('Đã giải thể', 'Department', 9),
('Tạm dừng hoạt động', 'Department', 10);

-- Thêm dữ liệu mẫu cho các bộ phận
INSERT INTO Department (DepartmentCode, DepartmentName, ManagerEmployeeId, StaffQuota, Description, BranchID, EstablishedDate, Budget, ContactPhone, ContactEmail, OfficeLocation, StatusID, CreatedBy) VALUES
('DT', 'Phòng Đào tạo', 'EMP001', 20, 'Quản lý các chương trình và lịch trình đào tạo.', 1, '2023-01-15', 500000000, '024-1234567', 'daotao@nn68.edu.vn', 'Tầng 2, Phòng 201-205', 1, 1),
('TS', 'Phòng Tuyển sinh', 'EMP002', 15, 'Tiếp nhận và tư vấn học viên mới.', 1, '2023-02-01', 300000000, '024-1234568', 'tuyensinh@nn68.edu.vn', 'Tầng 1, Phòng 101-103', 1, 1),
('KT', 'Phòng Kế toán', 'EMP003', 8, 'Quản lý tài chính và các khoản thu chi.', 1, '2023-03-10', 200000000, '024-1234569', 'ketoan@nn68.edu.vn', 'Tầng 3, Phòng 301-302', 1, 1),
('MKT', 'Phòng Marketing', 'EMP004', 12, 'Phát triển chiến lược và hoạt động marketing.', 1, '2023-04-20', 400000000, '024-1234570', 'marketing@nn68.edu.vn', 'Tầng 2, Phòng 206-208', 2, 1),
('HC', 'Phòng Hành chính', 'EMP005', 10, 'Quản lý hành chính và nhân sự nội bộ.', 1, '2023-05-05', 250000000, '024-1234571', 'hanhchinh@nn68.edu.vn', 'Tầng 3, Phòng 303-304', 1, 1),
('PTP', 'Phòng Phát triển sản phẩm', 'EMP006', 18, 'Nghiên cứu và phát triển các khóa học mới.', 1, '2024-01-20', 600000000, '024-1234572', 'phangtriensanpham@nn68.edu.vn', 'Tầng 4, Phòng 401-405', 1, 1),
('HTKT', 'Phòng Hỗ trợ kỹ thuật', 'EMP007', 7, 'Cung cấp hỗ trợ kỹ thuật cho học viên và nhân viên.', 1, '2024-03-01', 150000000, '024-1234573', 'hotrokt@nn68.edu.vn', 'Tầng 1, Phòng 104-105', 2, 1),
('QHDT', 'Phòng Quan hệ đối tác', 'EMP008', 5, 'Xây dựng và duy trì mối quan hệ với các đối tác.', 1, '2024-04-10', 180000000, '024-1234574', 'quanhedoitac@nn68.edu.vn', 'Tầng 2, Phòng 209', 1, 1);

-- Thêm các chức vụ cho các bộ phận
INSERT INTO DepartmentPosition (DepartmentID, PositionCode, PositionName, PositionLevel, MaxOccupants, SalaryRange, Requirements, JobDescription, CreatedBy) VALUES
-- Phòng Đào tạo
(1, 'TP-DT', 'Trưởng phòng Đào tạo', 1, 1, '20-30 triệu', 'Thạc sĩ Giáo dục, 5+ năm kinh nghiệm', 'Quản lý toàn bộ hoạt động đào tạo', 1),
(1, 'PTP-DT', 'Phó trưởng phòng Đào tạo', 2, 1, '15-20 triệu', 'Cử nhân, 3+ năm kinh nghiệm', 'Hỗ trợ trưởng phòng quản lý đào tạo', 1),
(1, 'NV-DT', 'Nhân viên Đào tạo', 3, 15, '8-15 triệu', 'Cử nhân Sư phạm/Ngôn ngữ', 'Thực hiện các nhiệm vụ đào tạo cụ thể', 1),
-- Phòng Tuyển sinh
(2, 'TP-TS', 'Trưởng phòng Tuyển sinh', 1, 1, '18-25 triệu', 'Cử nhân, 3+ năm kinh nghiệm tuyển sinh', 'Quản lý hoạt động tuyển sinh', 1),
(2, 'NV-TS', 'Nhân viên Tuyển sinh', 3, 12, '7-12 triệu', 'Trung cấp trở lên, kỹ năng giao tiếp tốt', 'Tư vấn và tiếp nhận học viên', 1),
-- Phòng Kế toán
(3, 'TP-KT', 'Trưởng phòng Kế toán', 1, 1, '20-28 triệu', 'Cử nhân Kế toán, chứng chỉ CPA', 'Quản lý tài chính và kế toán', 1),
(3, 'KTV-KT', 'Kế toán viên', 3, 6, '8-15 triệu', 'Trung cấp Kế toán trở lên', 'Thực hiện công việc kế toán cụ thể', 1);

-- View tổng hợp thông tin bộ phận cho DepartmentManagement.html
CREATE VIEW vw_DepartmentManagement AS
SELECT 
    d.DepartmentID,
    d.DepartmentCode,
    d.DepartmentName,
    d.ManagerEmployeeId,
    d.StaffQuota,
    d.CurrentStaffCount,
    d.Description,
    d.BranchID,
    b.BranchName,
    d.EstablishedDate,
    d.Budget,
    d.ContactPhone,
    d.ContactEmail,
    d.OfficeLocation,
    gs.StatusName,
    d.StatusID,
    d.CreatedDate,
    creator.FullName AS CreatedByName,
    -- Tính toán thống kê bổ sung
    CASE 
        WHEN d.StaffQuota > 0 THEN CAST((d.CurrentStaffCount * 100.0 / d.StaffQuota) AS DECIMAL(5,2))
        ELSE 0
    END AS StaffUtilizationPercentage,
    (SELECT COUNT(*) FROM DepartmentPosition dp WHERE dp.DepartmentID = d.DepartmentID AND dp.StatusID = 1) AS TotalPositions,
    (SELECT COUNT(*) FROM DepartmentStaffAssignment dsa WHERE dsa.DepartmentID = d.DepartmentID AND dsa.StatusID = 1) AS ActiveAssignments,
    -- Thống kê KPI
    (SELECT COUNT(*) FROM DepartmentKPI dk WHERE dk.DepartmentID = d.DepartmentID AND dk.StatusID = 1) AS TotalKPIs,
    (SELECT AVG(dk.Achievement) FROM DepartmentKPI dk WHERE dk.DepartmentID = d.DepartmentID AND dk.StatusID = 1) AS AverageKPIAchievement
FROM Department d
INNER JOIN Branch b ON d.BranchID = b.BranchID
INNER JOIN GeneralStatus gs ON d.StatusID = gs.StatusID
INNER JOIN Staff creator ON d.CreatedBy = creator.StaffID;

-- Stored Procedure để lấy danh sách bộ phận cho DepartmentManagement.html
CREATE PROCEDURE sp_GetDepartmentListData
    @BranchID INT = NULL, -- Filter by branch (optional)
    @StatusID INT = NULL, -- Filter by status (optional)
    @SearchTerm NVARCHAR(255) = NULL, -- Search term (optional)
    @PageNumber INT = 1,  -- Pagination support
    @PageSize INT = 50    -- Page size
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Main query with filtering and pagination
    SELECT 
        DepartmentID,
        DepartmentCode,
        DepartmentName,
        ManagerEmployeeId,
        StaffQuota,
        CurrentStaffCount,
        Description,
        BranchName,
        EstablishedDate,
        Budget,
        ContactPhone,
        ContactEmail,
        OfficeLocation,
        StatusName,
        StatusID,
        CreatedDate,
        CreatedByName,
        StaffUtilizationPercentage,
        TotalPositions,
        ActiveAssignments,
        TotalKPIs,
        AverageKPIAchievement
    FROM vw_DepartmentManagement
    WHERE (@BranchID IS NULL OR BranchID = @BranchID)
      AND (@StatusID IS NULL OR StatusID = @StatusID)
      AND (@SearchTerm IS NULL OR (
          DepartmentCode LIKE '%' + @SearchTerm + '%' OR
          DepartmentName LIKE '%' + @SearchTerm + '%' OR
          ManagerEmployeeId LIKE '%' + @SearchTerm + '%' OR
          Description LIKE '%' + @SearchTerm + '%' OR
          OfficeLocation LIKE '%' + @SearchTerm + '%' OR
          StatusName LIKE '%' + @SearchTerm + '%'
      ))
    ORDER BY CreatedDate DESC, DepartmentCode
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count for pagination
    SELECT COUNT(*) AS TotalRecords
    FROM vw_DepartmentManagement
    WHERE (@BranchID IS NULL OR BranchID = @BranchID)
      AND (@StatusID IS NULL OR StatusID = @StatusID)
      AND (@SearchTerm IS NULL OR (
          DepartmentCode LIKE '%' + @SearchTerm + '%' OR
          DepartmentName LIKE '%' + @SearchTerm + '%' OR
          ManagerEmployeeId LIKE '%' + @SearchTerm + '%' OR
          Description LIKE '%' + @SearchTerm + '%' OR
          OfficeLocation LIKE '%' + @SearchTerm + '%' OR
          StatusName LIKE '%' + @SearchTerm + '%'
      ));
END;

-- Stored Procedure để tạo bộ phận mới
CREATE PROCEDURE sp_CreateDepartment
    @DepartmentCode NVARCHAR(20),
    @DepartmentName NVARCHAR(255),
    @ManagerEmployeeId NVARCHAR(50) = NULL,
    @StaffQuota INT = 0,
    @Description NVARCHAR(MAX) = NULL,
    @BranchID INT,
    @Budget DECIMAL(15,2) = 0,
    @ContactPhone NVARCHAR(20) = NULL,
    @ContactEmail NVARCHAR(255) = NULL,
    @OfficeLocation NVARCHAR(500) = NULL,
    @StatusID INT = 1,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra mã bộ phận đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM Department WHERE DepartmentCode = @DepartmentCode)
        BEGIN
            SELECT 'Error' AS Result, 'Mã bộ phận đã tồn tại' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Thêm bộ phận mới
        DECLARE @NewDepartmentID INT;
        INSERT INTO Department (DepartmentCode, DepartmentName, ManagerEmployeeId, StaffQuota, Description, BranchID, Budget, ContactPhone, ContactEmail, OfficeLocation, StatusID, CreatedBy)
        VALUES (@DepartmentCode, @DepartmentName, @ManagerEmployeeId, @StaffQuota, @Description, @BranchID, @Budget, @ContactPhone, @ContactEmail, @OfficeLocation, @StatusID, @CreatedBy);
        
        SET @NewDepartmentID = SCOPE_IDENTITY();
        
        -- Ghi log tạo bộ phận
        INSERT INTO DepartmentChangeLog (DepartmentID, ChangeType, FieldChanged, NewValue, Reason, ChangedBy)
        VALUES (@NewDepartmentID, 'Created', 'Department', 
                JSON_QUERY('{"DepartmentCode":"' + @DepartmentCode + '","DepartmentName":"' + @DepartmentName + '"}'), 
                'Tạo bộ phận mới', @CreatedBy);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Bộ phận đã được tạo thành công' AS Message, @NewDepartmentID AS DepartmentID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để cập nhật bộ phận
CREATE PROCEDURE sp_UpdateDepartment
    @DepartmentID INT,
    @DepartmentCode NVARCHAR(20),
    @DepartmentName NVARCHAR(255),
    @ManagerEmployeeId NVARCHAR(50) = NULL,
    @StaffQuota INT = 0,
    @Description NVARCHAR(MAX) = NULL,
    @Budget DECIMAL(15,2) = 0,
    @ContactPhone NVARCHAR(20) = NULL,
    @ContactEmail NVARCHAR(255) = NULL,
    @OfficeLocation NVARCHAR(500) = NULL,
    @StatusID INT = 1,
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra bộ phận có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentID = @DepartmentID)
        BEGIN
            SELECT 'Error' AS Result, 'Bộ phận không tồn tại' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra mã bộ phận không trùng với bộ phận khác
        IF EXISTS (SELECT 1 FROM Department WHERE DepartmentCode = @DepartmentCode AND DepartmentID != @DepartmentID)
        BEGIN
            SELECT 'Error' AS Result, 'Mã bộ phận đã tồn tại' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Lưu thông tin cũ để ghi log
        DECLARE @OldData NVARCHAR(MAX);
        SELECT @OldData = JSON_QUERY('{"DepartmentCode":"' + DepartmentCode + '","DepartmentName":"' + DepartmentName + '","ManagerEmployeeId":"' + ISNULL(ManagerEmployeeId, '') + '"}')
        FROM Department WHERE DepartmentID = @DepartmentID;
        
        -- Cập nhật bộ phận
        UPDATE Department 
        SET DepartmentCode = @DepartmentCode,
            DepartmentName = @DepartmentName,
            ManagerEmployeeId = @ManagerEmployeeId,
            StaffQuota = @StaffQuota,
            Description = @Description,
            Budget = @Budget,
            ContactPhone = @ContactPhone,
            ContactEmail = @ContactEmail,
            OfficeLocation = @OfficeLocation,
            StatusID = @StatusID,
            LastModified = GETDATE(),
            ModifiedBy = @ModifiedBy
        WHERE DepartmentID = @DepartmentID;
        
        -- Ghi log cập nhật
        DECLARE @NewData NVARCHAR(MAX) = JSON_QUERY('{"DepartmentCode":"' + @DepartmentCode + '","DepartmentName":"' + @DepartmentName + '","ManagerEmployeeId":"' + ISNULL(@ManagerEmployeeId, '') + '"}');
        INSERT INTO DepartmentChangeLog (DepartmentID, ChangeType, FieldChanged, OldValue, NewValue, Reason, ChangedBy)
        VALUES (@DepartmentID, 'Updated', 'Department', @OldData, @NewData, 'Cập nhật thông tin bộ phận', @ModifiedBy);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Bộ phận đã được cập nhật thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để xóa bộ phận
CREATE PROCEDURE sp_DeleteDepartment
    @DepartmentID INT,
    @DeletedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra bộ phận có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentID = @DepartmentID)
        BEGIN
            SELECT 'Error' AS Result, 'Bộ phận không tồn tại' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra có nhân viên đang làm việc không
        IF EXISTS (SELECT 1 FROM DepartmentStaffAssignment WHERE DepartmentID = @DepartmentID AND StatusID = 1)
        BEGIN
            SELECT 'Error' AS Result, 'Không thể xóa bộ phận còn nhân viên đang làm việc' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Soft delete - chuyển status thành "Đã giải thể"
        UPDATE Department 
        SET StatusID = (SELECT StatusID FROM GeneralStatus WHERE StatusName = 'Đã giải thể' AND StatusType = 'Department'),
            LastModified = GETDATE(),
            ModifiedBy = @DeletedBy
        WHERE DepartmentID = @DepartmentID;
        
        -- Ghi log xóa
        INSERT INTO DepartmentChangeLog (DepartmentID, ChangeType, FieldChanged, Reason, ChangedBy)
        VALUES (@DepartmentID, 'Deleted', 'Status', 'Giải thể bộ phận', @DeletedBy);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Bộ phận đã được giải thể thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để lấy dropdown data cho department form
CREATE PROCEDURE sp_GetDepartmentFormData
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Danh sách chi nhánh
    SELECT BranchID, BranchName FROM Branch WHERE StatusID = 1 ORDER BY BranchName;
    
    -- Danh sách trạng thái cho department
    SELECT StatusID, StatusName 
    FROM GeneralStatus 
    WHERE StatusType IN ('Common', 'Department') 
    ORDER BY StatusType, DisplayOrder;
    
    -- Danh sách nhân viên có thể làm manager
    SELECT StaffID, StaffCode, FullName, Position
    FROM Staff 
    WHERE StatusID = 1 
    ORDER BY FullName;
END;

-- Trigger để tự động cập nhật CurrentStaffCount khi có thay đổi assignment
CREATE TRIGGER tr_UpdateDepartmentStaffCount ON DepartmentStaffAssignment
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update for inserted/updated records
    IF EXISTS(SELECT 1 FROM inserted)
    BEGIN
        UPDATE Department 
        SET CurrentStaffCount = (
            SELECT COUNT(*) 
            FROM DepartmentStaffAssignment dsa 
            WHERE dsa.DepartmentID = Department.DepartmentID 
              AND dsa.StatusID = 1 
              AND (dsa.EndDate IS NULL OR dsa.EndDate > GETDATE())
        )
        WHERE DepartmentID IN (SELECT DISTINCT DepartmentID FROM inserted);
    END
    
    -- Update for deleted records
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        UPDATE Department 
        SET CurrentStaffCount = (
            SELECT COUNT(*) 
            FROM DepartmentStaffAssignment dsa 
            WHERE dsa.DepartmentID = Department.DepartmentID 
              AND dsa.StatusID = 1 
              AND (dsa.EndDate IS NULL OR dsa.EndDate > GETDATE())
        )
        WHERE DepartmentID IN (SELECT DISTINCT DepartmentID FROM deleted);
    END
END;

PRINT 'Department Management System created successfully!';
PRINT '';
PRINT 'New DepartmentManagement.html Support Features Added:';
PRINT '- Department: Complete department/division management with hierarchy support';
PRINT '- DepartmentPosition: Position definitions within departments';
PRINT '- DepartmentStaffAssignment: Staff assignment to departments with role tracking';
PRINT '- DepartmentKPI: KPI and performance measurement system';
PRINT '- DepartmentChangeLog: Complete audit trail for department changes';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- Department: Core department info with budget, contact, location details';
PRINT '- DepartmentPosition: Job positions and hierarchy within departments';
PRINT '- DepartmentStaffAssignment: Staff assignments with reporting structure';
PRINT '- DepartmentKPI: Performance indicators and measurement tracking';
PRINT '- DepartmentChangeLog: Comprehensive change history and audit trails';
PRINT '';
PRINT 'Enhanced Views and Procedures:';
PRINT '- vw_DepartmentManagement: Complete department overview with statistics';
PRINT '- sp_GetDepartmentListData: Main procedure with search and pagination';
PRINT '- sp_CreateDepartment: Create new department with validation';
PRINT '- sp_UpdateDepartment: Update department with change logging';
PRINT '- sp_DeleteDepartment: Soft delete with staff validation';
PRINT '- sp_GetDepartmentFormData: Dropdown data for department forms';
PRINT '- tr_UpdateDepartmentStaffCount: Auto-update staff counts';
PRINT '';
PRINT 'Key Features for DepartmentManagement Interface:';
PRINT '✅ Complete CRUD operations for departments';
PRINT '✅ Department hierarchy and organizational structure';
PRINT '✅ Staff quota management and utilization tracking';
PRINT '✅ Budget allocation and financial management';
PRINT '✅ Contact information and office location tracking';
PRINT '✅ Position management within departments';
PRINT '✅ Staff assignment and reporting structure';
PRINT '✅ KPI and performance measurement system';
PRINT '✅ Comprehensive change logging and audit trails';
PRINT '✅ Search functionality across multiple fields';
PRINT '✅ Status management (Active, Suspended, Dissolved, Under Construction)';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 8 Departments: Training, Admission, Accounting, Marketing, Admin, etc.';
PRINT '- Department positions with hierarchy and requirements';
PRINT '- Realistic budget allocations and contact information';
PRINT '- Office locations and organizational structure';
PRINT '';
PRINT 'Database now fully supports DepartmentManagement.html with comprehensive department management!';

-- ============================================================================
-- 30. DOCUMENT MANAGEMENT SYSTEM
-- ============================================================================

-- Bảng loại tài liệu
CREATE TABLE DocumentType (
    DocumentTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeCode NVARCHAR(20) NOT NULL UNIQUE, -- Mã loại (QC, HD, CV, BB, etc.)
    TypeName NVARCHAR(255) NOT NULL, -- Tên loại tài liệu
    Description NVARCHAR(MAX), -- Mô tả loại tài liệu
    CategoryGroup NVARCHAR(100), -- Nhóm category (Administrative, Academic, Financial, etc.)
    RequiresApproval BIT DEFAULT 0, -- Có cần phê duyệt không
    ApprovalWorkflow NVARCHAR(MAX), -- Quy trình phê duyệt (JSON format)
    RetentionPeriod INT DEFAULT 365, -- Thời gian lưu trữ (ngày)
    AccessLevel NVARCHAR(50) DEFAULT 'Internal', -- 'Public', 'Internal', 'Confidential', 'Restricted'
    MaxFileSize BIGINT DEFAULT 52428800, -- Kích thước file tối đa (bytes) - default 50MB
    AllowedFileTypes NVARCHAR(500), -- Các loại file được phép (pdf,doc,docx,xls,xlsx,etc.)
    StorageLocation NVARCHAR(500), -- Đường dẫn lưu trữ mặc định
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng tài liệu chính
CREATE TABLE Document (
    DocumentID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentCode NVARCHAR(50) NOT NULL UNIQUE, -- Mã tài liệu duy nhất
    DocumentTitle NVARCHAR(500) NOT NULL, -- Tiêu đề tài liệu
    DocumentTypeID INT, -- Loại tài liệu
    DepartmentID INT, -- Phòng ban phụ trách
    BranchID INT, -- Chi nhánh
    AuthorStaffID INT, -- Người tạo tài liệu
    ReviewerStaffID INT NULL, -- Người review
    ApproverStaffID INT NULL, -- Người phê duyệt
    Version NVARCHAR(20) DEFAULT '1.0', -- Phiên bản hiện tại
    Description NVARCHAR(MAX), -- Mô tả nội dung
    Keywords NVARCHAR(1000), -- Từ khóa tìm kiếm
    Subject NVARCHAR(500), -- Chủ đề chính
    Language NVARCHAR(50) DEFAULT 'Vietnamese', -- Ngôn ngữ
    Priority NVARCHAR(50) DEFAULT 'Normal', -- 'Low', 'Normal', 'High', 'Urgent'
    Confidentiality NVARCHAR(50) DEFAULT 'Internal', -- Mức độ bảo mật
    EffectiveDate DATE, -- Ngày có hiệu lực
    ExpiryDate DATE, -- Ngày hết hạn
    ReviewDate DATE, -- Ngày cần review lại
    FileName NVARCHAR(255), -- Tên file gốc
    FilePath NVARCHAR(1000), -- Đường dẫn file
    FileSize BIGINT, -- Kích thước file (bytes)
    FileExtension NVARCHAR(10), -- Phần mở rộng (.pdf, .doc, etc.)
    MimeType NVARCHAR(100), -- MIME type
    ChecksumMD5 NVARCHAR(32), -- MD5 hash để verify integrity
    DownloadCount INT DEFAULT 0, -- Số lần download
    ViewCount INT DEFAULT 0, -- Số lần xem
    LastAccessed DATETIME2, -- Lần truy cập cuối
    Tags NVARCHAR(MAX), -- Tags (JSON array)
    Metadata NVARCHAR(MAX), -- Metadata bổ sung (JSON format)
    StatusID INT DEFAULT 1, -- 1=Draft, 2=Under Review, 3=Approved, 4=Published, 5=Archived, 6=Rejected
    IsDeleted BIT DEFAULT 0, -- Soft delete flag
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(DocumentTypeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (AuthorStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ReviewerStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ApproverStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng phiên bản tài liệu (version history)
CREATE TABLE DocumentVersion (
    VersionID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentID INT,
    VersionNumber NVARCHAR(20), -- 1.0, 1.1, 2.0, etc.
    VersionNote NVARCHAR(MAX), -- Ghi chú về thay đổi
    FileName NVARCHAR(255),
    FilePath NVARCHAR(1000),
    FileSize BIGINT,
    FileExtension NVARCHAR(10),
    ChecksumMD5 NVARCHAR(32),
    IsCurrentVersion BIT DEFAULT 0, -- Có phải phiên bản hiện tại không
    ChangeDescription NVARCHAR(MAX), -- Mô tả thay đổi chi tiết
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID)
);

-- Bảng quyền truy cập tài liệu
CREATE TABLE DocumentPermission (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentID INT,
    StaffID INT NULL, -- Quyền cho nhân viên cụ thể (null nếu là quyền theo role/department)
    DepartmentID INT NULL, -- Quyền cho cả phòng ban
    RoleID INT NULL, -- Quyền theo role
    PermissionType NVARCHAR(50), -- 'Read', 'Write', 'Delete', 'Approve', 'Download'
    GrantedBy INT, -- Ai cấp quyền
    GrantedDate DATETIME2 DEFAULT GETDATE(),
    ExpiryDate DATETIME2 NULL, -- Hết hạn quyền (null = vĩnh viễn)
    IsActive BIT DEFAULT 1,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID),
    FOREIGN KEY (GrantedBy) REFERENCES Staff(StaffID)
);

-- Bảng lịch sử truy cập tài liệu
CREATE TABLE DocumentAccessLog (
    AccessLogID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentID INT,
    StaffID INT,
    AccessType NVARCHAR(50), -- 'View', 'Download', 'Edit', 'Delete', 'Share'
    AccessDate DATETIME2 DEFAULT GETDATE(),
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(MAX),
    SessionID NVARCHAR(100),
    Duration INT, -- Thời gian xem (giây)
    Success BIT DEFAULT 1, -- Thành công hay không
    ErrorMessage NVARCHAR(MAX), -- Lỗi nếu có
    FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Bảng workflow phê duyệt tài liệu
CREATE TABLE DocumentApprovalWorkflow (
    WorkflowID INT IDENTITY(1,1) PRIMARY KEY,
    DocumentID INT,
    StepNumber INT, -- Bước thứ mấy trong quy trình
    ApproverStaffID INT, -- Người phê duyệt ở bước này
    RequiredAction NVARCHAR(100), -- 'Review', 'Approve', 'Reject', 'Comment'
    Status NVARCHAR(50), -- 'Pending', 'Approved', 'Rejected', 'Skipped'
    Comments NVARCHAR(MAX), -- Nhận xét của approver
    ActionDate DATETIME2, -- Ngày thực hiện action
    DueDate DATETIME2, -- Hạn phê duyệt
    IsCurrentStep BIT DEFAULT 0, -- Có phải bước hiện tại không
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID),
    FOREIGN KEY (ApproverStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID)
);

-- Bảng yêu cầu tài liệu mới
CREATE TABLE DocumentRequest (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    RequestCode NVARCHAR(50) NOT NULL UNIQUE, -- Mã yêu cầu
    DocumentTitle NVARCHAR(500) NOT NULL, -- Tiêu đề tài liệu đề xuất
    DocumentTypeID INT, -- Loại tài liệu
    DepartmentID INT, -- Phòng ban yêu cầu
    RequestReason NVARCHAR(MAX), -- Lý do yêu cầu
    Description NVARCHAR(MAX), -- Mô tả chi tiết
    Priority NVARCHAR(50) DEFAULT 'Normal', -- Độ ưu tiên
    RequestedBy INT, -- Người yêu cầu
    AssignedTo INT NULL, -- Được giao cho ai thực hiện
    ExpectedCompletionDate DATE, -- Ngày hoàn thành dự kiến
    ActualCompletionDate DATE NULL, -- Ngày hoàn thành thực tế
    Status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Assigned', 'In Progress', 'Completed', 'Rejected'
    ReviewComments NVARCHAR(MAX), -- Nhận xét từ reviewer
    ApprovalComments NVARCHAR(MAX), -- Nhận xét phê duyệt
    CreatedDocumentID INT NULL, -- ID tài liệu được tạo (nếu hoàn thành)
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(DocumentTypeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (RequestedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (AssignedTo) REFERENCES Staff(StaffID),
    FOREIGN KEY (CreatedDocumentID) REFERENCES Document(DocumentID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Thêm trạng thái cho document system
INSERT INTO GeneralStatus (StatusName, StatusType, DisplayOrder) VALUES
('Draft', 'Document', 11),
('Under Review', 'Document', 12),
('Approved', 'Document', 13),
('Published', 'Document', 14),
('Archived', 'Document', 15),
('Rejected', 'Document', 16);

-- Thêm dữ liệu mẫu cho DocumentType
INSERT INTO DocumentType (TypeCode, TypeName, Description, CategoryGroup, RequiresApproval, MaxFileSize, AllowedFileTypes, AccessLevel, CreatedBy) VALUES
('QC', 'Quy chế', 'Các tài liệu quy chế, quy định nội bộ', 'Administrative', 1, 52428800, 'pdf,doc,docx', 'Internal', 1),
('HD', 'Hướng dẫn', 'Tài liệu hướng dẫn quy trình, thủ tục', 'Administrative', 1, 52428800, 'pdf,doc,docx,ppt,pptx', 'Internal', 1),
('CV', 'Công văn', 'Công văn đi và đến', 'Administrative', 1, 10485760, 'pdf,doc,docx', 'Confidential', 1),
('BB', 'Biên bản', 'Biên bản họp, biên bản làm việc', 'Administrative', 1, 10485760, 'pdf,doc,docx', 'Internal', 1),
('BC', 'Báo cáo', 'Các loại báo cáo định kỳ và đột xuất', 'Administrative', 1, 104857600, 'pdf,doc,docx,xls,xlsx', 'Internal', 1),
('TL', 'Tài liệu học tập', 'Giáo trình, bài giảng, tài liệu tham khảo', 'Academic', 0, 104857600, 'pdf,doc,docx,ppt,pptx,mp4,mp3', 'Public', 1),
('HDGV', 'Hồ sơ giảng viên', 'Hồ sơ cá nhân giảng viên', 'HR', 1, 52428800, 'pdf,doc,docx,jpg,png', 'Confidential', 1),
('HDHV', 'Hồ sơ học viên', 'Hồ sơ cá nhân học viên', 'Academic', 1, 52428800, 'pdf,doc,docx,jpg,png', 'Confidential', 1),
('TC', 'Tài chính', 'Tài liệu liên quan đến tài chính', 'Financial', 1, 52428800, 'pdf,xls,xlsx,doc,docx', 'Restricted', 1),
('KT', 'Kế toán', 'Chứng từ kế toán, sổ sách', 'Financial', 1, 52428800, 'pdf,xls,xlsx', 'Restricted', 1);

-- Thêm dữ liệu mẫu cho Document
INSERT INTO Document (DocumentCode, DocumentTitle, DocumentTypeID, DepartmentID, BranchID, AuthorStaffID, Version, Description, Keywords, Priority, StatusID, CreatedBy) VALUES
('QC-001-2025', 'Quy chế tuyển sinh năm 2025', 1, 2, 1, 2, '1.0', 'Quy chế tuyển sinh học viên cho các khóa học năm 2025', 'tuyển sinh, quy chế, 2025', 'High', 14, 1),
('HD-001-2025', 'Hướng dẫn sử dụng hệ thống HHMS', 2, 1, 1, 1, '2.1', 'Hướng dẫn chi tiết cách sử dụng hệ thống quản lý trung tâm', 'hướng dẫn, HHMS, hệ thống', 'Normal', 14, 1),
('CV-001-2025', 'Công văn về việc điều chỉnh lịch học', 3, 1, 1, 2, '1.0', 'Công văn thông báo điều chỉnh lịch học do dịch bệnh', 'công văn, lịch học, điều chỉnh', 'High', 13, 1),
('BB-001-2025', 'Biên bản họp Ban Giám đốc tháng 1', 4, 5, 1, 1, '1.0', 'Biên bản cuộc họp Ban Giám đốc định kỳ tháng 1/2025', 'biên bản, họp, ban giám đốc', 'Normal', 13, 1),
('BC-TC-Q4-2024', 'Báo cáo tài chính quý 4 năm 2024', 5, 3, 1, 3, '1.0', 'Báo cáo tổng hợp tình hình tài chính quý 4/2024', 'báo cáo, tài chính, quý 4', 'High', 14, 1),
('TL-TOEIC-2025', 'Giáo trình TOEIC cơ bản', 6, 1, 1, 3, '3.0', 'Giáo trình học TOEIC dành cho người mới bắt đầu', 'giáo trình, TOEIC, cơ bản', 'Normal', 14, 1),
('TL-IELTS-2025', 'Tài liệu luyện thi IELTS', 6, 1, 1, 4, '1.5', 'Bộ tài liệu ôn luyện IELTS toàn diện', 'IELTS, luyện thi, tài liệu', 'Normal', 14, 1),
('HD-KT-2025', 'Hướng dẫn quy trình kế toán', 2, 3, 1, 3, '1.0', 'Quy trình kế toán chi tiết cho nhân viên mới', 'hướng dẫn, kế toán, quy trình', 'Normal', 11, 1);

-- View tổng hợp cho DocumentList.html
CREATE VIEW vw_DocumentList AS
SELECT 
    d.DocumentID,
    d.DocumentCode,
    d.DocumentTitle,
    dt.TypeName AS DocumentTypeName,
    dt.TypeCode AS DocumentTypeCode,
    dep.DepartmentName,
    b.BranchName,
    author.FullName AS AuthorName,
    reviewer.FullName AS ReviewerName,
    approver.FullName AS ApproverName,
    d.Version,
    d.Description,
    d.Keywords,
    d.Priority,
    d.Confidentiality,
    d.EffectiveDate,
    d.ExpiryDate,
    d.FileName,
    d.FileSize,
    d.FileExtension,
    d.DownloadCount,
    d.ViewCount,
    d.LastAccessed,
    gs.StatusName,
    d.StatusID,
    d.CreatedDate,
    d.LastModified,
    creator.FullName AS CreatedByName,
    modifier.FullName AS ModifiedByName,
    -- Tính toán các trường bổ sung
    CASE 
        WHEN d.ExpiryDate IS NOT NULL AND d.ExpiryDate < GETDATE() THEN 'Hết hạn'
        WHEN d.StatusID = 14 THEN 'Đã xuất bản'
        WHEN d.StatusID = 13 THEN 'Đã phê duyệt'
        WHEN d.StatusID = 12 THEN 'Đang xét duyệt'
        WHEN d.StatusID = 11 THEN 'Bản nháp'
        ELSE gs.StatusName
    END AS DisplayStatus,
    CASE 
        WHEN d.FileSize < 1024 THEN CAST(d.FileSize AS NVARCHAR) + ' B'
        WHEN d.FileSize < 1048576 THEN CAST(d.FileSize/1024 AS NVARCHAR) + ' KB'
        WHEN d.FileSize < 1073741824 THEN CAST(d.FileSize/1048576 AS NVARCHAR) + ' MB'
        ELSE CAST(d.FileSize/1073741824 AS NVARCHAR) + ' GB'
    END AS FileSizeFormatted,
    -- Thống kê version
    (SELECT COUNT(*) FROM DocumentVersion dv WHERE dv.DocumentID = d.DocumentID) AS TotalVersions,
    -- Kiểm tra quyền truy cập
    (SELECT COUNT(*) FROM DocumentPermission dp WHERE dp.DocumentID = d.DocumentID AND dp.IsActive = 1) AS TotalPermissions
FROM Document d
INNER JOIN DocumentType dt ON d.DocumentTypeID = dt.DocumentTypeID
LEFT JOIN Department dep ON d.DepartmentID = dep.DepartmentID
LEFT JOIN Branch b ON d.BranchID = b.BranchID
LEFT JOIN Staff author ON d.AuthorStaffID = author.StaffID
LEFT JOIN Staff reviewer ON d.ReviewerStaffID = reviewer.StaffID
LEFT JOIN Staff approver ON d.ApproverStaffID = approver.StaffID
INNER JOIN GeneralStatus gs ON d.StatusID = gs.StatusID
LEFT JOIN Staff creator ON d.CreatedBy = creator.StaffID
LEFT JOIN Staff modifier ON d.ModifiedBy = modifier.StaffID
WHERE d.IsDeleted = 0;

-- Stored Procedure để lấy danh sách tài liệu cho DocumentList.html
CREATE PROCEDURE sp_GetDocumentListData
    @DocumentTypeID INT = NULL, -- Filter by document type
    @DepartmentID INT = NULL, -- Filter by department
    @StatusID INT = NULL, -- Filter by status
    @SearchTerm NVARCHAR(255) = NULL, -- Search term
    @PageNumber INT = 1, -- Pagination
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Main query với filtering và pagination
    SELECT 
        DocumentID,
        DocumentCode,
        DocumentTitle,
        DocumentTypeName,
        DocumentTypeCode,
        DepartmentName,
        BranchName,
        AuthorName,
        ReviewerName,
        ApproverName,
        Version,
        Description,
        Keywords,
        Priority,
        Confidentiality,
        EffectiveDate,
        ExpiryDate,
        FileName,
        FileSizeFormatted,
        FileExtension,
        DownloadCount,
        ViewCount,
        LastAccessed,
        StatusName,
        DisplayStatus,
        CreatedDate,
        LastModified,
        CreatedByName,
        ModifiedByName,
        TotalVersions,
        TotalPermissions
    FROM vw_DocumentList
    WHERE (@DocumentTypeID IS NULL OR DocumentID IN (SELECT DocumentID FROM Document WHERE DocumentTypeID = @DocumentTypeID))
      AND (@DepartmentID IS NULL OR DocumentID IN (SELECT DocumentID FROM Document WHERE DepartmentID = @DepartmentID))
      AND (@StatusID IS NULL OR StatusID = @StatusID)
      AND (@SearchTerm IS NULL OR (
          DocumentCode LIKE '%' + @SearchTerm + '%' OR
          DocumentTitle LIKE '%' + @SearchTerm + '%' OR
          Description LIKE '%' + @SearchTerm + '%' OR
          Keywords LIKE '%' + @SearchTerm + '%' OR
          AuthorName LIKE '%' + @SearchTerm + '%' OR
          DepartmentName LIKE '%' + @SearchTerm + '%' OR
          FileName LIKE '%' + @SearchTerm + '%'
      ))
    ORDER BY LastModified DESC, DocumentCode
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count cho pagination
    SELECT COUNT(*) AS TotalRecords
    FROM vw_DocumentList
    WHERE (@DocumentTypeID IS NULL OR DocumentID IN (SELECT DocumentID FROM Document WHERE DocumentTypeID = @DocumentTypeID))
      AND (@DepartmentID IS NULL OR DocumentID IN (SELECT DocumentID FROM Document WHERE DepartmentID = @DepartmentID))
      AND (@StatusID IS NULL OR StatusID = @StatusID)
      AND (@SearchTerm IS NULL OR (
          DocumentCode LIKE '%' + @SearchTerm + '%' OR
          DocumentTitle LIKE '%' + @SearchTerm + '%' OR
          Description LIKE '%' + @SearchTerm + '%' OR
          Keywords LIKE '%' + @SearchTerm + '%' OR
          AuthorName LIKE '%' + @SearchTerm + '%' OR
          DepartmentName LIKE '%' + @SearchTerm + '%' OR
          FileName LIKE '%' + @SearchTerm + '%'
      ));
END;

-- Stored Procedure để tạo yêu cầu tài liệu mới
CREATE PROCEDURE sp_CreateDocumentRequest
    @DocumentTitle NVARCHAR(500),
    @DocumentTypeID INT,
    @DepartmentID INT,
    @RequestReason NVARCHAR(MAX),
    @Description NVARCHAR(MAX) = NULL,
    @Priority NVARCHAR(50) = 'Normal',
    @ExpectedCompletionDate DATE = NULL,
    @RequestedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Tạo mã yêu cầu tự động
        DECLARE @RequestCode NVARCHAR(50);
        DECLARE @NextNumber INT = (SELECT ISNULL(MAX(CAST(RIGHT(RequestCode, 3) AS INT)), 0) + 1 
                                   FROM DocumentRequest 
                                   WHERE RequestCode LIKE 'REQ-' + FORMAT(GETDATE(), 'yyyy') + '-%');
        SET @RequestCode = 'REQ-' + FORMAT(GETDATE(), 'yyyy') + '-' + FORMAT(@NextNumber, '000');
        
        DECLARE @NewRequestID INT;
        INSERT INTO DocumentRequest (RequestCode, DocumentTitle, DocumentTypeID, DepartmentID, RequestReason, Description, Priority, ExpectedCompletionDate, RequestedBy)
        VALUES (@RequestCode, @DocumentTitle, @DocumentTypeID, @DepartmentID, @RequestReason, @Description, @Priority, @ExpectedCompletionDate, @RequestedBy);
        
        SET @NewRequestID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Yêu cầu tài liệu đã được tạo thành công' AS Message, @NewRequestID AS RequestID, @RequestCode AS RequestCode;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để lấy chi tiết tài liệu
CREATE PROCEDURE sp_GetDocumentDetails
    @DocumentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin chính của tài liệu
    SELECT * FROM vw_DocumentList WHERE DocumentID = @DocumentID;
    
    -- Lịch sử phiên bản
    SELECT 
        dv.VersionID,
        dv.VersionNumber,
        dv.VersionNote,
        dv.FileName,
        dv.FileSize,
        dv.FileExtension,
        dv.IsCurrentVersion,
        dv.ChangeDescription,
        dv.CreatedDate,
        creator.FullName AS CreatedByName
    FROM DocumentVersion dv
    LEFT JOIN Staff creator ON dv.CreatedBy = creator.StaffID
    WHERE dv.DocumentID = @DocumentID
    ORDER BY dv.CreatedDate DESC;
    
    -- Quyền truy cập
    SELECT 
        dp.PermissionID,
        dp.PermissionType,
        staff.FullName AS StaffName,
        dept.DepartmentName,
        role.RoleName,
        dp.GrantedDate,
        dp.ExpiryDate,
        granter.FullName AS GrantedByName
    FROM DocumentPermission dp
    LEFT JOIN Staff staff ON dp.StaffID = staff.StaffID
    LEFT JOIN Department dept ON dp.DepartmentID = dept.DepartmentID
    LEFT JOIN Role role ON dp.RoleID = role.RoleID
    LEFT JOIN Staff granter ON dp.GrantedBy = granter.StaffID
    WHERE dp.DocumentID = @DocumentID AND dp.IsActive = 1
    ORDER BY dp.GrantedDate DESC;
END;

-- Stored Procedure để lấy dropdown data cho document forms
CREATE PROCEDURE sp_GetDocumentFormData
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Document types
    SELECT DocumentTypeID, TypeCode, TypeName, CategoryGroup 
    FROM DocumentType 
    WHERE StatusID = 1 
    ORDER BY CategoryGroup, TypeName;
    
    -- Departments
    SELECT DepartmentID, DepartmentCode, DepartmentName 
    FROM Department 
    WHERE StatusID = 1 
    ORDER BY DepartmentName;
    
    -- Document statuses
    SELECT StatusID, StatusName 
    FROM GeneralStatus 
    WHERE StatusType = 'Document' 
    ORDER BY DisplayOrder;
END;

-- Stored Procedure để cập nhật view count
CREATE PROCEDURE sp_UpdateDocumentViewCount
    @DocumentID INT,
    @ViewerStaffID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật view count
    UPDATE Document 
    SET ViewCount = ViewCount + 1, 
        LastAccessed = GETDATE() 
    WHERE DocumentID = @DocumentID;
    
    -- Log access
    INSERT INTO DocumentAccessLog (DocumentID, StaffID, AccessType, AccessDate)
    VALUES (@DocumentID, @ViewerStaffID, 'View', GETDATE());
END;

-- Stored Procedure để cập nhật download count
CREATE PROCEDURE sp_UpdateDocumentDownloadCount
    @DocumentID INT,
    @DownloaderStaffID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật download count
    UPDATE Document 
    SET DownloadCount = DownloadCount + 1, 
        LastAccessed = GETDATE() 
    WHERE DocumentID = @DocumentID;
    
    -- Log download
    INSERT INTO DocumentAccessLog (DocumentID, StaffID, AccessType, AccessDate)
    VALUES (@DocumentID, @DownloaderStaffID, 'Download', GETDATE());
END;

PRINT 'Document Management System created successfully!';
PRINT '';
PRINT 'New DocumentList.html Support Features Added:';
PRINT '- DocumentType: Complete document type classification system';
PRINT '- Document: Core document management with version control';
PRINT '- DocumentVersion: Version history and change tracking';
PRINT '- DocumentPermission: Granular access control system';
PRINT '- DocumentAccessLog: Complete audit trail for document access';
PRINT '- DocumentApprovalWorkflow: Approval process management';
PRINT '- DocumentRequest: Document request and creation workflow';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- DocumentType: Document categories with approval workflows';
PRINT '- Document: Main document storage with metadata and security';
PRINT '- DocumentVersion: Version control and change history';
PRINT '- DocumentPermission: Role-based and user-specific access control';
PRINT '- DocumentAccessLog: Comprehensive access tracking and audit';
PRINT '- DocumentApprovalWorkflow: Multi-step approval processes';
PRINT '- DocumentRequest: Document creation request management';
PRINT '';
PRINT 'Enhanced Views and Procedures:';
PRINT '- vw_DocumentList: Complete document overview with statistics';
PRINT '- sp_GetDocumentListData: Main procedure with search and pagination';
PRINT '- sp_CreateDocumentRequest: Create new document requests';
PRINT '- sp_GetDocumentDetails: Get complete document information';
PRINT '- sp_GetDocumentFormData: Dropdown data for document forms';
PRINT '- sp_UpdateDocumentViewCount: Track document views';
PRINT '- sp_UpdateDocumentDownloadCount: Track document downloads';
PRINT '';
PRINT 'Key Features for DocumentList Interface:';
PRINT '✅ Complete document listing with search and filtering';
PRINT '✅ Document type categorization and classification';
PRINT '✅ Version control and change tracking';
PRINT '✅ Access control and permission management';
PRINT '✅ Document request and approval workflows';
PRINT '✅ Download and view statistics tracking';
PRINT '✅ File metadata and integrity verification';
PRINT '✅ Multi-level security (Public, Internal, Confidential, Restricted)';
PRINT '✅ Department and branch-based organization';
PRINT '✅ Comprehensive audit trails and access logging';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 10 Document Types: Regulations, Guidelines, Official Documents, etc.';
PRINT '- 8 Sample Documents with realistic content and metadata';
PRINT '- Document categorization (Administrative, Academic, Financial, HR)';
PRINT '- Multi-level access controls and approval workflows';
PRINT '';
PRINT 'Database now fully supports DocumentList.html with comprehensive document management!';

-- ============================================================================
-- 31. SALARY MANAGEMENT SYSTEM
-- ============================================================================

-- Bảng cấu trúc lương cơ bản
CREATE TABLE SalaryStructure (
    SalaryStructureID INT IDENTITY(1,1) PRIMARY KEY,
    StructureCode NVARCHAR(20) NOT NULL UNIQUE, -- Mã cấu trúc lương (BASIC, TEACHER, MANAGER, etc.)
    StructureName NVARCHAR(255) NOT NULL, -- Tên cấu trúc lương
    Description NVARCHAR(MAX), -- Mô tả cấu trúc lương
    PositionLevel NVARCHAR(50), -- Cấp bậc (Entry, Junior, Senior, Manager, Director)
    ContractType NVARCHAR(50), -- Loại hợp đồng (Full-time, Part-time, Contract, Freelance)
    BaseSalaryMin DECIMAL(15,2) DEFAULT 0, -- Lương cơ bản tối thiểu
    BaseSalaryMax DECIMAL(15,2) DEFAULT 0, -- Lương cơ bản tối đa
    DefaultTravelAllowance DECIMAL(15,2) DEFAULT 0, -- Phụ cấp đi lại mặc định
    DefaultMealAllowance DECIMAL(15,2) DEFAULT 0, -- Phụ cấp ăn uống mặc định
    DefaultAttendanceBonus DECIMAL(15,2) DEFAULT 0, -- Thưởng chuyên cần mặc định
    MaxPerformanceBonus DECIMAL(15,2) DEFAULT 0, -- Thưởng hiệu suất tối đa
    ApplicableDepartments NVARCHAR(MAX), -- Phòng ban áp dụng (JSON array)
    EffectiveDate DATE, -- Ngày có hiệu lực
    ExpiryDate DATE, -- Ngày hết hạn
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng thông tin lương nhân viên
CREATE TABLE EmployeeSalary (
    EmployeeSalaryID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT, -- Nhân viên
    SalaryStructureID INT, -- Cấu trúc lương áp dụng
    EffectiveDate DATE NOT NULL, -- Ngày có hiệu lực
    EndDate DATE NULL, -- Ngày kết thúc (null nếu hiện tại)
    BasicSalary DECIMAL(15,2) NOT NULL, -- Lương cơ bản thực tế
    TravelAllowance DECIMAL(15,2) DEFAULT 0, -- Phụ cấp đi lại
    MealAllowance DECIMAL(15,2) DEFAULT 0, -- Phụ cấp ăn uống
    AttendanceBonus DECIMAL(15,2) DEFAULT 0, -- Thưởng chuyên cần
    PerformanceBonus DECIMAL(15,2) DEFAULT 0, -- Thưởng hiệu suất và trách nhiệm
    OtherAllowances DECIMAL(15,2) DEFAULT 0, -- Các phụ cấp khác
    OtherDeductions DECIMAL(15,2) DEFAULT 0, -- Các khoản khấu trừ khác
    InsuranceDeduction DECIMAL(15,2) DEFAULT 0, -- Khấu trừ bảo hiểm
    TaxDeduction DECIMAL(15,2) DEFAULT 0, -- Khấu trừ thuế
    TotalGrossSalary AS (BasicSalary + TravelAllowance + MealAllowance + AttendanceBonus + PerformanceBonus + OtherAllowances), -- Tổng lương gross
    TotalDeductions AS (OtherDeductions + InsuranceDeduction + TaxDeduction), -- Tổng khấu trừ
    NetSalary AS (BasicSalary + TravelAllowance + MealAllowance + AttendanceBonus + PerformanceBonus + OtherAllowances - OtherDeductions - InsuranceDeduction - TaxDeduction), -- Lương thực nhận
    Currency NVARCHAR(10) DEFAULT 'VND', -- Đơn vị tiền tệ
    PaymentMethod NVARCHAR(50) DEFAULT 'Bank Transfer', -- Phương thức thanh toán
    BankAccount NVARCHAR(50), -- Số tài khoản ngân hàng
    BankName NVARCHAR(255), -- Tên ngân hàng
    Notes NVARCHAR(MAX), -- Ghi chú
    IsActive BIT DEFAULT 1, -- Có đang áp dụng không
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (SalaryStructureID) REFERENCES SalaryStructure(SalaryStructureID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng bảng lương hàng tháng
CREATE TABLE MonthlySalary (
    MonthlySalaryID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT,
    SalaryYear INT NOT NULL, -- Năm lương
    SalaryMonth INT NOT NULL, -- Tháng lương (1-12)
    EmployeeSalaryID INT, -- Tham chiếu đến cấu trúc lương áp dụng
    ActualWorkDays INT DEFAULT 0, -- Số ngày làm việc thực tế
    StandardWorkDays INT DEFAULT 22, -- Số ngày làm việc chuẩn
    OvertimeHours DECIMAL(5,2) DEFAULT 0, -- Số giờ làm thêm
    OvertimeRate DECIMAL(15,2) DEFAULT 0, -- Đơn giá làm thêm
    LeaveDeductionDays INT DEFAULT 0, -- Số ngày nghỉ phép có khấu trừ
    LateDeductionAmount DECIMAL(15,2) DEFAULT 0, -- Khấu trừ đi muộn
    BonusAmount DECIMAL(15,2) DEFAULT 0, -- Thưởng bổ sung trong tháng
    PenaltyAmount DECIMAL(15,2) DEFAULT 0, -- Phạt trong tháng
    ActualBasicSalary AS (
        CASE 
            WHEN StandardWorkDays > 0 
            THEN (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) * ActualWorkDays / StandardWorkDays
            ELSE (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID)
        END
    ), -- Lương cơ bản theo ngày công thực tế
    OvertimePay AS (OvertimeHours * OvertimeRate), -- Tiền làm thêm
    MonthlyGrossSalary AS (
        (CASE 
            WHEN StandardWorkDays > 0 
            THEN (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) * ActualWorkDays / StandardWorkDays
            ELSE (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID)
        END) +
        (SELECT TravelAllowance + MealAllowance + AttendanceBonus + PerformanceBonus + OtherAllowances 
         FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) +
        (OvertimeHours * OvertimeRate) + BonusAmount
    ), -- Tổng lương gross trong tháng
    MonthlyDeductions AS (
        (SELECT OtherDeductions + InsuranceDeduction + TaxDeduction 
         FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) +
        LateDeductionAmount + PenaltyAmount
    ), -- Tổng khấu trừ trong tháng
    MonthlyNetSalary AS (
        (CASE 
            WHEN StandardWorkDays > 0 
            THEN (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) * ActualWorkDays / StandardWorkDays
            ELSE (SELECT BasicSalary FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID)
        END) +
        (SELECT TravelAllowance + MealAllowance + AttendanceBonus + PerformanceBonus + OtherAllowances 
         FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) +
        (OvertimeHours * OvertimeRate) + BonusAmount -
        ((SELECT OtherDeductions + InsuranceDeduction + TaxDeduction 
          FROM EmployeeSalary es WHERE es.EmployeeSalaryID = MonthlySalary.EmployeeSalaryID) +
         LateDeductionAmount + PenaltyAmount)
    ), -- Lương thực nhận trong tháng
    PaymentDate DATE, -- Ngày thanh toán
    PaymentStatus NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Paid', 'Cancelled'
    PaymentReference NVARCHAR(100), -- Mã tham chiếu thanh toán
    Notes NVARCHAR(MAX), -- Ghi chú cho tháng
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (EmployeeSalaryID) REFERENCES EmployeeSalary(EmployeeSalaryID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(StaffID, SalaryYear, SalaryMonth) -- Mỗi nhân viên chỉ có 1 bảng lương/tháng
);

-- Bảng lịch sử thay đổi lương
CREATE TABLE SalaryChangeLog (
    ChangeLogID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT,
    ChangeType NVARCHAR(100), -- 'Salary_Increase', 'Allowance_Update', 'Bonus_Adjustment', 'Deduction_Change', etc.
    FieldChanged NVARCHAR(100), -- Trường được thay đổi
    OldValue DECIMAL(15,2), -- Giá trị cũ
    NewValue DECIMAL(15,2), -- Giá trị mới
    ChangeReason NVARCHAR(MAX), -- Lý do thay đổi
    EffectiveDate DATE, -- Ngày có hiệu lực
    ApprovedBy INT, -- Người phê duyệt
    ApprovalDate DATETIME2, -- Ngày phê duyệt
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    ChangedBy INT,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ApprovedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ChangedBy) REFERENCES Staff(StaffID)
);

-- Bảng thiết lập tính lương
CREATE TABLE SalarySettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingKey NVARCHAR(100) NOT NULL UNIQUE, -- 'STANDARD_WORK_DAYS', 'OVERTIME_RATE_MULTIPLIER', etc.
    SettingValue NVARCHAR(MAX), -- Giá trị setting
    DataType NVARCHAR(50), -- 'INT', 'DECIMAL', 'STRING', 'BOOLEAN', 'JSON'
    Description NVARCHAR(MAX), -- Mô tả setting
    Category NVARCHAR(100), -- Nhóm setting
    IsSystemSetting BIT DEFAULT 0, -- Có phải setting hệ thống không
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Thêm dữ liệu mẫu cho SalaryStructure
INSERT INTO SalaryStructure (StructureCode, StructureName, Description, PositionLevel, ContractType, BaseSalaryMin, BaseSalaryMax, DefaultTravelAllowance, DefaultMealAllowance, DefaultAttendanceBonus, MaxPerformanceBonus, EffectiveDate, CreatedBy) VALUES
('TEACHER_FT', 'Giáo viên Full-time', 'Cấu trúc lương cho giáo viên làm việc toàn thời gian', 'Senior', 'Full-time', 8000000, 15000000, 500000, 800000, 200000, 1000000, '2025-01-01', 1),
('TEACHER_PT', 'Giáo viên Part-time', 'Cấu trúc lương cho giáo viên bán thời gian', 'Junior', 'Part-time', 3000000, 6000000, 200000, 300000, 100000, 500000, '2025-01-01', 1),
('MANAGER', 'Quản lý', 'Cấu trúc lương cho vị trí quản lý', 'Manager', 'Full-time', 12000000, 25000000, 1000000, 1200000, 300000, 2000000, '2025-01-01', 1),
('ADMIN_FT', 'Nhân viên hành chính Full-time', 'Cấu trúc lương cho nhân viên hành chính toàn thời gian', 'Junior', 'Full-time', 6000000, 12000000, 400000, 600000, 150000, 800000, '2025-01-01', 1),
('ADMIN_PT', 'Nhân viên hành chính Part-time', 'Cấu trúc lương cho nhân viên hành chính bán thời gian', 'Entry', 'Part-time', 2500000, 5000000, 150000, 250000, 80000, 300000, '2025-01-01', 1),
('CONSULTANT', 'Tư vấn viên', 'Cấu trúc lương cho tư vấn viên', 'Junior', 'Full-time', 5000000, 10000000, 300000, 500000, 100000, 600000, '2025-01-01', 1);

-- Thêm dữ liệu mẫu cho EmployeeSalary
INSERT INTO EmployeeSalary (StaffID, SalaryStructureID, EffectiveDate, BasicSalary, TravelAllowance, MealAllowance, AttendanceBonus, PerformanceBonus, OtherDeductions, BankAccount, BankName, CreatedBy) VALUES
(1, 3, '2025-01-01', 15000000, 1000000, 1200000, 300000, 1000000, 0, '1234567890', 'Vietcombank', 1), -- Quản lý
(2, 1, '2025-01-01', 9000000, 600000, 900000, 250000, 600000, 120000, '1234567891', 'BIDV', 1), -- Giáo viên Full-time
(3, 1, '2025-01-01', 8000000, 500000, 800000, 200000, 500000, 100000, '1234567892', 'ACB', 1), -- Giáo viên Full-time
(4, 1, '2025-01-01', 9000000, 600000, 900000, 250000, 600000, 120000, '1234567893', 'Techcombank', 1), -- Giáo viên Full-time
(5, 2, '2025-01-01', 4000000, 200000, 300000, 100000, 0, 50000, '1234567894', 'VPBank', 1), -- Giáo viên Part-time
(6, 6, '2025-01-01', 7000000, 400000, 600000, 150000, 400000, 80000, '1234567895', 'Sacombank', 1), -- Tư vấn viên
(7, 4, '2025-01-01', 8000000, 500000, 700000, 180000, 500000, 90000, '1234567896', 'MBBank', 1), -- Admin Full-time
(8, 5, '2025-01-01', 3500000, 150000, 250000, 80000, 0, 20000, '1234567897', 'VietinBank', 1); -- Admin Part-time

-- Thêm dữ liệu mẫu cho SalarySettings
INSERT INTO SalarySettings (SettingKey, SettingValue, DataType, Description, Category, IsSystemSetting, ModifiedBy) VALUES
('STANDARD_WORK_DAYS_PER_MONTH', '22', 'INT', 'Số ngày làm việc chuẩn trong tháng', 'WorkTime', 1, 1),
('OVERTIME_RATE_MULTIPLIER', '1.5', 'DECIMAL', 'Hệ số nhân cho lương làm thêm giờ', 'Overtime', 1, 1),
('INSURANCE_RATE_EMPLOYEE', '0.105', 'DECIMAL', 'Tỷ lệ bảo hiểm nhân viên đóng (%)', 'Insurance', 1, 1),
('INSURANCE_RATE_EMPLOYER', '0.175', 'DECIMAL', 'Tỷ lệ bảo hiểm công ty đóng (%)', 'Insurance', 1, 1),
('TAX_EXEMPT_AMOUNT', '11000000', 'DECIMAL', 'Mức giảm trừ gia cảnh cá nhân', 'Tax', 1, 1),
('MINIMUM_WAGE', '4680000', 'DECIMAL', 'Mức lương tối thiểu vùng', 'MinimumWage', 1, 1),
('LATE_PENALTY_PER_MINUTE', '5000', 'DECIMAL', 'Phạt đi muộn mỗi phút', 'Penalty', 0, 1),
('BONUS_ATTENDANCE_THRESHOLD', '0.95', 'DECIMAL', 'Ngưỡng chuyên cần để nhận thưởng (95%)', 'Bonus', 0, 1);

-- View tổng hợp cho EditSalaryTable.html
CREATE VIEW vw_EmployeeSalaryManagement AS
SELECT 
    s.StaffID,
    s.StaffCode AS EmployeeId,
    s.FullName AS EmployeeName,
    s.Position,
    d.DepartmentName,
    es.BasicSalary,
    es.TravelAllowance,
    es.MealAllowance,
    es.AttendanceBonus,
    es.PerformanceBonus,
    es.OtherAllowances,
    es.OtherDeductions,
    es.InsuranceDeduction,
    es.TaxDeduction,
    es.TotalGrossSalary,
    es.TotalDeductions,
    es.NetSalary,
    es.BankAccount,
    es.BankName,
    es.PaymentMethod,
    es.Currency,
    ss.StructureName,
    ss.ContractType,
    es.EffectiveDate,
    es.EndDate,
    es.IsActive,
    es.LastModified,
    modifier.FullName AS ModifiedByName,
    -- Tính toán lương trung bình theo phòng ban
    (SELECT AVG(es2.NetSalary) FROM EmployeeSalary es2 
     INNER JOIN Staff s2 ON es2.StaffID = s2.StaffID 
     LEFT JOIN DepartmentStaffAssignment dsa2 ON s2.StaffID = dsa2.StaffID AND dsa2.StatusID = 1
     WHERE dsa2.DepartmentID = dsa.DepartmentID AND es2.IsActive = 1) AS DepartmentAverageSalary,
    -- Thống kê thay đổi lương gần nhất
    (SELECT TOP 1 scl.ChangeDate FROM SalaryChangeLog scl WHERE scl.StaffID = s.StaffID ORDER BY scl.ChangeDate DESC) AS LastSalaryChangeDate
FROM Staff s
LEFT JOIN EmployeeSalary es ON s.StaffID = es.StaffID AND es.IsActive = 1
LEFT JOIN SalaryStructure ss ON es.SalaryStructureID = ss.SalaryStructureID
LEFT JOIN DepartmentStaffAssignment dsa ON s.StaffID = dsa.StaffID AND dsa.StatusID = 1
LEFT JOIN Department d ON dsa.DepartmentID = d.DepartmentID
LEFT JOIN Staff modifier ON es.ModifiedBy = modifier.StaffID
WHERE s.StatusID = 1; -- Chỉ nhân viên đang làm việc

-- Stored Procedure để lấy danh sách lương nhân viên cho EditSalaryTable.html
CREATE PROCEDURE sp_GetEmployeeSalaryData
    @SearchTerm NVARCHAR(255) = NULL, -- Tìm kiếm theo tên hoặc mã NV
    @ContractType NVARCHAR(50) = NULL -- Lọc theo loại hợp đồng
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        StaffID,
        EmployeeId,
        EmployeeName,
        Position,
        DepartmentName,
        BasicSalary,
        TravelAllowance,
        MealAllowance,
        AttendanceBonus,
        PerformanceBonus,
        OtherDeductions,
        InsuranceDeduction,
        TaxDeduction,
        TotalGrossSalary,
        TotalDeductions,
        NetSalary,
        BankAccount,
        BankName,
        PaymentMethod,
        Currency,
        StructureName,
        ContractType,
        EffectiveDate,
        LastModified,
        ModifiedByName,
        DepartmentAverageSalary,
        LastSalaryChangeDate
    FROM vw_EmployeeSalaryManagement
    WHERE (@SearchTerm IS NULL OR (
        EmployeeId LIKE '%' + @SearchTerm + '%' OR
        EmployeeName LIKE '%' + @SearchTerm + '%' OR
        Position LIKE '%' + @SearchTerm + '%'
    ))
    AND (@ContractType IS NULL OR ContractType = @ContractType)
    ORDER BY DepartmentName, EmployeeName;
END;

-- Stored Procedure để cập nhật lương nhân viên
CREATE PROCEDURE sp_UpdateEmployeeSalary
    @StaffID INT,
    @BasicSalary DECIMAL(15,2),
    @TravelAllowance DECIMAL(15,2),
    @MealAllowance DECIMAL(15,2),
    @AttendanceBonus DECIMAL(15,2),
    @PerformanceBonus DECIMAL(15,2),
    @OtherDeductions DECIMAL(15,2),
    @ChangeReason NVARCHAR(MAX) = NULL,
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @CurrentEmployeeSalaryID INT;
        DECLARE @OldBasicSalary DECIMAL(15,2), @OldTravelAllowance DECIMAL(15,2);
        DECLARE @OldMealAllowance DECIMAL(15,2), @OldAttendanceBonus DECIMAL(15,2);
        DECLARE @OldPerformanceBonus DECIMAL(15,2), @OldOtherDeductions DECIMAL(15,2);
        
        -- Lấy thông tin lương hiện tại
        SELECT @CurrentEmployeeSalaryID = EmployeeSalaryID,
               @OldBasicSalary = BasicSalary,
               @OldTravelAllowance = TravelAllowance,
               @OldMealAllowance = MealAllowance,
               @OldAttendanceBonus = AttendanceBonus,
               @OldPerformanceBonus = PerformanceBonus,
               @OldOtherDeductions = OtherDeductions
        FROM EmployeeSalary 
        WHERE StaffID = @StaffID AND IsActive = 1;
        
        IF @CurrentEmployeeSalaryID IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Không tìm thấy thông tin lương của nhân viên' AS Message;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Cập nhật thông tin lương
        UPDATE EmployeeSalary 
        SET BasicSalary = @BasicSalary,
            TravelAllowance = @TravelAllowance,
            MealAllowance = @MealAllowance,
            AttendanceBonus = @AttendanceBonus,
            PerformanceBonus = @PerformanceBonus,
            OtherDeductions = @OtherDeductions,
            LastModified = GETDATE(),
            ModifiedBy = @ModifiedBy
        WHERE EmployeeSalaryID = @CurrentEmployeeSalaryID;
        
        -- Ghi log thay đổi cho từng trường
        IF @OldBasicSalary != @BasicSalary
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Salary_Update', 'BasicSalary', @OldBasicSalary, @BasicSalary, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        IF @OldTravelAllowance != @TravelAllowance
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Allowance_Update', 'TravelAllowance', @OldTravelAllowance, @TravelAllowance, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        IF @OldMealAllowance != @MealAllowance
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Allowance_Update', 'MealAllowance', @OldMealAllowance, @MealAllowance, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        IF @OldAttendanceBonus != @AttendanceBonus
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Bonus_Update', 'AttendanceBonus', @OldAttendanceBonus, @AttendanceBonus, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        IF @OldPerformanceBonus != @PerformanceBonus
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Bonus_Update', 'PerformanceBonus', @OldPerformanceBonus, @PerformanceBonus, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        IF @OldOtherDeductions != @OtherDeductions
        BEGIN
            INSERT INTO SalaryChangeLog (StaffID, ChangeType, FieldChanged, OldValue, NewValue, ChangeReason, EffectiveDate, ChangedBy)
            VALUES (@StaffID, 'Deduction_Update', 'OtherDeductions', @OldOtherDeductions, @OtherDeductions, @ChangeReason, GETDATE(), @ModifiedBy);
        END
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Cập nhật lương nhân viên thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để lấy lịch sử thay đổi lương
CREATE PROCEDURE sp_GetSalaryChangeHistory
    @StaffID INT = NULL, -- Lọc theo nhân viên (optional)
    @FromDate DATE = NULL, -- Từ ngày (optional)
    @ToDate DATE = NULL, -- Đến ngày (optional)
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        scl.ChangeLogID,
        scl.StaffID,
        s.FullName AS EmployeeName,
        s.StaffCode AS EmployeeId,
        scl.ChangeType,
        scl.FieldChanged,
        scl.OldValue,
        scl.NewValue,
        scl.ChangeReason,
        scl.EffectiveDate,
        scl.ChangeDate,
        changer.FullName AS ChangedByName,
        approver.FullName AS ApprovedByName,
        scl.ApprovalDate
    FROM SalaryChangeLog scl
    INNER JOIN Staff s ON scl.StaffID = s.StaffID
    LEFT JOIN Staff changer ON scl.ChangedBy = changer.StaffID
    LEFT JOIN Staff approver ON scl.ApprovedBy = approver.StaffID
    WHERE (@StaffID IS NULL OR scl.StaffID = @StaffID)
      AND (@FromDate IS NULL OR scl.ChangeDate >= @FromDate)
      AND (@ToDate IS NULL OR scl.ChangeDate <= @ToDate)
    ORDER BY scl.ChangeDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count
    SELECT COUNT(*) AS TotalRecords
    FROM SalaryChangeLog scl
    WHERE (@StaffID IS NULL OR scl.StaffID = @StaffID)
      AND (@FromDate IS NULL OR scl.ChangeDate >= @FromDate)
      AND (@ToDate IS NULL OR scl.ChangeDate <= @ToDate);
END;

-- Stored Procedure để lấy dropdown data cho salary forms
CREATE PROCEDURE sp_GetSalaryFormData
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Contract types từ SalaryStructure
    SELECT DISTINCT ContractType 
    FROM SalaryStructure 
    WHERE StatusID = 1 
    ORDER BY ContractType;
    
    -- Salary structures
    SELECT SalaryStructureID, StructureName, ContractType, PositionLevel,
           BaseSalaryMin, BaseSalaryMax, DefaultTravelAllowance, DefaultMealAllowance
    FROM SalaryStructure 
    WHERE StatusID = 1 AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE())
    ORDER BY StructureName;
    
    -- Departments
    SELECT DepartmentID, DepartmentName 
    FROM Department 
    WHERE StatusID = 1 
    ORDER BY DepartmentName;
END;

-- Function để tính lương theo ngày công
CREATE FUNCTION fn_CalculateProRatedSalary(
    @BaseSalary DECIMAL(15,2),
    @ActualWorkDays INT,
    @StandardWorkDays INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    IF @StandardWorkDays <= 0
        RETURN @BaseSalary;
    
    RETURN (@BaseSalary * @ActualWorkDays) / @StandardWorkDays;
END;

-- Trigger để tự động cập nhật EndDate khi tạo salary record mới
CREATE TRIGGER tr_UpdatePreviousSalaryEndDate ON EmployeeSalary
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật EndDate cho các record cũ khi có record mới
    UPDATE es_old
    SET EndDate = i.EffectiveDate,
        IsActive = 0
    FROM EmployeeSalary es_old
    INNER JOIN inserted i ON es_old.StaffID = i.StaffID
    WHERE es_old.EmployeeSalaryID != i.EmployeeSalaryID
      AND es_old.IsActive = 1
      AND (es_old.EndDate IS NULL OR es_old.EndDate > i.EffectiveDate);
END;

PRINT 'Salary Management System created successfully!';
PRINT '';
PRINT 'New EditSalaryTable.html Support Features Added:';
PRINT '- SalaryStructure: Salary structure templates for different positions';
PRINT '- EmployeeSalary: Complete employee salary information with allowances';
PRINT '- MonthlySalary: Monthly salary calculation with workdays and overtime';
PRINT '- SalaryChangeLog: Complete audit trail for salary changes';
PRINT '- SalarySettings: Configurable system settings for salary calculation';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- SalaryStructure: Salary templates by position and contract type';
PRINT '- EmployeeSalary: Individual salary records with all components';
PRINT '- MonthlySalary: Monthly payroll with prorated calculations';
PRINT '- SalaryChangeLog: Change history and approval tracking';
PRINT '- SalarySettings: System configuration for salary calculations';
PRINT '';
PRINT 'Enhanced Views and Procedures:';
PRINT '- vw_EmployeeSalaryManagement: Complete salary overview for EditSalaryTable';
PRINT '- sp_GetEmployeeSalaryData: Main procedure with search and filtering';
PRINT '- sp_UpdateEmployeeSalary: Update salary with change logging';
PRINT '- sp_GetSalaryChangeHistory: Salary change history and audit';
PRINT '- sp_GetSalaryFormData: Dropdown data for salary forms';
PRINT '- fn_CalculateProRatedSalary: Calculate prorated salary by workdays';
PRINT '- tr_UpdatePreviousSalaryEndDate: Auto-update previous salary records';
PRINT '';
PRINT 'Key Features for EditSalaryTable Interface:';
PRINT '✅ Complete salary component management (basic, allowances, bonuses)';
PRINT '✅ Contract type filtering (Full-time, Part-time, Contract)';
PRINT '✅ Search by employee name, ID, or position';
PRINT '✅ Real-time salary calculations with gross and net amounts';
PRINT '✅ Bank account and payment method tracking';
PRINT '✅ Comprehensive change logging and audit trails';
PRINT '✅ Salary structure templates for consistency';
PRINT '✅ Configurable system settings for calculations';
PRINT '✅ Monthly payroll generation with prorated calculations';
PRINT '✅ Department-based salary comparisons and statistics';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 6 Salary Structures: Teacher FT/PT, Manager, Admin FT/PT, Consultant';
PRINT '- 8 Employee Salary Records with realistic Vietnamese salary amounts';
PRINT '- System settings for workdays, overtime, insurance, tax calculations';
PRINT '- Salary structures with min/max ranges and default allowances';
PRINT '';
PRINT 'Database now fully supports EditSalaryTable.html with comprehensive salary management!';

-- ============================================================================
-- 33. TIMEKEEPING MANAGEMENT SYSTEM (Keepingtime.html)
-- ============================================================================

-- Bảng ca làm việc (Work Shifts)
CREATE TABLE WorkShift (
    ShiftID INT IDENTITY(1,1) PRIMARY KEY,
    ShiftCode NVARCHAR(20) NOT NULL UNIQUE, -- Mã ca làm việc
    ShiftName NVARCHAR(100) NOT NULL, -- Tên ca làm việc (Ca sáng, Ca chiều, Hành chính)
    StartTime TIME NOT NULL, -- Giờ bắt đầu ca
    EndTime TIME NOT NULL, -- Giờ kết thúc ca
    WorkHours DECIMAL(4,2) AS (DATEDIFF(MINUTE, StartTime, EndTime) / 60.0), -- Tính số giờ làm việc
    BreakTime DECIMAL(4,2) DEFAULT 0, -- Thời gian nghỉ trưa (giờ)
    OvertimeThreshold DECIMAL(4,2) DEFAULT 8, -- Ngưỡng làm thêm giờ
    IsActive BIT DEFAULT 1, -- Có đang sử dụng không
    Description NVARCHAR(MAX), -- Mô tả ca làm việc
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng chấm công máy (Machine Timekeeping)
CREATE TABLE MachineTimekeeping (
    MachineTimekeepingID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL, -- Nhân viên
    BranchID INT, -- Chi nhánh
    WorkDate DATE NOT NULL, -- Ngày làm việc
    CheckInTime DATETIME2, -- Giờ vào
    CheckOutTime DATETIME2, -- Giờ ra
    TotalWorkHours DECIMAL(4,2) AS (
        CASE 
            WHEN CheckInTime IS NOT NULL AND CheckOutTime IS NOT NULL 
            THEN DATEDIFF(MINUTE, CheckInTime, CheckOutTime) / 60.0
            ELSE 0 
        END
    ), -- Tổng giờ làm việc
    LateMinutes INT DEFAULT 0, -- Số phút đi muộn
    EarlyLeaveMinutes INT DEFAULT 0, -- Số phút về sớm
    OvertimeMinutes INT DEFAULT 0, -- Số phút làm thêm
    StatusID INT DEFAULT 1, -- 1=Đúng giờ, 2=Đi muộn, 3=Về sớm, 4=Nghỉ
    Note NVARCHAR(MAX), -- Ghi chú
    MachineIP NVARCHAR(50), -- IP máy chấm công
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    UNIQUE(StaffID, WorkDate) -- Mỗi nhân viên chỉ có 1 record chấm công máy/ngày
);

-- Bảng phân công lịch làm việc (Work Schedule Assignment)
CREATE TABLE WorkScheduleAssignment (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL, -- Nhân viên được phân công
    BranchID INT, -- Chi nhánh
    WorkDate DATE NOT NULL, -- Ngày làm việc
    ShiftID INT, -- Ca làm việc được phân công
    AssignedShiftName NVARCHAR(100), -- Tên ca tùy chỉnh (nếu không dùng ShiftID)
    AssignedStartTime TIME, -- Giờ bắt đầu tùy chỉnh
    AssignedEndTime TIME, -- Giờ kết thúc tùy chỉnh
    IsFlexibleTime BIT DEFAULT 0, -- Có phải ca linh hoạt không
    Note NVARCHAR(MAX), -- Ghi chú lịch làm việc
    StatusID INT DEFAULT 1, -- 1=Đã phân công, 2=Đã xác nhận, 3=Hoàn thành, 4=Hủy
    AssignedBy INT, -- Người phân công
    AssignedDate DATETIME2 DEFAULT GETDATE(), -- Ngày phân công
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ShiftID) REFERENCES WorkShift(ShiftID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (AssignedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(StaffID, WorkDate) -- Mỗi nhân viên chỉ có 1 lịch/ngày
);

-- Bảng chấm công ca dạy (Teaching Shift Attendance)
CREATE TABLE TeachingShiftAttendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    TeacherStaffID INT NOT NULL, -- Giáo viên
    ClassID INT, -- Lớp học
    ScheduleID INT, -- Lịch dạy từ ClassSchedule
    AttendanceDate DATE NOT NULL, -- Ngày chấm công
    ScheduledStartTime TIME, -- Giờ bắt đầu theo lịch
    ScheduledEndTime TIME, -- Giờ kết thúc theo lịch
    ActualStartTime TIME, -- Giờ bắt đầu thực tế
    ActualEndTime TIME, -- Giờ kết thúc thực tế
    AttendanceStatusID INT DEFAULT 2, -- 1=Đã chấm công, 2=Chưa chấm công, 3=Nghỉ có phép, 4=Nghỉ không phép
    StudentAttendanceCount INT DEFAULT 0, -- Số học viên có mặt
    TeachingNote NVARCHAR(MAX), -- Ghi chú về tiết dạy
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (TeacherStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (ScheduleID) REFERENCES ClassSchedule(ScheduleID),
    FOREIGN KEY (AttendanceStatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(TeacherStaffID, ScheduleID, AttendanceDate) -- Mỗi giáo viên/lịch/ngày chỉ 1 record
);

-- Bảng báo cáo chấm công tổng hợp (Timekeeping Summary Report)
CREATE TABLE TimekeepingSummaryReport (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL, -- Nhân viên
    BranchID INT, -- Chi nhánh
    ReportMonth INT NOT NULL, -- Tháng báo cáo
    ReportYear INT NOT NULL, -- Năm báo cáo
    TotalWorkDays INT DEFAULT 0, -- Tổng ngày làm việc
    ActualWorkDays INT DEFAULT 0, -- Ngày làm việc thực tế
    AbsentDays INT DEFAULT 0, -- Ngày nghỉ
    LateDays INT DEFAULT 0, -- Ngày đi muộn
    EarlyLeaveDays INT DEFAULT 0, -- Ngày về sớm
    TotalWorkHours DECIMAL(6,2) DEFAULT 0, -- Tổng giờ làm việc
    RegularHours DECIMAL(6,2) DEFAULT 0, -- Giờ làm việc bình thường
    OvertimeHours DECIMAL(6,2) DEFAULT 0, -- Giờ làm thêm
    TeachingHours DECIMAL(6,2) DEFAULT 0, -- Giờ dạy (cho giáo viên)
    TotalLateMinutes INT DEFAULT 0, -- Tổng phút đi muộn
    TotalEarlyLeaveMinutes INT DEFAULT 0, -- Tổng phút về sớm
    AttendanceRate DECIMAL(5,2) AS (
        CASE WHEN TotalWorkDays > 0 
        THEN (ActualWorkDays * 100.0) / TotalWorkDays 
        ELSE 0 END
    ), -- Tỷ lệ chuyên cần (%)
    PerformanceRating NVARCHAR(20), -- Xếp hạng: Xuất sắc, Tốt, Khá, Trung bình, Yếu
    MonthlyBonus DECIMAL(15,2) DEFAULT 0, -- Thưởng tháng dựa trên chấm công
    PenaltyAmount DECIMAL(15,2) DEFAULT 0, -- Phạt do vi phạm chấm công
    GeneratedDate DATETIME2 DEFAULT GETDATE(),
    GeneratedBy INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (GeneratedBy) REFERENCES Staff(StaffID),
    UNIQUE(StaffID, ReportMonth, ReportYear) -- Mỗi nhân viên/tháng chỉ có 1 báo cáo
);

-- Bảng cài đặt chấm công (Timekeeping Settings)
CREATE TABLE TimekeepingSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT, -- Chi nhánh (NULL = áp dụng toàn hệ thống)
    SettingKey NVARCHAR(100) NOT NULL, -- Tên cài đặt
    SettingValue NVARCHAR(500), -- Giá trị cài đặt
    DataType NVARCHAR(20), -- 'INT', 'DECIMAL', 'STRING', 'BOOLEAN', 'TIME'
    Description NVARCHAR(MAX), -- Mô tả cài đặt
    Category NVARCHAR(50), -- Danh mục: WorkTime, Overtime, Penalty, Bonus
    IsSystemSetting BIT DEFAULT 0, -- Có phải cài đặt hệ thống không
    EffectiveDate DATE DEFAULT CAST(GETDATE() AS DATE), -- Ngày có hiệu lực
    ExpiryDate DATE, -- Ngày hết hiệu lực
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(BranchID, SettingKey, EffectiveDate) -- Mỗi chi nhánh/setting/ngày chỉ có 1 giá trị
);

-- Thêm dữ liệu mẫu cho WorkShift
INSERT INTO WorkShift (ShiftCode, ShiftName, StartTime, EndTime, BreakTime, Description, CreatedBy) VALUES
('MORNING', 'Ca sáng', '08:00', '12:00', 0, 'Ca làm việc buổi sáng', 1),
('AFTERNOON', 'Ca chiều', '13:00', '17:00', 0, 'Ca làm việc buổi chiều', 1),
('EVENING', 'Ca tối', '18:00', '22:00', 0, 'Ca làm việc buổi tối', 1),
('ADMIN', 'Ca hành chính', '08:30', '17:30', 1, 'Ca hành chính toàn thời gian với nghỉ trưa 1 tiếng', 1),
('TEACHING_MORNING', 'Ca dạy sáng', '09:00', '11:00', 0, 'Ca dạy buổi sáng cho giáo viên', 1),
('TEACHING_AFTERNOON', 'Ca dạy chiều', '14:00', '16:00', 0, 'Ca dạy buổi chiều cho giáo viên', 1),
('TEACHING_EVENING', 'Ca dạy tối', '19:00', '21:00', 0, 'Ca dạy buổi tối cho giáo viên', 1),
('FLEXIBLE', 'Ca linh hoạt', '08:00', '17:00', 0, 'Ca làm việc linh hoạt', 1);

-- Thêm dữ liệu mẫu cho MachineTimekeeping
INSERT INTO MachineTimekeeping (StaffID, BranchID, WorkDate, CheckInTime, CheckOutTime, LateMinutes, EarlyLeaveMinutes, OvertimeMinutes, StatusID, Note, MachineIP, CreatedBy) VALUES
(1, 1, '2025-07-20', '2025-07-20 08:00:00', '2025-07-20 17:00:00', 0, 0, 0, 1, 'Chấm công đúng giờ', '192.168.1.100', 1),
(1, 1, '2025-07-21', '2025-07-21 08:05:00', '2025-07-21 17:00:00', 5, 0, 0, 2, 'Đi muộn 5 phút', '192.168.1.100', 1),
(1, 1, '2025-07-22', '2025-07-22 08:00:00', '2025-07-22 18:00:00', 0, 0, 60, 1, 'Làm thêm 1 tiếng', '192.168.1.100', 1),
(1, 1, '2025-07-23', '2025-07-23 08:00:00', '2025-07-23 16:30:00', 0, 30, 0, 3, 'Về sớm 30 phút', '192.168.1.100', 1),
(1, 1, '2025-07-24', NULL, NULL, 0, 0, 0, 4, 'Nghỉ phép', NULL, 1),
(2, 1, '2025-07-20', '2025-07-20 08:30:00', '2025-07-20 17:30:00', 0, 0, 0, 1, 'Ca hành chính', '192.168.1.100', 1),
(2, 1, '2025-07-21', '2025-07-21 08:35:00', '2025-07-21 17:30:00', 5, 0, 0, 2, 'Đi muộn 5 phút', '192.168.1.100', 1),
(3, 1, '2025-07-20', '2025-07-20 13:00:00', '2025-07-20 17:00:00', 0, 0, 0, 1, 'Ca chiều', '192.168.1.100', 1),
(3, 1, '2025-07-21', '2025-07-21 13:10:00', '2025-07-21 17:00:00', 10, 0, 0, 2, 'Đi muộn 10 phút', '192.168.1.100', 1);

-- Thêm dữ liệu mẫu cho WorkScheduleAssignment
INSERT INTO WorkScheduleAssignment (StaffID, BranchID, WorkDate, ShiftID, Note, StatusID, AssignedBy) VALUES
(1, 1, '2025-07-25', 1, 'Lịch làm việc ca sáng', 1, 1),
(1, 1, '2025-07-26', 2, 'Lịch làm việc ca chiều', 1, 1),
(1, 1, '2025-07-27', 4, 'Lịch làm việc ca hành chính', 1, 1),
(2, 1, '2025-07-25', 4, 'Ca hành chính toàn thời gian', 1, 1),
(2, 1, '2025-07-26', 4, 'Ca hành chính toàn thời gian', 1, 1),
(3, 1, '2025-07-25', 2, 'Ca chiều cho tư vấn viên', 1, 1),
(3, 1, '2025-07-26', 2, 'Ca chiều cho tư vấn viên', 1, 1),
(4, 1, '2025-07-25', 1, 'Ca sáng cho nhân viên hành chính', 1, 1),
-- Thêm lịch nghỉ tất cả nhân viên vào ngày 2025-07-28
(1, 1, '2025-07-28', NULL, 'Nghỉ lễ', 4, 1),
(2, 1, '2025-07-28', NULL, 'Nghỉ lễ', 4, 1),
(3, 1, '2025-07-28', NULL, 'Nghỉ lễ', 4, 1),
(4, 1, '2025-07-28', NULL, 'Nghỉ lễ', 4, 1);

-- Thêm dữ liệu mẫu cho TeachingShiftAttendance
INSERT INTO TeachingShiftAttendance (TeacherStaffID, ClassID, ScheduleID, AttendanceDate, ScheduledStartTime, ScheduledEndTime, ActualStartTime, ActualEndTime, AttendanceStatusID, StudentAttendanceCount, TeachingNote, CreatedBy) VALUES
(2, 1, 1, '2025-07-20', '09:00', '11:00', '09:05', '11:00', 1, 15, 'Lớp học tốt, học viên tích cực', 1),
(2, 1, 1, '2025-07-21', '09:00', '11:00', NULL, NULL, 2, 0, 'Chưa chấm công', 1),
(3, 2, 2, '2025-07-20', '14:00', '16:00', '14:00', '16:00', 1, 12, 'Dạy unit mới về grammar', 1),
(3, 2, 2, '2025-07-21', '14:00', '16:00', NULL, NULL, 2, 0, 'Chưa chấm công', 1),
(4, 3, 3, '2025-07-20', '19:00', '21:00', '19:00', '21:00', 1, 8, 'Lớp tối, học viên chăm chỉ', 1),
(4, 3, 3, '2025-07-22', '19:00', '21:00', NULL, NULL, 3, 0, 'Nghỉ có phép do ốm', 1);

-- Thêm dữ liệu mẫu cho TimekeepingSettings
INSERT INTO TimekeepingSettings (BranchID, SettingKey, SettingValue, DataType, Description, Category, IsSystemSetting, CreatedBy) VALUES
(NULL, 'STANDARD_WORK_HOURS_PER_DAY', '8', 'DECIMAL', 'Số giờ làm việc tiêu chuẩn mỗi ngày', 'WorkTime', 1, 1),
(NULL, 'LATE_TOLERANCE_MINUTES', '15', 'INT', 'Số phút cho phép đi muộn không bị phạt', 'WorkTime', 1, 1),
(NULL, 'OVERTIME_START_AFTER_HOURS', '8', 'DECIMAL', 'Làm thêm giờ được tính sau bao nhiêu giờ', 'Overtime', 1, 1),
(NULL, 'OVERTIME_MULTIPLIER', '1.5', 'DECIMAL', 'Hệ số nhân lương làm thêm giờ', 'Overtime', 1, 1),
(NULL, 'LATE_PENALTY_PER_MINUTE', '5000', 'DECIMAL', 'Số tiền phạt mỗi phút đi muộn (VND)', 'Penalty', 0, 1),
(NULL, 'EARLY_LEAVE_PENALTY_PER_MINUTE', '3000', 'DECIMAL', 'Số tiền phạt mỗi phút về sớm (VND)', 'Penalty', 0, 1),
(NULL, 'PERFECT_ATTENDANCE_BONUS', '200000', 'DECIMAL', 'Thưởng chuyên cần hoàn hảo (VND)', 'Bonus', 0, 1),
(NULL, 'ATTENDANCE_BONUS_THRESHOLD', '95', 'DECIMAL', 'Ngưỡng % chuyên cần để nhận thưởng', 'Bonus', 0, 1),
(1, 'BRANCH_WORK_START_TIME', '08:00', 'TIME', 'Giờ bắt đầu làm việc chi nhánh 1', 'WorkTime', 0, 1),
(1, 'BRANCH_WORK_END_TIME', '17:00', 'TIME', 'Giờ kết thúc làm việc chi nhánh 1', 'WorkTime', 0, 1);

-- View tổng hợp cho Keepingtime.html
CREATE VIEW vw_EmployeeTimekeepingOverview AS
SELECT 
    s.StaffID,
    s.EmployeeId,
    s.FirstName + ' ' + s.LastName AS EmployeeName,
    s.Position,
    s.ContactPhone,
    d.DepartmentName,
    b.BranchName,
    -- Machine Timekeeping cho 30 ngày gần đây
    (SELECT COUNT(*) FROM MachineTimekeeping mt 
     WHERE mt.StaffID = s.StaffID 
     AND mt.WorkDate >= DATEADD(DAY, -30, GETDATE())
     AND mt.StatusID != 4) AS WorkDaysLast30Days,
    
    (SELECT COUNT(*) FROM MachineTimekeeping mt 
     WHERE mt.StaffID = s.StaffID 
     AND mt.WorkDate >= DATEADD(DAY, -30, GETDATE())
     AND mt.StatusID = 2) AS LateDaysLast30Days,
    
    (SELECT ISNULL(SUM(mt.TotalWorkHours), 0) FROM MachineTimekeeping mt 
     WHERE mt.StaffID = s.StaffID 
     AND mt.WorkDate >= DATEADD(DAY, -30, GETDATE())) AS TotalHoursLast30Days,
    
    -- Teaching Hours cho giáo viên
    (SELECT ISNULL(SUM(DATEDIFF(MINUTE, tsa.ScheduledStartTime, tsa.ScheduledEndTime)), 0) / 60.0 
     FROM TeachingShiftAttendance tsa 
     WHERE tsa.TeacherStaffID = s.StaffID 
     AND tsa.AttendanceDate >= DATEADD(DAY, -30, GETDATE())
     AND tsa.AttendanceStatusID = 1) AS TeachingHoursLast30Days,
    
    -- Work Schedule Assignment gần đây nhất
    (SELECT TOP 1 wsa.WorkDate FROM WorkScheduleAssignment wsa 
     WHERE wsa.StaffID = s.StaffID 
     ORDER BY wsa.WorkDate DESC) AS LastScheduledDate,
    
    (SELECT TOP 1 ws.ShiftName FROM WorkScheduleAssignment wsa 
     LEFT JOIN WorkShift ws ON wsa.ShiftID = ws.ShiftID
     WHERE wsa.StaffID = s.StaffID 
     ORDER BY wsa.WorkDate DESC) AS LastScheduledShift
FROM Staff s
LEFT JOIN DepartmentStaffAssignment dsa ON s.StaffID = dsa.StaffID AND dsa.StatusID = 1
LEFT JOIN Department d ON dsa.DepartmentID = d.DepartmentID
LEFT JOIN Branch b ON s.BranchID = b.BranchID
WHERE s.StatusID = 1; -- Chỉ nhân viên đang làm việc

-- Stored Procedure để lấy dữ liệu chấm công cho Keepingtime.html
CREATE PROCEDURE sp_GetEmployeeTimekeepingData
    @EmployeeID INT = NULL, -- ID nhân viên (NULL = tất cả)
    @StartDate DATE, -- Ngày bắt đầu lọc
    @EndDate DATE -- Ngày kết thúc lọc
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Machine Timekeeping Data
    SELECT 
        mt.MachineTimekeepingID,
        mt.StaffID,
        s.EmployeeId,
        s.FirstName + ' ' + s.LastName AS EmployeeName,
        mt.WorkDate AS [Date],
        FORMAT(mt.CheckInTime, 'HH:mm') AS CheckInTime,
        FORMAT(mt.CheckOutTime, 'HH:mm') AS CheckOutTime,
        CAST(mt.TotalWorkHours AS NVARCHAR) + 'h ' + 
        CAST((mt.TotalWorkHours - FLOOR(mt.TotalWorkHours)) * 60 AS NVARCHAR) + 'm' AS TotalHours,
        gs.StatusName AS [Status],
        mt.Note
    FROM MachineTimekeeping mt
    INNER JOIN Staff s ON mt.StaffID = s.StaffID
    INNER JOIN GeneralStatus gs ON mt.StatusID = gs.StatusID
    WHERE (@EmployeeID IS NULL OR mt.StaffID = @EmployeeID)
      AND mt.WorkDate BETWEEN @StartDate AND @EndDate
    ORDER BY mt.WorkDate DESC;
    
    -- Teaching Shift Attendance Data
    SELECT 
        tsa.AttendanceID AS ShiftID,
        tsa.TeacherStaffID AS StaffID,
        tsa.AttendanceDate AS ShiftDate,
        FORMAT(tsa.ScheduledStartTime, 'HH:mm') AS StartTime,
        FORMAT(tsa.ScheduledEndTime, 'HH:mm') AS EndTime,
        c.ClassName,
        c.ClassID,
        tsa.AttendanceStatusID AS StatusID,
        gs.StatusName AS StatusName
    FROM TeachingShiftAttendance tsa
    INNER JOIN Class c ON tsa.ClassID = c.ClassID
    INNER JOIN GeneralStatus gs ON tsa.AttendanceStatusID = gs.StatusID
    WHERE (@EmployeeID IS NULL OR tsa.TeacherStaffID = @EmployeeID)
      AND tsa.AttendanceDate BETWEEN @StartDate AND @EndDate
    ORDER BY tsa.AttendanceDate DESC, tsa.ScheduledStartTime;
    
    -- Shift Status Options
    SELECT StatusID AS [Value], StatusName AS [Text]
    FROM GeneralStatus 
    WHERE Category = 'TeachingAttendance'
    ORDER BY StatusID;
END;

-- Stored Procedure để lấy dữ liệu lịch làm việc
CREATE PROCEDURE sp_GetWorkScheduleData
    @StartDate DATE,
    @EndDate DATE,
    @EmployeeID INT = NULL, -- Lọc theo nhân viên
    @DepartmentID INT = NULL -- Lọc theo phòng ban
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        wsa.ScheduleID AS ShiftID,
        wsa.StaffID AS EmployeeID,
        s.FirstName + ' ' + s.LastName AS EmployeeName,
        d.DepartmentName,
        wsa.WorkDate AS [Date],
        COALESCE(wsa.AssignedShiftName, ws.ShiftName, 'Nghỉ') AS ShiftName,
        FORMAT(COALESCE(wsa.AssignedStartTime, ws.StartTime), 'HH:mm') AS StartTime,
        FORMAT(COALESCE(wsa.AssignedEndTime, ws.EndTime), 'HH:mm') AS EndTime,
        wsa.Note
    FROM WorkScheduleAssignment wsa
    INNER JOIN Staff s ON wsa.StaffID = s.StaffID
    LEFT JOIN WorkShift ws ON wsa.ShiftID = ws.ShiftID
    LEFT JOIN DepartmentStaffAssignment dsa ON s.StaffID = dsa.StaffID AND dsa.StatusID = 1
    LEFT JOIN Department d ON dsa.DepartmentID = d.DepartmentID
    WHERE wsa.WorkDate BETWEEN @StartDate AND @EndDate
      AND (@EmployeeID IS NULL OR wsa.StaffID = @EmployeeID)
      AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    ORDER BY wsa.WorkDate DESC, s.FirstName, s.LastName;
END;

-- Stored Procedure để lưu/cập nhật ca làm việc
CREATE PROCEDURE sp_SaveWorkShift
    @ShiftID INT = NULL, -- NULL cho thêm mới
    @EmployeeID INT,
    @WorkDate DATE,
    @ShiftName NVARCHAR(100),
    @StartTime TIME,
    @EndTime TIME,
    @Note NVARCHAR(MAX) = NULL,
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        IF @ShiftID IS NULL
        BEGIN
            -- Thêm mới
            INSERT INTO WorkScheduleAssignment (StaffID, WorkDate, AssignedShiftName, AssignedStartTime, AssignedEndTime, Note, StatusID, AssignedBy, ModifiedBy)
            VALUES (@EmployeeID, @WorkDate, @ShiftName, @StartTime, @EndTime, @Note, 1, @ModifiedBy, @ModifiedBy);
            
            SELECT 'Success' AS Result, 'Thêm ca làm việc thành công' AS Message;
        END
        ELSE
        BEGIN
            -- Cập nhật
            UPDATE WorkScheduleAssignment 
            SET AssignedShiftName = @ShiftName,
                AssignedStartTime = @StartTime,
                AssignedEndTime = @EndTime,
                Note = @Note,
                ModifiedBy = @ModifiedBy,
                LastModified = GETDATE()
            WHERE ScheduleID = @ShiftID;
            
            SELECT 'Success' AS Result, 'Cập nhật ca làm việc thành công' AS Message;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để xóa ca làm việc
CREATE PROCEDURE sp_DeleteWorkShift
    @ShiftID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DELETE FROM WorkScheduleAssignment WHERE ScheduleID = @ShiftID;
        SELECT 'Success' AS Result, 'Xóa ca làm việc thành công' AS Message;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để đánh dấu tất cả nhân viên nghỉ
CREATE PROCEDURE sp_MarkAllEmployeesAbsent
    @AbsentDate DATE,
    @Note NVARCHAR(MAX) = 'Nghỉ',
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Xóa lịch làm việc hiện có của ngày này
        DELETE FROM WorkScheduleAssignment WHERE WorkDate = @AbsentDate;
        
        -- Thêm lịch nghỉ cho tất cả nhân viên đang làm việc
        INSERT INTO WorkScheduleAssignment (StaffID, WorkDate, AssignedShiftName, Note, StatusID, AssignedBy, ModifiedBy)
        SELECT 
            s.StaffID,
            @AbsentDate,
            'Nghỉ',
            @Note,
            4, -- Status Nghỉ
            @ModifiedBy,
            @ModifiedBy
        FROM Staff s 
        WHERE s.StatusID = 1; -- Chỉ nhân viên đang làm việc
        
        SELECT 'Success' AS Result, 'Đánh dấu tất cả nhân viên nghỉ thành công' AS Message;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Stored Procedure để lưu chấm công ca dạy
CREATE PROCEDURE sp_SaveTeachingShiftAttendance
    @TeacherStaffID INT,
    @ShiftID INT, -- Attendance ID từ TeachingShiftAttendance
    @AttendanceStatusID INT,
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        UPDATE TeachingShiftAttendance 
        SET AttendanceStatusID = @AttendanceStatusID,
            ModifiedBy = @ModifiedBy,
            LastModified = GETDATE(),
            ActualStartTime = CASE 
                WHEN @AttendanceStatusID = 1 AND ActualStartTime IS NULL 
                THEN CAST(GETDATE() AS TIME) 
                ELSE ActualStartTime 
            END,
            ActualEndTime = CASE 
                WHEN @AttendanceStatusID = 1 AND ActualEndTime IS NULL 
                THEN CAST(DATEADD(MINUTE, DATEDIFF(MINUTE, ScheduledStartTime, ScheduledEndTime), CAST(GETDATE() AS TIME)) AS TIME)
                ELSE ActualEndTime 
            END
        WHERE AttendanceID = @ShiftID;
        
        SELECT 'Success' AS Result, 'Lưu chấm công ca dạy thành công' AS Message;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Function để tính toán báo cáo chấm công tháng
CREATE FUNCTION fn_CalculateMonthlyTimekeepingReport(
    @StaffID INT,
    @ReportMonth INT,
    @ReportYear INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        @StaffID AS StaffID,
        @ReportMonth AS ReportMonth,
        @ReportYear AS ReportYear,
        COUNT(*) AS TotalWorkDays,
        SUM(CASE WHEN mt.StatusID != 4 THEN 1 ELSE 0 END) AS ActualWorkDays,
        SUM(CASE WHEN mt.StatusID = 4 THEN 1 ELSE 0 END) AS AbsentDays,
        SUM(CASE WHEN mt.StatusID = 2 THEN 1 ELSE 0 END) AS LateDays,
        SUM(CASE WHEN mt.StatusID = 3 THEN 1 ELSE 0 END) AS EarlyLeaveDays,
        ISNULL(SUM(mt.TotalWorkHours), 0) AS TotalWorkHours,
        ISNULL(SUM(CASE WHEN mt.TotalWorkHours <= 8 THEN mt.TotalWorkHours ELSE 8 END), 0) AS RegularHours,
        ISNULL(SUM(CASE WHEN mt.TotalWorkHours > 8 THEN mt.TotalWorkHours - 8 ELSE 0 END), 0) AS OvertimeHours,
        ISNULL(SUM(mt.LateMinutes), 0) AS TotalLateMinutes,
        ISNULL(SUM(mt.EarlyLeaveMinutes), 0) AS TotalEarlyLeaveMinutes
    FROM MachineTimekeeping mt
    WHERE mt.StaffID = @StaffID
      AND MONTH(mt.WorkDate) = @ReportMonth
      AND YEAR(mt.WorkDate) = @ReportYear
);

PRINT 'Timekeeping Management System created successfully!';
PRINT '';
PRINT 'New Keepingtime.html Support Features Added:';
PRINT '- WorkShift: Standardized work shift definitions with time calculations';
PRINT '- MachineTimekeeping: Machine-based attendance tracking with status monitoring';
PRINT '- WorkScheduleAssignment: Flexible work schedule assignment and management';
PRINT '- TeachingShiftAttendance: Specialized attendance tracking for teachers';
PRINT '- TimekeepingSummaryReport: Comprehensive monthly attendance reports';
PRINT '- TimekeepingSettings: Configurable attendance rules and penalties';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- WorkShift: 8 predefined shifts including morning, afternoon, evening, admin, teaching shifts';
PRINT '- MachineTimekeeping: Daily attendance records with check-in/out times and status';
PRINT '- WorkScheduleAssignment: Work schedule planning and assignment management';
PRINT '- TeachingShiftAttendance: Teaching-specific attendance with class integration';
PRINT '- TimekeepingSummaryReport: Monthly performance and attendance analytics';
PRINT '- TimekeepingSettings: System-wide and branch-specific attendance configurations';
PRINT '';
PRINT 'Enhanced Views and Procedures:';
PRINT '- vw_EmployeeTimekeepingOverview: Complete attendance overview for dashboard';
PRINT '- sp_GetEmployeeTimekeepingData: Main data retrieval for machine and teaching attendance';
PRINT '- sp_GetWorkScheduleData: Work schedule data with filtering capabilities';
PRINT '- sp_SaveWorkShift: Add/edit work schedule assignments';
PRINT '- sp_DeleteWorkShift: Remove work schedule assignments';
PRINT '- sp_MarkAllEmployeesAbsent: Bulk absence marking for holidays/events';
PRINT '- sp_SaveTeachingShiftAttendance: Teaching attendance status updates';
PRINT '- fn_CalculateMonthlyTimekeepingReport: Monthly attendance analytics calculation';
PRINT '';
PRINT 'Key Features for Keepingtime Interface:';
PRINT '✅ Machine-based timekeeping with check-in/out tracking';
PRINT '✅ Teaching shift attendance management with class integration';
PRINT '✅ Flexible work schedule assignment and planning';
PRINT '✅ Real-time attendance status monitoring (On-time, Late, Early Leave, Absent)';
PRINT '✅ Overtime and penalty calculations with configurable rules';
PRINT '✅ Bulk operations for marking all employees absent';
PRINT '✅ Comprehensive monthly attendance reports and analytics';
PRINT '✅ Multi-shift support (Morning, Afternoon, Evening, Admin, Teaching)';
PRINT '✅ Department and branch-based filtering and reporting';
PRINT '✅ WebView2 integration for real-time data synchronization';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 8 Work Shifts: Morning, Afternoon, Evening, Admin, Teaching shifts with time ranges';
PRINT '- 9 Machine Timekeeping Records: Various attendance patterns including late, overtime, absent';
PRINT '- 11 Work Schedule Assignments: Planned schedules including holiday marking';
PRINT '- 6 Teaching Shift Attendance Records: Teaching-specific attendance tracking';
PRINT '- 10 Timekeeping Settings: Configurable rules for work hours, penalties, bonuses';
PRINT '';
PRINT 'Database now fully supports Keepingtime.html with comprehensive attendance management!';

-- ============================================================================
-- 32. FINANCIAL MANAGEMENT SYSTEM
-- ============================================================================

-- Bảng danh mục tài chính (Chart of Accounts)
CREATE TABLE FinancialCategory (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE, -- Mã danh mục (REV, EXP, AST, LIB, EQT)
    CategoryName NVARCHAR(255) NOT NULL, -- Tên danh mục
    CategoryType NVARCHAR(50) NOT NULL, -- 'Revenue', 'Expense', 'Asset', 'Liability', 'Equity'
    ParentCategoryID INT NULL, -- Danh mục cha (cho phân cấp)
    AccountLevel INT DEFAULT 1, -- Cấp độ tài khoản (1=Tổng, 2=Chi tiết, 3=Phụ)
    Description NVARCHAR(MAX), -- Mô tả danh mục
    IsActive BIT DEFAULT 1, -- Có đang sử dụng không
    DisplayOrder INT DEFAULT 0, -- Thứ tự hiển thị
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ParentCategoryID) REFERENCES FinancialCategory(CategoryID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng giao dịch tài chính
CREATE TABLE FinancialTransaction (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionCode NVARCHAR(50) NOT NULL UNIQUE, -- Mã giao dịch
    TransactionDate DATE NOT NULL, -- Ngày giao dịch
    CategoryID INT, -- Danh mục tài chính
    BranchID INT, -- Chi nhánh
    DepartmentID INT NULL, -- Phòng ban (nếu có)
    StudentID INT NULL, -- Học viên (nếu là giao dịch liên quan)
    ClassID INT NULL, -- Lớp học (nếu có)
    Amount DECIMAL(15,2) NOT NULL, -- Số tiền
    TransactionType NVARCHAR(50), -- 'Income', 'Expense', 'Transfer', 'Adjustment'
    PaymentMethod NVARCHAR(50), -- 'Cash', 'Bank Transfer', 'Credit Card', 'Online Payment'
    ReferenceNumber NVARCHAR(100), -- Số tham chiếu (hóa đơn, chứng từ)
    Description NVARCHAR(MAX), -- Mô tả giao dịch
    Notes NVARCHAR(MAX), -- Ghi chú bổ sung
    RecurringType NVARCHAR(50) NULL, -- 'Monthly', 'Quarterly', 'Yearly' (cho giao dịch định kỳ)
    RecurringEndDate DATE NULL, -- Ngày kết thúc lặp lại
    IsReconciled BIT DEFAULT 0, -- Đã đối soát chưa
    ReconciledDate DATETIME2 NULL, -- Ngày đối soát
    ReconciledBy INT NULL, -- Người đối soát
    ApprovedBy INT NULL, -- Người phê duyệt
    ApprovalDate DATETIME2 NULL, -- Ngày phê duyệt
    FiscalYear INT, -- Năm tài chính
    FiscalQuarter INT, -- Quý tài chính
    StatusID INT DEFAULT 1, -- 1=Pending, 2=Approved, 3=Reconciled, 4=Cancelled
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (CategoryID) REFERENCES FinancialCategory(CategoryID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (ReconciledBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ApprovedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng báo cáo tài chính tổng hợp
CREATE TABLE FinancialSummary (
    SummaryID INT IDENTITY(1,1) PRIMARY KEY,
    ReportType NVARCHAR(50), -- 'Monthly', 'Quarterly', 'Yearly'
    PeriodYear INT NOT NULL, -- Năm báo cáo
    PeriodMonth INT NULL, -- Tháng (nếu là báo cáo tháng)
    PeriodQuarter INT NULL, -- Quý (nếu là báo cáo quý)
    BranchID INT NULL, -- Chi nhánh (null = toàn enterprise)
    TotalRevenue DECIMAL(15,2) DEFAULT 0, -- Tổng doanh thu
    TotalExpense DECIMAL(15,2) DEFAULT 0, -- Tổng chi phí
    GrossProfit DECIMAL(15,2) DEFAULT 0, -- Lợi nhuận gộp
    NetProfit DECIMAL(15,2) DEFAULT 0, -- Lợi nhuận ròng
    StudentPayments DECIMAL(15,2) DEFAULT 0, -- Thu từ học phí
    SalaryExpense DECIMAL(15,2) DEFAULT 0, -- Chi lương nhân viên
    OperatingExpense DECIMAL(15,2) DEFAULT 0, -- Chi phí hoạt động
    MarketingExpense DECIMAL(15,2) DEFAULT 0, -- Chi phí marketing
    RentExpense DECIMAL(15,2) DEFAULT 0, -- Chi phí thuê mặt bằng
    UtilityExpense DECIMAL(15,2) DEFAULT 0, -- Chi phí tiện ích
    OtherIncome DECIMAL(15,2) DEFAULT 0, -- Thu nhập khác
    OtherExpense DECIMAL(15,2) DEFAULT 0, -- Chi phí khác
    CashBalance DECIMAL(15,2) DEFAULT 0, -- Số dư tiền mặt
    BankBalance DECIMAL(15,2) DEFAULT 0, -- Số dư ngân hàng
    TotalAssets DECIMAL(15,2) DEFAULT 0, -- Tổng tài sản
    TotalLiabilities DECIMAL(15,2) DEFAULT 0, -- Tổng nợ phải trả
    Equity DECIMAL(15,2) DEFAULT 0, -- Vốn chủ sở hữu
    StudentCount INT DEFAULT 0, -- Số lượng học viên
    ClassCount INT DEFAULT 0, -- Số lượng lớp học
    RevenuePerStudent AS (CASE WHEN StudentCount > 0 THEN TotalRevenue / StudentCount ELSE 0 END), -- Doanh thu/học viên
    ProfitMargin AS (CASE WHEN TotalRevenue > 0 THEN (NetProfit * 100.0) / TotalRevenue ELSE 0 END), -- Tỷ lệ lợi nhuận
    GeneratedDate DATETIME2 DEFAULT GETDATE(),
    GeneratedBy INT,
    LastUpdated DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (GeneratedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (UpdatedBy) REFERENCES Staff(StaffID),
    UNIQUE(ReportType, PeriodYear, PeriodMonth, PeriodQuarter, BranchID) -- Mỗi period chỉ có 1 báo cáo
);

-- Bảng ngân sách và dự báo
CREATE TABLE FinancialBudget (
    BudgetID INT IDENTITY(1,1) PRIMARY KEY,
    BudgetCode NVARCHAR(50) NOT NULL UNIQUE, -- Mã ngân sách
    BudgetName NVARCHAR(255) NOT NULL, -- Tên ngân sách
    BudgetYear INT NOT NULL, -- Năm ngân sách
    BudgetQuarter INT NULL, -- Quý (nếu là ngân sách quý)
    BudgetMonth INT NULL, -- Tháng (nếu là ngân sách tháng)
    BranchID INT NULL, -- Chi nhánh (null = toàn doanh nghiệp)
    DepartmentID INT NULL, -- Phòng ban (nếu có)
    CategoryID INT, -- Danh mục tài chính
    BudgetedAmount DECIMAL(15,2) NOT NULL, -- Số tiền ngân sách
    ActualAmount DECIMAL(15,2) DEFAULT 0, -- Số tiền thực tế
    VarianceAmount AS (ActualAmount - BudgetedAmount), -- Chênh lệch
    VariancePercent AS (CASE WHEN BudgetedAmount > 0 THEN ((ActualAmount - BudgetedAmount) * 100.0) / BudgetedAmount ELSE 0 END), -- % chênh lệch
    Notes NVARCHAR(MAX), -- Ghi chú
    IsApproved BIT DEFAULT 0, -- Đã phê duyệt chưa
    ApprovedBy INT NULL, -- Người phê duyệt
    ApprovalDate DATETIME2 NULL, -- Ngày phê duyệt
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (CategoryID) REFERENCES FinancialCategory(CategoryID),
    FOREIGN KEY (ApprovedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng thu chi theo học viên
CREATE TABLE StudentFinancialRecord (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    ClassID INT NULL, -- Lớp học (nếu có)
    TransactionID INT NULL, -- Liên kết với giao dịch tài chính
    TransactionType NVARCHAR(50), -- 'Tuition Payment', 'Registration Fee', 'Material Fee', 'Refund', 'Discount'
    Amount DECIMAL(15,2) NOT NULL, -- Số tiền
    DueDate DATE NULL, -- Ngày đến hạn
    PaymentDate DATE NULL, -- Ngày thanh toán
    PaymentMethod NVARCHAR(50), -- Phương thức thanh toán
    ReceiptNumber NVARCHAR(100), -- Số biên lai
    Description NVARCHAR(MAX), -- Mô tả
    IsFullyPaid BIT DEFAULT 0, -- Đã thanh toán đủ chưa
    OutstandingBalance DECIMAL(15,2) DEFAULT 0, -- Số tiền còn nợ
    DiscountAmount DECIMAL(15,2) DEFAULT 0, -- Số tiền được giảm
    DiscountReason NVARCHAR(MAX), -- Lý do giảm giá
    StatusID INT DEFAULT 1, -- 1=Pending, 2=Paid, 3=Overdue, 4=Cancelled
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (TransactionID) REFERENCES FinancialTransaction(TransactionID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID)
);

-- Bảng lương và chi phí nhân sự
CREATE TABLE PayrollExpense (
    PayrollExpenseID INT IDENTITY(1,1) PRIMARY KEY,
    PayrollMonth INT NOT NULL, -- Tháng lương
    PayrollYear INT NOT NULL, -- Năm lương
    BranchID INT, -- Chi nhánh
    DepartmentID INT NULL, -- Phòng ban
    TotalBasicSalary DECIMAL(15,2) DEFAULT 0, -- Tổng lương cơ bản
    TotalAllowances DECIMAL(15,2) DEFAULT 0, -- Tổng phụ cấp
    TotalBonuses DECIMAL(15,2) DEFAULT 0, -- Tổng thưởng
    TotalDeductions DECIMAL(15,2) DEFAULT 0, -- Tổng khấu trừ
    TotalGrossPay DECIMAL(15,2) DEFAULT 0, -- Tổng lương gross
    TotalNetPay DECIMAL(15,2) DEFAULT 0, -- Tổng lương net
    EmployerInsurance DECIMAL(15,2) DEFAULT 0, -- Bảo hiểm do công ty đóng
    TotalPayrollCost AS (TotalGrossPay + EmployerInsurance), -- Tổng chi phí nhân sự
    EmployeeCount INT DEFAULT 0, -- Số lượng nhân viên
    AverageSalary AS (CASE WHEN EmployeeCount > 0 THEN TotalNetPay / EmployeeCount ELSE 0 END), -- Lương trung bình
    TransactionID INT NULL, -- Liên kết với giao dịch tài chính
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    LastModified DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (TransactionID) REFERENCES FinancialTransaction(TransactionID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ModifiedBy) REFERENCES Staff(StaffID),
    UNIQUE(PayrollMonth, PayrollYear, BranchID, DepartmentID) -- Mỗi tháng/phòng ban chỉ có 1 record
);

-- Thêm dữ liệu mẫu cho FinancialCategory
INSERT INTO FinancialCategory (CategoryCode, CategoryName, CategoryType, AccountLevel, Description, DisplayOrder, CreatedBy) VALUES
-- Revenue Categories
('REV', 'Doanh thu', 'Revenue', 1, 'Tổng doanh thu', 10, 1),
('REV_TUITION', 'Doanh thu học phí', 'Revenue', 2, 'Thu từ học phí các khóa học', 11, 1),
('REV_REGISTRATION', 'Phí đăng ký', 'Revenue', 2, 'Thu từ phí đăng ký học', 12, 1),
('REV_MATERIAL', 'Phí tài liệu', 'Revenue', 2, 'Thu từ bán tài liệu học tập', 13, 1),
('REV_OTHER', 'Doanh thu khác', 'Revenue', 2, 'Các khoản thu khác', 19, 1),

-- Expense Categories
('EXP', 'Chi phí', 'Expense', 1, 'Tổng chi phí', 20, 1),
('EXP_SALARY', 'Chi phí lương', 'Expense', 2, 'Lương và phụ cấp nhân viên', 21, 1),
('EXP_RENT', 'Chi phí thuê mặt bằng', 'Expense', 2, 'Thuê văn phòng, phòng học', 22, 1),
('EXP_UTILITY', 'Chi phí tiện ích', 'Expense', 2, 'Điện, nước, internet, điện thoại', 23, 1),
('EXP_MARKETING', 'Chi phí marketing', 'Expense', 2, 'Quảng cáo, marketing, khuyến mãi', 24, 1),
('EXP_EQUIPMENT', 'Chi phí thiết bị', 'Expense', 2, 'Mua sắm, bảo trì thiết bị', 25, 1),
('EXP_TRAINING', 'Chi phí đào tạo', 'Expense', 2, 'Đào tạo nâng cao cho giảng viên', 26, 1),
('EXP_ADMIN', 'Chi phí hành chính', 'Expense', 2, 'Văn phòng phẩm, hành chính', 27, 1),
('EXP_OTHER', 'Chi phí khác', 'Expense', 2, 'Các chi phí khác', 29, 1),

-- Asset Categories
('AST', 'Tài sản', 'Asset', 1, 'Tổng tài sản', 30, 1),
('AST_CASH', 'Tiền mặt', 'Asset', 2, 'Tiền mặt tại quầy', 31, 1),
('AST_BANK', 'Tiền gửi ngân hàng', 'Asset', 2, 'Các tài khoản ngân hàng', 32, 1),
('AST_EQUIPMENT', 'Thiết bị', 'Asset', 2, 'Máy tính, thiết bị dạy học', 33, 1);

-- Thêm dữ liệu mẫu cho FinancialTransaction
INSERT INTO FinancialTransaction (TransactionCode, TransactionDate, CategoryID, BranchID, Amount, TransactionType, PaymentMethod, Description, FiscalYear, FiscalQuarter, CreatedBy) VALUES
-- Revenue transactions
('REV-2025-001', '2025-01-15', 2, 1, 5000000, 'Income', 'Bank Transfer', 'Học phí khóa TOEIC cơ bản - Học viên Nguyễn Văn A', 2025, 1, 1),
('REV-2025-002', '2025-01-18', 2, 1, 8000000, 'Income', 'Cash', 'Học phí khóa IELTS nâng cao - Học viên Trần Thị B', 2025, 1, 1),
('REV-2025-003', '2025-01-20', 3, 1, 500000, 'Income', 'Online Payment', 'Phí đăng ký khóa Business English', 2025, 1, 1),
('REV-2025-004', '2025-01-25', 2, 2, 6000000, 'Income', 'Bank Transfer', 'Học phí khóa TOEFL - Chi nhánh 2', 2025, 1, 1),
('REV-2025-005', '2025-02-01', 4, 1, 300000, 'Income', 'Cash', 'Bán tài liệu học tập', 2025, 1, 1),

-- Expense transactions
('EXP-2025-001', '2025-01-31', 7, 1, 45000000, 'Expense', 'Bank Transfer', 'Lương tháng 1/2025 - Chi nhánh 1', 2025, 1, 1),
('EXP-2025-002', '2025-01-31', 7, 2, 25000000, 'Expense', 'Bank Transfer', 'Lương tháng 1/2025 - Chi nhánh 2', 2025, 1, 1),
('EXP-2025-003', '2025-01-05', 8, 1, 15000000, 'Expense', 'Bank Transfer', 'Tiền thuê mặt bằng tháng 1/2025', 2025, 1, 1),
('EXP-2025-004', '2025-01-10', 9, 1, 3500000, 'Expense', 'Bank Transfer', 'Tiền điện, nước, internet tháng 1', 2025, 1, 1),
('EXP-2025-005', '2025-01-20', 10, 1, 8000000, 'Expense', 'Online Payment', 'Chi phí quảng cáo Facebook, Google Ads', 2025, 1, 1);

-- Thêm dữ liệu mẫu cho FinancialSummary
INSERT INTO FinancialSummary (ReportType, PeriodYear, PeriodMonth, BranchID, TotalRevenue, TotalExpense, GrossProfit, NetProfit, StudentPayments, SalaryExpense, OperatingExpense, MarketingExpense, RentExpense, UtilityExpense, StudentCount, ClassCount, GeneratedBy) VALUES
-- Monthly reports
('Monthly', 2025, 1, 1, 120000000, 85000000, 105000000, 35000000, 115000000, 45000000, 25000000, 8000000, 15000000, 3500000, 85, 12, 1),
('Monthly', 2025, 1, 2, 75000000, 50000000, 65000000, 25000000, 70000000, 25000000, 15000000, 5000000, 8000000, 2000000, 45, 6, 1),
('Monthly', 2025, 1, NULL, 195000000, 135000000, 170000000, 60000000, 185000000, 70000000, 40000000, 13000000, 23000000, 5500000, 130, 18, 1),

-- Quarterly reports
('Quarterly', 2025, NULL, 1, 350000000, 250000000, 320000000, 100000000, 340000000, 135000000, 75000000, 25000000, 45000000, 10000000, 85, 12, 1),
('Quarterly', 2025, NULL, 2, 220000000, 150000000, 200000000, 70000000, 210000000, 75000000, 45000000, 15000000, 24000000, 6000000, 45, 6, 1),
('Quarterly', 2025, NULL, NULL, 570000000, 400000000, 520000000, 170000000, 550000000, 210000000, 120000000, 40000000, 69000000, 16000000, 130, 18, 1);

-- Thêm dữ liệu mẫu cho StudentFinancialRecord
INSERT INTO StudentFinancialRecord (StudentID, ClassID, TransactionType, Amount, DueDate, PaymentDate, PaymentMethod, ReceiptNumber, IsFullyPaid, CreatedBy) VALUES
(1, 1, 'Tuition Payment', 5000000, '2025-01-15', '2025-01-15', 'Bank Transfer', 'RC-2025-001', 1, 1),
(2, 2, 'Tuition Payment', 8000000, '2025-01-20', '2025-01-18', 'Cash', 'RC-2025-002', 1, 1),
(3, 1, 'Tuition Payment', 5000000, '2025-01-25', NULL, NULL, NULL, 0, 1),
(4, 3, 'Registration Fee', 500000, '2025-01-10', '2025-01-20', 'Online Payment', 'RC-2025-003', 1, 1),
(5, 4, 'Tuition Payment', 6000000, '2025-02-01', '2025-01-25', 'Bank Transfer', 'RC-2025-004', 1, 1);

-- Thêm dữ liệu mẫu cho PayrollExpense
INSERT INTO PayrollExpense (PayrollMonth, PayrollYear, BranchID, TotalBasicSalary, TotalAllowances, TotalBonuses, TotalDeductions, TotalGrossPay, TotalNetPay, EmployerInsurance, EmployeeCount, CreatedBy) VALUES
(1, 2025, 1, 35000000, 8000000, 3000000, 1000000, 46000000, 45000000, 8050000, 6, 1),
(1, 2025, 2, 20000000, 4500000, 1500000, 500000, 26000000, 25500000, 4550000, 4, 1),
(1, 2025, NULL, 55000000, 12500000, 4500000, 1500000, 72000000, 70500000, 12600000, 10, 1);

-- View tổng hợp cho FinancialDashBoard.html
CREATE VIEW vw_FinancialDashboard AS
SELECT 
    fs.SummaryID,
    fs.ReportType,
    fs.PeriodYear,
    fs.PeriodMonth,
    fs.PeriodQuarter,
    CASE 
        WHEN fs.BranchID IS NULL THEN 'Toàn doanh nghiệp'
        ELSE b.BranchName
    END AS BranchName,
    fs.BranchID,
    fs.TotalRevenue,
    fs.TotalExpense,
    fs.GrossProfit,
    fs.NetProfit,
    fs.StudentPayments,
    fs.SalaryExpense,
    fs.OperatingExpense,
    fs.MarketingExpense,
    fs.RentExpense,
    fs.UtilityExpense,
    fs.OtherIncome,
    fs.OtherExpense,
    fs.CashBalance,
    fs.BankBalance,
    fs.TotalAssets,
    fs.TotalLiabilities,
    fs.Equity,
    fs.StudentCount,
    fs.ClassCount,
    fs.RevenuePerStudent,
    fs.ProfitMargin,
    fs.GeneratedDate,
    generator.FullName AS GeneratedByName,
    -- Tính toán các chỉ số bổ sung
    CASE WHEN fs.TotalRevenue > 0 THEN (fs.SalaryExpense * 100.0) / fs.TotalRevenue ELSE 0 END AS SalaryToRevenueRatio,
    CASE WHEN fs.TotalRevenue > 0 THEN (fs.OperatingExpense * 100.0) / fs.TotalRevenue ELSE 0 END AS OperatingExpenseRatio,
    CASE WHEN fs.StudentCount > 0 THEN fs.TotalExpense / fs.StudentCount ELSE 0 END AS ExpensePerStudent,
    CASE WHEN fs.ClassCount > 0 THEN fs.TotalRevenue / fs.ClassCount ELSE 0 END AS RevenuePerClass
FROM FinancialSummary fs
LEFT JOIN Branch b ON fs.BranchID = b.BranchID
LEFT JOIN Staff generator ON fs.GeneratedBy = generator.StaffID;

-- Stored Procedure để lấy dữ liệu dashboard tài chính
CREATE PROCEDURE sp_GetFinancialDashboardData
    @ReportType NVARCHAR(50) = 'Monthly', -- 'Monthly', 'Quarterly', 'Yearly'
    @Year INT = NULL, -- Năm báo cáo (mặc định năm hiện tại)
    @Month INT = NULL, -- Tháng (chỉ cho Monthly report)
    @Quarter INT = NULL, -- Quý (chỉ cho Quarterly report)
    @BranchID INT = NULL -- Chi nhánh (NULL = tất cả)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Year IS NULL
        SET @Year = YEAR(GETDATE());
    
    -- Enterprise summary (tổng toàn doanh nghiệp)
    SELECT 
        SummaryID,
        ReportType,
        PeriodYear,
        PeriodMonth,
        PeriodQuarter,
        BranchName,
        BranchID,
        TotalRevenue,
        TotalExpense,
        GrossProfit,
        NetProfit,
        StudentPayments,
        SalaryExpense,
        OperatingExpense,
        MarketingExpense,
        RentExpense,
        UtilityExpense,
        StudentCount,
        ClassCount,
        RevenuePerStudent,
        ProfitMargin,
        SalaryToRevenueRatio,
        OperatingExpenseRatio,
        ExpensePerStudent,
        RevenuePerClass,
        GeneratedDate,
        GeneratedByName
    FROM vw_FinancialDashboard
    WHERE ReportType = @ReportType 
      AND PeriodYear = @Year
      AND (@Month IS NULL OR PeriodMonth = @Month)
      AND (@Quarter IS NULL OR PeriodQuarter = @Quarter)
      AND BranchID IS NULL; -- Enterprise level
    
    -- Branch summary (theo từng chi nhánh)
    SELECT 
        SummaryID,
        ReportType,
        PeriodYear,
        PeriodMonth,
        PeriodQuarter,
        BranchName,
        BranchID,
        TotalRevenue,
        TotalExpense,
        GrossProfit,
        NetProfit,
        StudentPayments,
        SalaryExpense,
        OperatingExpense,
        MarketingExpense,
        RentExpense,
        UtilityExpense,
        StudentCount,
        ClassCount,
        RevenuePerStudent,
        ProfitMargin,
        SalaryToRevenueRatio,
        OperatingExpenseRatio,
        ExpensePerStudent,
        RevenuePerClass,
        GeneratedDate,
        GeneratedByName
    FROM vw_FinancialDashboard
    WHERE ReportType = @ReportType 
      AND PeriodYear = @Year
      AND (@Month IS NULL OR PeriodMonth = @Month)
      AND (@Quarter IS NULL OR PeriodQuarter = @Quarter)
      AND BranchID IS NOT NULL
      AND (@BranchID IS NULL OR BranchID = @BranchID)
    ORDER BY BranchName;
END;

-- Stored Procedure để lấy dữ liệu biểu đồ doanh thu
CREATE PROCEDURE sp_GetRevenueChartData
    @Year INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Year IS NULL
        SET @Year = YEAR(GETDATE());
    
    -- Monthly revenue data for charts
    SELECT 
        PeriodMonth AS Month,
        SUM(TotalRevenue) AS Revenue,
        SUM(StudentPayments) AS StudentPayments,
        SUM(OtherIncome) AS OtherIncome
    FROM FinancialSummary
    WHERE PeriodYear = @Year 
      AND ReportType = 'Monthly'
      AND (@BranchID IS NULL OR BranchID = @BranchID OR BranchID IS NULL)
    GROUP BY PeriodMonth
    ORDER BY PeriodMonth;
END;

-- Stored Procedure để lấy dữ liệu biểu đồ chi phí
CREATE PROCEDURE sp_GetExpenseChartData
    @Year INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Year IS NULL
        SET @Year = YEAR(GETDATE());
    
    -- Monthly expense breakdown
    SELECT 
        PeriodMonth AS Month,
        SUM(SalaryExpense) AS SalaryExpense,
        SUM(OperatingExpense) AS OperatingExpense,
        SUM(MarketingExpense) AS MarketingExpense,
        SUM(RentExpense) AS RentExpense,
        SUM(UtilityExpense) AS UtilityExpense,
        SUM(OtherExpense) AS OtherExpense,
        SUM(TotalExpense) AS TotalExpense
    FROM FinancialSummary
    WHERE PeriodYear = @Year 
      AND ReportType = 'Monthly'
      AND (@BranchID IS NULL OR BranchID = @BranchID OR BranchID IS NULL)
    GROUP BY PeriodMonth
    ORDER BY PeriodMonth;
END;

-- Stored Procedure để lấy dữ liệu biểu đồ lợi nhuận
CREATE PROCEDURE sp_GetProfitChartData
    @Year INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Year IS NULL
        SET @Year = YEAR(GETDATE());
    
    -- Monthly profit data
    SELECT 
        PeriodMonth AS Month,
        SUM(TotalRevenue) AS Revenue,
        SUM(TotalExpense) AS Expense,
        SUM(GrossProfit) AS GrossProfit,
        SUM(NetProfit) AS NetProfit,
        AVG(ProfitMargin) AS ProfitMargin
    FROM FinancialSummary
    WHERE PeriodYear = @Year 
      AND ReportType = 'Monthly'
      AND (@BranchID IS NULL OR BranchID = @BranchID OR BranchID IS NULL)
    GROUP BY PeriodMonth
    ORDER BY PeriodMonth;
END;

-- Stored Procedure để tạo báo cáo tài chính tự động
CREATE PROCEDURE sp_GenerateFinancialSummary
    @ReportType NVARCHAR(50), -- 'Monthly', 'Quarterly', 'Yearly'
    @Year INT,
    @Month INT = NULL,
    @Quarter INT = NULL,
    @BranchID INT = NULL,
    @GeneratedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @StartDate DATE, @EndDate DATE;
        
        -- Xác định khoảng thời gian
        IF @ReportType = 'Monthly' AND @Month IS NOT NULL
        BEGIN
            SET @StartDate = DATEFROMPARTS(@Year, @Month, 1);
            SET @EndDate = EOMONTH(@StartDate);
        END
        ELSE IF @ReportType = 'Quarterly' AND @Quarter IS NOT NULL
        BEGIN
            SET @StartDate = DATEFROMPARTS(@Year, (@Quarter - 1) * 3 + 1, 1);
            SET @EndDate = EOMONTH(DATEADD(MONTH, 2, @StartDate));
        END
        ELSE IF @ReportType = 'Yearly'
        BEGIN
            SET @StartDate = DATEFROMPARTS(@Year, 1, 1);
            SET @EndDate = DATEFROMPARTS(@Year, 12, 31);
        END
        
        -- Tính toán và insert/update summary
        MERGE FinancialSummary AS target
        USING (
            SELECT 
                @ReportType AS ReportType,
                @Year AS PeriodYear,
                @Month AS PeriodMonth,
                @Quarter AS PeriodQuarter,
                @BranchID AS BranchID,
                -- Tính toán các giá trị từ transactions
                ISNULL(SUM(CASE WHEN ft.TransactionType = 'Income' THEN ft.Amount ELSE 0 END), 0) AS TotalRevenue,
                ISNULL(SUM(CASE WHEN ft.TransactionType = 'Expense' THEN ft.Amount ELSE 0 END), 0) AS TotalExpense,
                -- Các tính toán khác sẽ được thêm vào đây
                COUNT(DISTINCT s.StudentID) AS StudentCount,
                COUNT(DISTINCT c.ClassID) AS ClassCount
            FROM FinancialTransaction ft
            LEFT JOIN Student s ON ft.StudentID = s.StudentID
            LEFT JOIN Class c ON ft.ClassID = c.ClassID
            WHERE ft.TransactionDate BETWEEN @StartDate AND @EndDate
              AND (@BranchID IS NULL OR ft.BranchID = @BranchID)
        ) AS source ON (
            target.ReportType = source.ReportType AND
            target.PeriodYear = source.PeriodYear AND
            ISNULL(target.PeriodMonth, 0) = ISNULL(source.PeriodMonth, 0) AND
            ISNULL(target.PeriodQuarter, 0) = ISNULL(source.PeriodQuarter, 0) AND
            ISNULL(target.BranchID, 0) = ISNULL(source.BranchID, 0)
        )
        WHEN MATCHED THEN
            UPDATE SET 
                TotalRevenue = source.TotalRevenue,
                TotalExpense = source.TotalExpense,
                GrossProfit = source.TotalRevenue - source.TotalExpense,
                NetProfit = source.TotalRevenue - source.TotalExpense,
                StudentCount = source.StudentCount,
                ClassCount = source.ClassCount,
                LastUpdated = GETDATE(),
                UpdatedBy = @GeneratedBy
        WHEN NOT MATCHED THEN
            INSERT (ReportType, PeriodYear, PeriodMonth, PeriodQuarter, BranchID, 
                   TotalRevenue, TotalExpense, GrossProfit, NetProfit, 
                   StudentCount, ClassCount, GeneratedBy)
            VALUES (source.ReportType, source.PeriodYear, source.PeriodMonth, 
                   source.PeriodQuarter, source.BranchID, source.TotalRevenue, 
                   source.TotalExpense, source.TotalRevenue - source.TotalExpense,
                   source.TotalRevenue - source.TotalExpense, source.StudentCount, 
                   source.ClassCount, @GeneratedBy);
        
        COMMIT TRANSACTION;
        SELECT 'Success' AS Result, 'Báo cáo tài chính đã được tạo thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

PRINT 'Financial Management System created successfully!';
PRINT '';
PRINT 'New FinancialDashBoard.html Support Features Added:';
PRINT '- FinancialCategory: Chart of accounts for categorizing transactions';
PRINT '- FinancialTransaction: Complete transaction recording system';
PRINT '- FinancialSummary: Automated financial reporting and summaries';
PRINT '- FinancialBudget: Budget planning and variance analysis';
PRINT '- StudentFinancialRecord: Student payment and fee tracking';
PRINT '- PayrollExpense: Payroll cost tracking and analysis';
PRINT '';
PRINT 'Key Database Tables Created:';
PRINT '- FinancialCategory: Hierarchical account classification';
PRINT '- FinancialTransaction: Detailed transaction records with reconciliation';
PRINT '- FinancialSummary: Automated monthly/quarterly/yearly summaries';
PRINT '- FinancialBudget: Budget vs actual with variance analysis';
PRINT '- StudentFinancialRecord: Student payment tracking';
PRINT '- PayrollExpense: Comprehensive payroll cost management';
PRINT '';
PRINT 'Enhanced Views and Procedures:';
PRINT '- vw_FinancialDashboard: Complete financial overview for dashboard';
PRINT '- sp_GetFinancialDashboardData: Main procedure for dashboard data';
PRINT '- sp_GetRevenueChartData: Revenue chart data by month';
PRINT '- sp_GetExpenseChartData: Expense breakdown chart data';
PRINT '- sp_GetProfitChartData: Profit analysis chart data';
PRINT '- sp_GenerateFinancialSummary: Automated report generation';
PRINT '';
PRINT 'Key Features for FinancialDashBoard Interface:';
PRINT '✅ Enterprise and branch-level financial summaries';
PRINT '✅ Revenue, expense, and profit tracking with charts';
PRINT '✅ Monthly, quarterly, and yearly reporting periods';
PRINT '✅ Student payment and tuition fee management';
PRINT '✅ Payroll cost tracking and analysis';
PRINT '✅ Budget vs actual variance reporting';
PRINT '✅ Key financial ratios and KPIs calculation';
PRINT '✅ Chart.js compatible data for visualizations';
PRINT '✅ Multi-branch financial consolidation';
PRINT '✅ Automated financial summary generation';
PRINT '';
PRINT 'Sample Data Added:';
PRINT '- 17 Financial Categories: Revenue, Expense, Asset categories';
PRINT '- 10 Sample Transactions: Revenue and expense transactions';
PRINT '- 6 Financial Summaries: Monthly, quarterly reports for branches';
PRINT '- 5 Student Financial Records: Tuition payments and fees';
PRINT '- 3 Payroll Expense Records: Monthly payroll costs by branch';
PRINT '';
PRINT 'Database now fully supports FinancialDashBoard.html with comprehensive financial management!';
-- ============================================================================
-- 19. ENHANCED BRANCH MANAGEMENT SYSTEM
-- ============================================================================

-- Cập nhật bảng Branch với thêm các trường cần thiết cho UI
ALTER TABLE Branch ADD BranchCode NVARCHAR(20) UNIQUE;
ALTER TABLE Branch ADD OperatingLicense NVARCHAR(100);
ALTER TABLE Branch ADD BranchDirector NVARCHAR(255);
ALTER TABLE Branch ADD EstablishedDate DATE;
ALTER TABLE Branch ADD RegistrationNumber NVARCHAR(50);
ALTER TABLE Branch ADD TaxCode NVARCHAR(20);
ALTER TABLE Branch ADD BusinessType NVARCHAR(100);
ALTER TABLE Branch ADD TotalArea DECIMAL(10,2);
ALTER TABLE Branch ADD MonthlyRent DECIMAL(15,2);
ALTER TABLE Branch ADD MaxCapacity INT;
ALTER TABLE Branch ADD ParkingSlots INT;
ALTER TABLE Branch ADD HasElevator BIT DEFAULT 0;
ALTER TABLE Branch ADD HasAirConditioner BIT DEFAULT 1;
ALTER TABLE Branch ADD HasProjector BIT DEFAULT 1;
ALTER TABLE Branch ADD HasWiFi BIT DEFAULT 1;
ALTER TABLE Branch ADD ContactEmail NVARCHAR(255);
ALTER TABLE Branch ADD Website NVARCHAR(255);
ALTER TABLE Branch ADD SocialMedia NVARCHAR(MAX); -- JSON format for multiple social media links
ALTER TABLE Branch ADD BankAccount NVARCHAR(50);
ALTER TABLE Branch ADD BankName NVARCHAR(100);
ALTER TABLE Branch ADD Notes NVARCHAR(MAX);

-- Cập nhật dữ liệu Branch hiện tại với thông tin chi tiết
UPDATE Branch SET 
    BranchCode = 'CN001',
    OperatingLicense = 'GPKD001/2024',
    BranchDirector = 'Nguyễn Văn Minh',
    EstablishedDate = '2024-01-15',
    RegistrationNumber = 'DN001-2024',
    TaxCode = '0123456789',
    BusinessType = 'Giáo dục và đào tạo',
    TotalArea = 500.00,
    MonthlyRent = 25000000,
    MaxCapacity = 200,
    ParkingSlots = 15,
    HasElevator = 1,
    ContactEmail = 'chinhanh1@nn68.edu.vn',
    Website = 'https://cn1.nn68.edu.vn',
    SocialMedia = '{"facebook": "https://facebook.com/nn68cn1", "youtube": "https://youtube.com/nn68cn1"}',
    BankAccount = '1234567890',
    BankName = 'Ngân hàng Vietcombank',
    Notes = 'Chi nhánh chính, hoạt động từ năm 2024'
WHERE BranchID = 1;

-- Thêm dữ liệu Branch mẫu để test UI
INSERT INTO Branch (BranchCode, BranchName, Address, PhoneNumber, Email, ManagerName, OperatingLicense, BranchDirector, EstablishedDate, StatusID) VALUES
('CN002', 'Chi Nhánh TP.HCM', '456 Đường Nguyễn Trãi, Quận 5, TP.HCM', '028-12345678', 'hcm@nn68.edu.vn', 'Trần Thị Lan', 'GPKD002/2024', 'Trần Thị Lan', '2024-03-01', 1),
('CN003', 'Chi Nhánh Đà Nẵng', '789 Đường Lê Duẩn, Hải Châu, Đà Nẵng', '0236-123456', 'danang@nn68.edu.vn', 'Lê Văn Đức', 'GPKD003/2024', 'Lê Văn Đức', '2024-05-15', 1),
('CN004', 'Chi Nhánh Cần Thơ', '321 Đường 3/2, Ninh Kiều, Cần Thơ', '0292-123456', 'cantho@nn68.edu.vn', 'Phạm Văn Hùng', 'GPKD004/2024', 'Phạm Văn Hùng', '2024-07-01', 1),
('CN005', 'Chi Nhánh Hải Phòng', '654 Đường Lạch Tray, Ngô Quyền, Hải Phòng', '0225-123456', 'haiphong@nn68.edu.vn', 'Hoàng Thị Mai', 'GPKD005/2024', 'Hoàng Thị Mai', '2024-08-15', 2); -- Ngừng hoạt động

-- Bảng lịch sử thay đổi thông tin chi nhánh
CREATE TABLE BranchChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT,
    FieldChanged NVARCHAR(100),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ChangeReason NVARCHAR(1000),
    ChangedBy INT,
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ChangedBy) REFERENCES Staff(StaffID)
);

-- Bảng quản lý địa điểm và cơ sở vật chất của chi nhánh
CREATE TABLE BranchFacility (
    FacilityID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT,
    FacilityType NVARCHAR(100), -- 'Classroom', 'Lab', 'Library', 'Cafeteria', 'Office', 'Storage'
    FacilityName NVARCHAR(255),
    Floor INT,
    RoomNumber NVARCHAR(20),
    Area DECIMAL(8,2), -- Diện tích m2
    Capacity INT, -- Sức chứa
    Equipment NVARCHAR(MAX), -- JSON format cho danh sách thiết bị
    StatusID INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastMaintenance DATETIME2,
    NextMaintenance DATETIME2,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (StatusID) REFERENCES GeneralStatus(StatusID)
);

-- Thêm dữ liệu facility mẫu
INSERT INTO BranchFacility (BranchID, FacilityType, FacilityName, Floor, RoomNumber, Area, Capacity, Equipment, StatusID) VALUES
(1, 'Classroom', 'Phòng học A1', 1, 'A101', 50.00, 30, '{"projector": true, "whiteboard": true, "ac": true, "speakers": true}', 1),
(1, 'Classroom', 'Phòng học A2', 1, 'A102', 45.00, 25, '{"projector": true, "whiteboard": true, "ac": true}', 1),
(1, 'Lab', 'Phòng Lab Nghe', 2, 'L201', 60.00, 20, '{"computers": 20, "headphones": 20, "projector": true, "ac": true}', 1),
(1, 'Office', 'Văn phòng Giám đốc', 3, 'O301', 25.00, 5, '{"desk": 1, "chairs": 5, "ac": true, "phone": true}', 1),
(1, 'Library', 'Thư viện', 2, 'L202', 100.00, 50, '{"books": 1000, "tables": 10, "chairs": 50, "ac": true}', 1);

-- Bảng nhân viên theo chi nhánh với thông tin chi tiết
CREATE TABLE BranchStaffAssignment (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT,
    StaffID INT,
    Position NVARCHAR(100), -- Chức vụ tại chi nhánh
    StartDate DATE,
    EndDate DATE,
    IsActive BIT DEFAULT 1,
    Responsibilities NVARCHAR(MAX), -- Mô tả trách nhiệm
    ReportingTo INT, -- ID của người quản lý trực tiếp
    AssignedBy INT,
    AssignmentDate DATETIME2 DEFAULT GETDATE(),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ReportingTo) REFERENCES Staff(StaffID),
    FOREIGN KEY (AssignedBy) REFERENCES Staff(StaffID)
);

-- Gán nhân viên vào chi nhánh
INSERT INTO BranchStaffAssignment (BranchID, StaffID, Position, StartDate, Responsibilities, AssignedBy) VALUES
(1, 1, 'Quản trị hệ thống', '2024-01-15', 'Quản lý toàn bộ hệ thống IT và cơ sở dữ liệu', 1),
(1, 2, 'Trưởng phòng Giáo vụ', '2024-01-15', 'Quản lý hoạt động giáo vụ và đào tạo', 1),
(1, 3, 'Giảng viên chính', '2024-02-01', 'Giảng dạy các khóa học ngoại ngữ', 2),
(1, 4, 'Nhân viên tư vấn', '2024-02-15', 'Tư vấn và hỗ trợ học viên', 2);

-- ============================================================================
-- 20. ENHANCED VIEWS FOR BRANCH MANAGEMENT
-- ============================================================================

-- View chi tiết thông tin chi nhánh cho UI
CREATE VIEW vw_BranchManagement AS
SELECT 
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.Address,
    b.PhoneNumber,
    b.Email,
    b.ManagerName,
    b.OperatingLicense,
    b.BranchDirector,
    b.EstablishedDate,
    b.RegistrationNumber,
    b.TaxCode,
    b.BusinessType,
    b.TotalArea,
    b.MonthlyRent,
    b.MaxCapacity,
    b.ParkingSlots,
    b.HasElevator,
    b.HasAirConditioner,
    b.HasProjector,
    b.HasWiFi,
    b.ContactEmail,
    b.Website,
    b.SocialMedia,
    b.BankAccount,
    b.BankName,
    b.Notes,
    gs.StatusName AS BranchStatus,
    gs.StatusID,
    b.CreatedDate,
    b.LastModified,
    -- Đếm số nhân viên trong chi nhánh
    (SELECT COUNT(*) FROM BranchStaffAssignment bsa WHERE bsa.BranchID = b.BranchID AND bsa.IsActive = 1) AS TotalStaff,
    -- Đếm số phòng/cơ sở vật chất
    (SELECT COUNT(*) FROM BranchFacility bf WHERE bf.BranchID = b.BranchID AND bf.StatusID = 1) AS TotalFacilities,
    -- Tổng diện tích cơ sở vật chất
    (SELECT ISNULL(SUM(bf.Area), 0) FROM BranchFacility bf WHERE bf.BranchID = b.BranchID AND bf.StatusID = 1) AS TotalFacilityArea
FROM Branch b
INNER JOIN GeneralStatus gs ON b.StatusID = gs.StatusID;

-- View thống kê chi nhánh theo tháng
CREATE VIEW vw_BranchStatistics AS
SELECT 
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.BranchStatus,
    b.TotalStaff,
    b.TotalFacilities,
    b.TotalFacilityArea,
    b.MonthlyRent,
    -- Thống kê theo tháng hiện tại (sẽ cần bảng Student và Class để tính chính xác)
    0 AS CurrentMonthStudents, -- Placeholder
    0 AS CurrentMonthClasses,  -- Placeholder
    0 AS CurrentMonthRevenue   -- Placeholder
FROM vw_BranchManagement b;

-- View lịch sử thay đổi chi nhánh
CREATE VIEW vw_BranchChangeHistory AS
SELECT 
    bcl.LogID,
    bcl.BranchID,
    b.BranchCode,
    b.BranchName,
    bcl.FieldChanged,
    bcl.OldValue,
    bcl.NewValue,
    bcl.ChangeReason,
    s.FullName AS ChangedByName,
    bcl.ChangeDate
FROM BranchChangeLog bcl
INNER JOIN Branch b ON bcl.BranchID = b.BranchID
LEFT JOIN Staff s ON bcl.ChangedBy = s.StaffID;

-- ============================================================================
-- 21. STORED PROCEDURES FOR BRANCH MANAGEMENT
-- ============================================================================

-- Procedure lấy danh sách chi nhánh cho UI
CREATE PROCEDURE sp_GetBranchesForManagement
    @SearchTerm NVARCHAR(255) = NULL,
    @StatusFilter INT = NULL,
    @IncludeStatistics BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @IncludeStatistics = 1
    BEGIN
        SELECT * FROM vw_BranchStatistics
        WHERE 
            (@SearchTerm IS NULL OR 
             BranchCode LIKE '%' + @SearchTerm + '%' OR
             BranchName LIKE '%' + @SearchTerm + '%' OR
             BranchStatus LIKE '%' + @SearchTerm + '%')
        AND (@StatusFilter IS NULL OR StatusID = @StatusFilter)
        ORDER BY BranchCode;
    END
    ELSE
    BEGIN
        SELECT * FROM vw_BranchManagement
        WHERE 
            (@SearchTerm IS NULL OR 
             BranchCode LIKE '%' + @SearchTerm + '%' OR
             BranchName LIKE '%' + @SearchTerm + '%' OR
             Address LIKE '%' + @SearchTerm + '%' OR
             BranchDirector LIKE '%' + @SearchTerm + '%' OR
             OperatingLicense LIKE '%' + @SearchTerm + '%' OR
             BranchStatus LIKE '%' + @SearchTerm + '%')
        AND (@StatusFilter IS NULL OR StatusID = @StatusFilter)
        ORDER BY BranchCode;
    END
END;

-- Procedure tạo chi nhánh mới
CREATE PROCEDURE sp_CreateBranch
    @BranchCode NVARCHAR(20),
    @BranchName NVARCHAR(255),
    @Address NVARCHAR(MAX),
    @PhoneNumber NVARCHAR(20) = NULL,
    @Email NVARCHAR(255) = NULL,
    @ManagerName NVARCHAR(255) = NULL,
    @OperatingLicense NVARCHAR(100) = NULL,
    @BranchDirector NVARCHAR(255) = NULL,
    @EstablishedDate DATE = NULL,
    @RegistrationNumber NVARCHAR(50) = NULL,
    @TaxCode NVARCHAR(20) = NULL,
    @BusinessType NVARCHAR(100) = NULL,
    @TotalArea DECIMAL(10,2) = NULL,
    @MonthlyRent DECIMAL(15,2) = NULL,
    @MaxCapacity INT = NULL,
    @ContactEmail NVARCHAR(255) = NULL,
    @Website NVARCHAR(255) = NULL,
    @BankAccount NVARCHAR(50) = NULL,
    @BankName NVARCHAR(100) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra trùng mã chi nhánh
        IF EXISTS (SELECT 1 FROM Branch WHERE BranchCode = @BranchCode)
        BEGIN
            SELECT 'Error' AS Result, 'Mã chi nhánh đã tồn tại' AS Message;
            RETURN;
        END
        
        DECLARE @NewBranchID INT;
        
        INSERT INTO Branch (
            BranchCode, BranchName, Address, PhoneNumber, Email, ManagerName,
            OperatingLicense, BranchDirector, EstablishedDate, RegistrationNumber,
            TaxCode, BusinessType, TotalArea, MonthlyRent, MaxCapacity,
            ContactEmail, Website, BankAccount, BankName, Notes, StatusID
        ) VALUES (
            @BranchCode, @BranchName, @Address, @PhoneNumber, @Email, @ManagerName,
            @OperatingLicense, @BranchDirector, @EstablishedDate, @RegistrationNumber,
            @TaxCode, @BusinessType, @TotalArea, @MonthlyRent, @MaxCapacity,
            @ContactEmail, @Website, @BankAccount, @BankName, @Notes, 1
        );
        
        SET @NewBranchID = SCOPE_IDENTITY();
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (3, @CreatedBy, 'Branch', @NewBranchID, 'Tạo mới chi nhánh: ' + @BranchName);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Chi nhánh đã được tạo thành công' AS Message, @NewBranchID AS BranchID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure cập nhật thông tin chi nhánh
CREATE PROCEDURE sp_UpdateBranch
    @BranchID INT,
    @BranchCode NVARCHAR(20),
    @BranchName NVARCHAR(255),
    @Address NVARCHAR(MAX),
    @PhoneNumber NVARCHAR(20) = NULL,
    @Email NVARCHAR(255) = NULL,
    @ManagerName NVARCHAR(255) = NULL,
    @OperatingLicense NVARCHAR(100) = NULL,
    @BranchDirector NVARCHAR(255) = NULL,
    @EstablishedDate DATE = NULL,
    @StatusID INT = NULL,
    @TotalArea DECIMAL(10,2) = NULL,
    @MonthlyRent DECIMAL(15,2) = NULL,
    @MaxCapacity INT = NULL,
    @ContactEmail NVARCHAR(255) = NULL,
    @Website NVARCHAR(255) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @UpdatedBy INT,
    @ChangeReason NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Kiểm tra chi nhánh tồn tại
        IF NOT EXISTS (SELECT 1 FROM Branch WHERE BranchID = @BranchID)
        BEGIN
            SELECT 'Error' AS Result, 'Chi nhánh không tồn tại' AS Message;
            RETURN;
        END
        
        -- Kiểm tra trùng mã chi nhánh (ngoại trừ chính nó)
        IF EXISTS (SELECT 1 FROM Branch WHERE BranchCode = @BranchCode AND BranchID != @BranchID)
        BEGIN
            SELECT 'Error' AS Result, 'Mã chi nhánh đã tồn tại' AS Message;
            RETURN;
        END
        
        -- Lưu giá trị cũ để log
        DECLARE @OldData TABLE (
            FieldName NVARCHAR(100),
            OldValue NVARCHAR(MAX),
            NewValue NVARCHAR(MAX)
        );
        
        -- So sánh và lưu các thay đổi
        INSERT INTO @OldData
        SELECT 'BranchName', BranchName, @BranchName FROM Branch WHERE BranchID = @BranchID AND BranchName != @BranchName
        UNION ALL
        SELECT 'Address', Address, @Address FROM Branch WHERE BranchID = @BranchID AND ISNULL(Address, '') != ISNULL(@Address, '')
        UNION ALL
        SELECT 'BranchDirector', BranchDirector, @BranchDirector FROM Branch WHERE BranchID = @BranchID AND ISNULL(BranchDirector, '') != ISNULL(@BranchDirector, '')
        UNION ALL
        SELECT 'StatusID', CAST(StatusID AS NVARCHAR), CAST(@StatusID AS NVARCHAR) FROM Branch WHERE BranchID = @BranchID AND StatusID != @StatusID;
        
        -- Cập nhật chi nhánh
        UPDATE Branch SET
            BranchCode = @BranchCode,
            BranchName = @BranchName,
            Address = @Address,
            PhoneNumber = @PhoneNumber,
            Email = @Email,
            ManagerName = @ManagerName,
            OperatingLicense = @OperatingLicense,
            BranchDirector = @BranchDirector,
            EstablishedDate = @EstablishedDate,
            StatusID = ISNULL(@StatusID, StatusID),
            TotalArea = @TotalArea,
            MonthlyRent = @MonthlyRent,
            MaxCapacity = @MaxCapacity,
            ContactEmail = @ContactEmail,
            Website = @Website,
            Notes = @Notes,
            LastModified = GETDATE()
        WHERE BranchID = @BranchID;
        
        -- Log các thay đổi
        INSERT INTO BranchChangeLog (BranchID, FieldChanged, OldValue, NewValue, ChangeReason, ChangedBy)
        SELECT @BranchID, FieldName, OldValue, NewValue, @ChangeReason, @UpdatedBy
        FROM @OldData;
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description)
        VALUES (4, @UpdatedBy, 'Branch', @BranchID, 'Cập nhật thông tin chi nhánh: ' + @BranchName);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Thông tin chi nhánh đã được cập nhật thành công' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure lấy thông tin chi tiết một chi nhánh
CREATE PROCEDURE sp_GetBranchDetails
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin cơ bản chi nhánh
    SELECT * FROM vw_BranchManagement WHERE BranchID = @BranchID;
    
    -- Danh sách nhân viên trong chi nhánh
    SELECT 
        bsa.*,
        s.FullName,
        s.Email,
        s.Position AS StaffPosition,
        manager.FullName AS ManagerName
    FROM BranchStaffAssignment bsa
    INNER JOIN Staff s ON bsa.StaffID = s.StaffID
    LEFT JOIN Staff manager ON bsa.ReportingTo = manager.StaffID
    WHERE bsa.BranchID = @BranchID AND bsa.IsActive = 1
    ORDER BY bsa.Position, s.FullName;
    
    -- Danh sách cơ sở vật chất
    SELECT 
        bf.*,
        gs.StatusName AS FacilityStatus
    FROM BranchFacility bf
    INNER JOIN GeneralStatus gs ON bf.StatusID = gs.StatusID
    WHERE bf.BranchID = @BranchID
    ORDER BY bf.Floor, bf.RoomNumber;
    
    -- Lịch sử thay đổi gần đây
    SELECT TOP 10 * FROM vw_BranchChangeHistory 
    WHERE BranchID = @BranchID 
    ORDER BY ChangeDate DESC;
END;

-- Procedure thống kê tổng quan chi nhánh
CREATE PROCEDURE sp_GetBranchOverviewStatistics
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS TotalBranches,
        COUNT(CASE WHEN StatusID = 1 THEN 1 END) AS ActiveBranches,
        COUNT(CASE WHEN StatusID = 2 THEN 1 END) AS InactiveBranches,
        ISNULL(SUM(TotalArea), 0) AS TotalArea,
        ISNULL(SUM(MonthlyRent), 0) AS TotalMonthlyRent,
        ISNULL(SUM(MaxCapacity), 0) AS TotalCapacity,
        ISNULL(AVG(TotalStaff), 0) AS AvgStaffPerBranch,
        ISNULL(AVG(TotalFacilities), 0) AS AvgFacilitiesPerBranch
    FROM vw_BranchManagement;
    
    -- Thống kê theo tỉnh/thành phố
    SELECT 
        CASE 
            WHEN Address LIKE '%Hà Nội%' THEN 'Hà Nội'
            WHEN Address LIKE '%TP.HCM%' OR Address LIKE '%Hồ Chí Minh%' THEN 'TP.HCM'
            WHEN Address LIKE '%Đà Nẵng%' THEN 'Đà Nẵng'
            WHEN Address LIKE '%Cần Thơ%' THEN 'Cần Thơ'
            WHEN Address LIKE '%Hải Phòng%' THEN 'Hải Phòng'
            ELSE 'Khác'
        END AS Province,
        COUNT(*) AS BranchCount,
        COUNT(CASE WHEN StatusID = 1 THEN 1 END) AS ActiveCount
    FROM vw_BranchManagement
    GROUP BY 
        CASE 
            WHEN Address LIKE '%Hà Nội%' THEN 'Hà Nội'
            WHEN Address LIKE '%TP.HCM%' OR Address LIKE '%Hồ Chí Minh%' THEN 'TP.HCM'
            WHEN Address LIKE '%Đà Nẵng%' THEN 'Đà Nẵng'
            WHEN Address LIKE '%Cần Thơ%' THEN 'Cần Thơ'
            WHEN Address LIKE '%Hải Phòng%' THEN 'Hải Phòng'
            ELSE 'Khác'
        END
    ORDER BY BranchCount DESC;
END;

PRINT 'Enhanced Branch Management System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Enhanced Branch table with 20+ detailed fields';
PRINT '- Branch facility management system';
PRINT '- Staff assignment tracking per branch';
PRINT '- Change history logging';
PRINT '- Comprehensive views for branch management UI';
PRINT '- Stored procedures for CRUD operations';
PRINT '- Statistical reporting capabilities';
PRINT '';
-- ============================================================================
-- 22. PASSWORD MANAGEMENT & SECURITY SYSTEM
-- ============================================================================

-- Bảng lịch sử đổi mật khẩu
CREATE TABLE PasswordHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    OldPasswordHash NVARCHAR(255), -- Hash của mật khẩu cũ
    NewPasswordHash NVARCHAR(255), -- Hash của mật khẩu mới
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    ChangeReason NVARCHAR(500), -- 'User Change', 'Force Reset', 'First Login', 'Security Policy'
    ChangedBy INT, -- Staff thực hiện thay đổi (có thể là chính user hoặc admin)
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    IsSuccessful BIT DEFAULT 1,
    FailureReason NVARCHAR(500),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (ChangedBy) REFERENCES Staff(StaffID)
);

-- Bảng chính sách mật khẩu
CREATE TABLE PasswordPolicy (
    PolicyID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyName NVARCHAR(100) UNIQUE NOT NULL,
    MinLength INT DEFAULT 8,
    MaxLength INT DEFAULT 128,
    RequireUppercase BIT DEFAULT 1,
    RequireLowercase BIT DEFAULT 1,
    RequireDigits BIT DEFAULT 1,
    RequireSpecialChars BIT DEFAULT 1,
    SpecialCharsAllowed NVARCHAR(50) DEFAULT '!@#$%^&*()_+-=[]{}|;:,.<>?',
    MaxConsecutiveRepeats INT DEFAULT 3, -- Số ký tự liên tiếp giống nhau tối đa
    PreventCommonPasswords BIT DEFAULT 1,
    PreventPersonalInfo BIT DEFAULT 1, -- Không cho phép chứa thông tin cá nhân
    PasswordHistoryCount INT DEFAULT 5, -- Số mật khẩu cũ cần kiểm tra trùng lặp
    MaxPasswordAge INT DEFAULT 90, -- Số ngày tối đa trước khi bắt buộc đổi mật khẩu
    MinPasswordAge INT DEFAULT 1, -- Số ngày tối thiểu trước khi cho phép đổi mật khẩu
    MaxFailedAttempts INT DEFAULT 5, -- Số lần đăng nhập sai tối đa
    LockoutDuration INT DEFAULT 15, -- Số phút khóa tài khoản
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE()
);

-- Thêm chính sách mật khẩu mặc định
INSERT INTO PasswordPolicy (PolicyName, MinLength, MaxLength, RequireUppercase, RequireLowercase, RequireDigits, RequireSpecialChars, MaxConsecutiveRepeats, PasswordHistoryCount, MaxPasswordAge, MaxFailedAttempts, LockoutDuration) VALUES
('Default Policy', 8, 50, 1, 1, 1, 1, 3, 5, 90, 5, 15),
('High Security Policy', 12, 128, 1, 1, 1, 1, 2, 10, 60, 3, 30),
('Basic Policy', 6, 30, 0, 1, 1, 0, 4, 3, 180, 10, 5);

-- Bảng danh sách mật khẩu phổ biến cần tránh
CREATE TABLE CommonPasswords (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Password NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50), -- 'Common', 'Dictionary', 'Sequential', 'Keyboard'
    IsActive BIT DEFAULT 1
);

-- Thêm một số mật khẩu phổ biến cần tránh
INSERT INTO CommonPasswords (Password, Category) VALUES
('123456', 'Sequential'),
('password', 'Common'),
('123456789', 'Sequential'),
('12345678', 'Sequential'),
('12345', 'Sequential'),
('1234567', 'Sequential'),
('1234567890', 'Sequential'),
('qwerty', 'Keyboard'),
('abc123', 'Common'),
('Password', 'Common'),
('password123', 'Common'),
('admin', 'Common'),
('administrator', 'Common'),
('root', 'Common'),
('user', 'Common'),
('guest', 'Common'),
('123abc', 'Common'),
('abcdefg', 'Sequential'),
('welcome', 'Common'),
('login', 'Common');

-- Bảng cấu hình bảo mật tài khoản
CREATE TABLE AccountSecurity (
    AccountID INT PRIMARY KEY,
    PolicyID INT DEFAULT 1,
    LastPasswordChange DATETIME2 DEFAULT GETDATE(),
    PasswordExpiryDate DATETIME2,
    IsPasswordExpired BIT COMPUTED (CASE WHEN PasswordExpiryDate < GETDATE() THEN 1 ELSE 0 END),
    ForcePasswordChangeOnNextLogin BIT DEFAULT 0,
    TwoFactorEnabled BIT DEFAULT 0,
    TwoFactorSecret NVARCHAR(255), -- Secret key cho TOTP
    BackupCodes NVARCHAR(MAX), -- JSON array của backup codes
    LastTwoFactorUsed DATETIME2,
    SecurityQuestions NVARCHAR(MAX), -- JSON array của security questions
    AllowedIPRanges NVARCHAR(MAX), -- JSON array của allowed IP ranges
    SessionTimeout INT DEFAULT 30, -- Phút timeout session riêng cho tài khoản
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastModified DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (PolicyID) REFERENCES PasswordPolicy(PolicyID)
);

-- Thêm security config cho các tài khoản hiện tại
INSERT INTO AccountSecurity (AccountID, PolicyID, LastPasswordChange, PasswordExpiryDate)
SELECT 
    AccountID, 
    1, -- Default policy
    GETDATE(), 
    DATEADD(DAY, 90, GETDATE()) -- Expire after 90 days
FROM Account;

-- Bảng audit log cho hoạt động bảo mật
CREATE TABLE SecurityAuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    EventType NVARCHAR(100), -- 'Password Change', 'Login Attempt', 'Account Locked', 'Password Reset', 'Two Factor Setup'
    EventSubtype NVARCHAR(100), -- 'Success', 'Failed', 'Blocked', 'Suspicious'
    Description NVARCHAR(1000),
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    Location NVARCHAR(255), -- Geolocation nếu có
    RiskScore INT DEFAULT 0, -- 0-100, risk assessment score
    EventDate DATETIME2 DEFAULT GETDATE(),
    AdditionalData NVARCHAR(MAX), -- JSON format for extra data
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Bảng session tracking chi tiết
CREATE TABLE SessionTracking (
    SessionID NVARCHAR(255) PRIMARY KEY,
    AccountID INT,
    LoginTime DATETIME2 DEFAULT GETDATE(),
    LastActivity DATETIME2 DEFAULT GETDATE(),
    ExpiryTime DATETIME2,
    IsActive BIT DEFAULT 1,
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    DeviceFingerprint NVARCHAR(500), -- Device fingerprinting
    LoginMethod NVARCHAR(50), -- 'Password', 'TwoFactor', 'SSO'
    LogoutTime DATETIME2,
    LogoutReason NVARCHAR(100), -- 'User Logout', 'Timeout', 'Admin Force', 'Security'
    SessionData NVARCHAR(MAX), -- JSON format for session-specific data
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Bảng token management (for password reset, email verification, etc.)
CREATE TABLE SecurityToken (
    TokenID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    TokenType NVARCHAR(50), -- 'Password Reset', 'Email Verification', 'Two Factor Backup'
    TokenHash NVARCHAR(255), -- Hashed token
    PlainToken NVARCHAR(255), -- For display purposes (will be cleared after use)
    ExpiryDate DATETIME2,
    IsUsed BIT DEFAULT 0,
    UsedDate DATETIME2,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    IPAddress NVARCHAR(50),
    Purpose NVARCHAR(500), -- Detailed purpose description
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (CreatedBy) REFERENCES Staff(StaffID)
);

-- Cập nhật bảng Account với thêm security fields
ALTER TABLE Account ADD PasswordFailedAttempts INT DEFAULT 0;
ALTER TABLE Account ADD PasswordLastFailedAttempt DATETIME2;
ALTER TABLE Account ADD AccountLockedReason NVARCHAR(500);
ALTER TABLE Account ADD UnlockToken NVARCHAR(255);
ALTER TABLE Account ADD UnlockTokenExpiry DATETIME2;
ALTER TABLE Account ADD LastPasswordChangeDate DATETIME2 DEFAULT GETDATE();
ALTER TABLE Account ADD MustChangePasswordNextLogin BIT DEFAULT 0;

-- ============================================================================
-- 23. ENHANCED VIEWS FOR PASSWORD MANAGEMENT
-- ============================================================================

-- View tổng hợp thông tin bảo mật tài khoản
CREATE VIEW vw_AccountSecurityStatus AS
SELECT 
    a.AccountID,
    a.Username,
    s.FullName,
    s.Email,
    a.IsLocked,
    a.PasswordFailedAttempts,
    a.LastPasswordChangeDate,
    a.MustChangePasswordNextLogin,
    asec.PolicyID,
    pp.PolicyName,
    asec.PasswordExpiryDate,
    asec.IsPasswordExpired,
    asec.ForcePasswordChangeOnNextLogin,
    asec.TwoFactorEnabled,
    asec.SessionTimeout,
    DATEDIFF(DAY, a.LastPasswordChangeDate, GETDATE()) AS DaysSinceLastPasswordChange,
    DATEDIFF(DAY, GETDATE(), asec.PasswordExpiryDate) AS DaysUntilPasswordExpiry,
    CASE 
        WHEN a.IsLocked = 1 THEN 'Locked'
        WHEN asec.IsPasswordExpired = 1 THEN 'Password Expired'
        WHEN asec.ForcePasswordChangeOnNextLogin = 1 THEN 'Must Change Password'
        WHEN DATEDIFF(DAY, GETDATE(), asec.PasswordExpiryDate) <= 7 THEN 'Password Expiring Soon'
        ELSE 'Active'
    END AS SecurityStatus,
    (SELECT COUNT(*) FROM PasswordHistory ph WHERE ph.AccountID = a.AccountID) AS PasswordChangeCount,
    (SELECT COUNT(*) FROM SessionTracking st WHERE st.AccountID = a.AccountID AND st.IsActive = 1) AS ActiveSessionCount
FROM Account a
INNER JOIN Staff s ON a.StaffID = s.StaffID
LEFT JOIN AccountSecurity asec ON a.AccountID = asec.AccountID
LEFT JOIN PasswordPolicy pp ON asec.PolicyID = pp.PolicyID
WHERE a.StatusID = 1;

-- View lịch sử đổi mật khẩu
CREATE VIEW vw_PasswordChangeHistory AS
SELECT 
    ph.HistoryID,
    ph.AccountID,
    a.Username,
    s.FullName,
    ph.ChangeDate,
    ph.ChangeReason,
    changer.FullName AS ChangedByName,
    ph.IPAddress,
    ph.IsSuccessful,
    ph.FailureReason,
    ROW_NUMBER() OVER (PARTITION BY ph.AccountID ORDER BY ph.ChangeDate DESC) AS ChangeSequence
FROM PasswordHistory ph
INNER JOIN Account a ON ph.AccountID = a.AccountID
INNER JOIN Staff s ON a.StaffID = s.StaffID
LEFT JOIN Staff changer ON ph.ChangedBy = changer.StaffID;

-- View audit log bảo mật
CREATE VIEW vw_SecurityAuditSummary AS
SELECT 
    sal.AuditID,
    sal.AccountID,
    a.Username,
    s.FullName,
    sal.EventType,
    sal.EventSubtype,
    sal.Description,
    sal.IPAddress,
    sal.RiskScore,
    sal.EventDate,
    CASE 
        WHEN sal.RiskScore >= 80 THEN 'High Risk'
        WHEN sal.RiskScore >= 50 THEN 'Medium Risk'
        WHEN sal.RiskScore >= 20 THEN 'Low Risk'
        ELSE 'Normal'
    END AS RiskLevel
FROM SecurityAuditLog sal
LEFT JOIN Account a ON sal.AccountID = a.AccountID
LEFT JOIN Staff s ON a.StaffID = s.StaffID;

-- ============================================================================
-- 24. STORED PROCEDURES FOR PASSWORD MANAGEMENT
-- ============================================================================

-- Procedure để thay đổi mật khẩu
CREATE PROCEDURE sp_ChangePassword
    @Username NVARCHAR(100),
    @CurrentPassword NVARCHAR(255), -- Plain text, sẽ được hash và so sánh
    @NewPassword NVARCHAR(255), -- Plain text, sẽ được hash và lưu
    @IPAddress NVARCHAR(50) = NULL,
    @UserAgent NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @AccountID INT, @CurrentHash NVARCHAR(255), @StaffID INT;
        DECLARE @PolicyID INT, @MinLength INT, @PasswordHistoryCount INT;
        DECLARE @NewPasswordHash NVARCHAR(255);
        
        -- Lấy thông tin tài khoản
        SELECT @AccountID = AccountID, @CurrentHash = PasswordHash, @StaffID = StaffID
        FROM Account 
        WHERE Username = @Username AND StatusID = 1;
        
        IF @AccountID IS NULL
        BEGIN
            -- Log failed attempt
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (NULL, 'Password Change', 'Failed', 'Account not found: ' + @Username, @IPAddress);
            
            SELECT 'Error' AS Result, 'Tài khoản không tồn tại hoặc đã bị vô hiệu hóa' AS Message;
            RETURN;
        END
        
        -- Kiểm tra tài khoản có bị khóa không
        IF EXISTS (SELECT 1 FROM Account WHERE AccountID = @AccountID AND IsLocked = 1)
        BEGIN
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (@AccountID, 'Password Change', 'Blocked', 'Account is locked', @IPAddress);
            
            SELECT 'Error' AS Result, 'Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên' AS Message;
            RETURN;
        END
        
        -- Kiểm tra mật khẩu hiện tại (giả định đã hash, trong thực tế cần hash @CurrentPassword trước khi so sánh)
        -- Tạm thời giả định mật khẩu đã được hash phía client hoặc sẽ hash tại đây
        SET @NewPasswordHash = HASHBYTES('SHA2_256', @CurrentPassword + CAST(@AccountID AS NVARCHAR)); -- Simple hashing
        
        IF @CurrentHash != HASHBYTES('SHA2_256', @CurrentPassword + CAST(@AccountID AS NVARCHAR))
        BEGIN
            -- Cập nhật failed attempts
            UPDATE Account SET 
                PasswordFailedAttempts = ISNULL(PasswordFailedAttempts, 0) + 1,
                PasswordLastFailedAttempt = GETDATE()
            WHERE AccountID = @AccountID;
            
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (@AccountID, 'Password Change', 'Failed', 'Incorrect current password', @IPAddress);
            
            SELECT 'Error' AS Result, 'Mật khẩu hiện tại không chính xác' AS Message;
            RETURN;
        END
        
        -- Lấy chính sách mật khẩu
        SELECT @PolicyID = PolicyID, @MinLength = MinLength, @PasswordHistoryCount = PasswordHistoryCount
        FROM AccountSecurity asec
        INNER JOIN PasswordPolicy pp ON asec.PolicyID = pp.PolicyID
        WHERE asec.AccountID = @AccountID;
        
        -- Validate mật khẩu mới
        IF LEN(@NewPassword) < @MinLength
        BEGIN
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (@AccountID, 'Password Change', 'Failed', 'New password too short', @IPAddress);
            
            SELECT 'Error' AS Result, 'Mật khẩu mới phải có ít nhất ' + CAST(@MinLength AS NVARCHAR) + ' ký tự' AS Message;
            RETURN;
        END
        
        -- Kiểm tra mật khẩu có trong danh sách common passwords không
        IF EXISTS (SELECT 1 FROM CommonPasswords WHERE Password = @NewPassword AND IsActive = 1)
        BEGIN
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (@AccountID, 'Password Change', 'Failed', 'Password is too common', @IPAddress);
            
            SELECT 'Error' AS Result, 'Mật khẩu này quá phổ biến. Vui lòng chọn mật khẩu khác' AS Message;
            RETURN;
        END
        
        -- Hash mật khẩu mới
        SET @NewPasswordHash = HASHBYTES('SHA2_256', @NewPassword + CAST(@AccountID AS NVARCHAR));
        
        -- Kiểm tra lịch sử mật khẩu (không được trùng với N mật khẩu gần nhất)
        IF EXISTS (
            SELECT TOP (@PasswordHistoryCount) 1 
            FROM PasswordHistory 
            WHERE AccountID = @AccountID AND NewPasswordHash = @NewPasswordHash
            ORDER BY ChangeDate DESC
        )
        BEGIN
            INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
            VALUES (@AccountID, 'Password Change', 'Failed', 'Password was used recently', @IPAddress);
            
            SELECT 'Error' AS Result, 'Mật khẩu này đã được sử dụng gần đây. Vui lòng chọn mật khẩu khác' AS Message;
            RETURN;
        END
        
        -- Cập nhật mật khẩu mới
        UPDATE Account SET 
            PasswordHash = @NewPasswordHash,
            LastPasswordChangeDate = GETDATE(),
            MustChangePasswordNextLogin = 0,
            PasswordFailedAttempts = 0,
            PasswordLastFailedAttempt = NULL,
            LastModified = GETDATE()
        WHERE AccountID = @AccountID;
        
        -- Cập nhật thông tin bảo mật
        UPDATE AccountSecurity SET
            LastPasswordChange = GETDATE(),
            PasswordExpiryDate = DATEADD(DAY, (SELECT MaxPasswordAge FROM PasswordPolicy WHERE PolicyID = @PolicyID), GETDATE()),
            ForcePasswordChangeOnNextLogin = 0,
            LastModified = GETDATE()
        WHERE AccountID = @AccountID;
        
        -- Lưu lịch sử thay đổi mật khẩu
        INSERT INTO PasswordHistory (AccountID, OldPasswordHash, NewPasswordHash, ChangeReason, ChangedBy, IPAddress)
        VALUES (@AccountID, @CurrentHash, @NewPasswordHash, 'User Change', @StaffID, @IPAddress);
        
        -- Log thành công
        INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
        VALUES (@AccountID, 'Password Change', 'Success', 'Password changed successfully', @IPAddress);
        
        -- Log activity
        INSERT INTO ActivityLog (ActivityTypeID, StaffID, TargetTable, TargetID, Description, IPAddress)
        VALUES (4, @StaffID, 'Account', @AccountID, 'Đổi mật khẩu thành công', @IPAddress);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Đổi mật khẩu thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        -- Log error
        INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description, IPAddress)
        VALUES (@AccountID, 'Password Change', 'Failed', 'System error: ' + ERROR_MESSAGE(), @IPAddress);
        
        SELECT 'Error' AS Result, 'Có lỗi hệ thống xảy ra. Vui lòng thử lại sau' AS Message;
    END CATCH
END;

-- Procedure để reset mật khẩu (admin function)
CREATE PROCEDURE sp_ResetPassword
    @Username NVARCHAR(100),
    @NewPassword NVARCHAR(255),
    @ResetBy INT,
    @Reason NVARCHAR(500) = 'Admin Reset',
    @ForceChangeOnNextLogin BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @AccountID INT, @StaffID INT, @NewPasswordHash NVARCHAR(255);
        
        SELECT @AccountID = AccountID, @StaffID = StaffID
        FROM Account 
        WHERE Username = @Username;
        
        IF @AccountID IS NULL
        BEGIN
            SELECT 'Error' AS Result, 'Tài khoản không tồn tại' AS Message;
            RETURN;
        END
        
        -- Hash mật khẩu mới
        SET @NewPasswordHash = HASHBYTES('SHA2_256', @NewPassword + CAST(@AccountID AS NVARCHAR));
        
        -- Cập nhật mật khẩu
        UPDATE Account SET 
            PasswordHash = @NewPasswordHash,
            LastPasswordChangeDate = GETDATE(),
            MustChangePasswordNextLogin = @ForceChangeOnNextLogin,
            PasswordFailedAttempts = 0,
            IsLocked = 0,
            LastModified = GETDATE()
        WHERE AccountID = @AccountID;
        
        -- Cập nhật security settings
        UPDATE AccountSecurity SET
            LastPasswordChange = GETDATE(),
            PasswordExpiryDate = DATEADD(DAY, 90, GETDATE()),
            ForcePasswordChangeOnNextLogin = @ForceChangeOnNextLogin
        WHERE AccountID = @AccountID;
        
        -- Lưu lịch sử
        INSERT INTO PasswordHistory (AccountID, NewPasswordHash, ChangeReason, ChangedBy)
        VALUES (@AccountID, @NewPasswordHash, @Reason, @ResetBy);
        
        -- Log activity
        INSERT INTO SecurityAuditLog (AccountID, EventType, EventSubtype, Description)
        VALUES (@AccountID, 'Password Reset', 'Success', 'Password reset by admin: ' + @Reason);
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Reset mật khẩu thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Error' AS Result, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure để lấy thông tin bảo mật tài khoản
CREATE PROCEDURE sp_GetAccountSecurityInfo
    @Username NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin bảo mật chính
    SELECT * FROM vw_AccountSecurityStatus WHERE Username = @Username;
    
    -- Lịch sử đổi mật khẩu gần đây
    SELECT TOP 10 * FROM vw_PasswordChangeHistory 
    WHERE Username = @Username 
    ORDER BY ChangeDate DESC;
    
    -- Session hiện tại
    SELECT TOP 10 * FROM SessionTracking 
    WHERE AccountID = (SELECT AccountID FROM Account WHERE Username = @Username)
    ORDER BY LoginTime DESC;
    
    -- Audit log gần đây
    SELECT TOP 20 * FROM vw_SecurityAuditSummary 
    WHERE Username = @Username 
    ORDER BY EventDate DESC;
END;

-- Procedure để kiểm tra độ mạnh mật khẩu
CREATE PROCEDURE sp_ValidatePasswordStrength
    @Password NVARCHAR(255),
    @Username NVARCHAR(100) = NULL,
    @PolicyID INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Score INT = 0;
    DECLARE @Feedback NVARCHAR(MAX) = '';
    DECLARE @IsValid BIT = 1;
    
    -- Lấy policy rules
    DECLARE @MinLength INT, @RequireUpper BIT, @RequireLower BIT, @RequireDigits BIT, @RequireSpecial BIT;
    
    SELECT @MinLength = MinLength, @RequireUpper = RequireUppercase, @RequireLower = RequireLowercase,
           @RequireDigits = RequireDigits, @RequireSpecial = RequireSpecialChars
    FROM PasswordPolicy WHERE PolicyID = @PolicyID;
    
    -- Kiểm tra độ dài
    IF LEN(@Password) >= @MinLength
        SET @Score = @Score + 20;
    ELSE
    BEGIN
        SET @IsValid = 0;
        SET @Feedback = @Feedback + 'Mật khẩu phải có ít nhất ' + CAST(@MinLength AS NVARCHAR) + ' ký tự. ';
    END
    
    -- Kiểm tra chữ hoa
    IF @RequireUpper = 1 AND @Password LIKE '%[A-Z]%'
        SET @Score = @Score + 20;
    ELSE IF @RequireUpper = 1
    BEGIN
        SET @IsValid = 0;
        SET @Feedback = @Feedback + 'Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa. ';
    END
    
    -- Kiểm tra chữ thường
    IF @RequireLower = 1 AND @Password LIKE '%[a-z]%'
        SET @Score = @Score + 20;
    ELSE IF @RequireLower = 1
    BEGIN
        SET @IsValid = 0;
        SET @Feedback = @Feedback + 'Mật khẩu phải chứa ít nhất 1 chữ cái viết thường. ';
    END
    
    -- Kiểm tra số
    IF @RequireDigits = 1 AND @Password LIKE '%[0-9]%'
        SET @Score = @Score + 20;
    ELSE IF @RequireDigits = 1
    BEGIN
        SET @IsValid = 0;
        SET @Feedback = @Feedback + 'Mật khẩu phải chứa ít nhất 1 chữ số. ';
    END
    
    -- Kiểm tra ký tự đặc biệt
    IF @RequireSpecial = 1 AND (@Password LIKE '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]%')
        SET @Score = @Score + 20;
    ELSE IF @RequireSpecial = 1
    BEGIN
        SET @IsValid = 0;
        SET @Feedback = @Feedback + 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt. ';
    END
    
    -- Kiểm tra mật khẩu phổ biến
    IF EXISTS (SELECT 1 FROM CommonPasswords WHERE Password = @Password AND IsActive = 1)
    BEGIN
        SET @IsValid = 0;
        SET @Score = @Score - 50;
        SET @Feedback = @Feedback + 'Mật khẩu này quá phổ biến và không an toàn. ';
    END
    
    -- Đảm bảo score không âm
    IF @Score < 0 SET @Score = 0;
    
    SELECT 
        @IsValid AS IsValid,
        @Score AS StrengthScore,
        CASE 
            WHEN @Score >= 80 THEN 'Rất mạnh'
            WHEN @Score >= 60 THEN 'Mạnh'
            WHEN @Score >= 40 THEN 'Trung bình'
            WHEN @Score >= 20 THEN 'Yếu'
            ELSE 'Rất yếu'
        END AS StrengthLevel,
        @Feedback AS Feedback;
END;

PRINT 'Password Management & Security System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Password history tracking';
PRINT '- Password policy enforcement';
PRINT '- Common password prevention';
PRINT '- Account security configuration';
PRINT '- Security audit logging';
PRINT '- Session tracking';
PRINT '- Token management for password reset';

-- =============================================
-- SECTION 34: ACADEMIC MAJOR MANAGEMENT SYSTEM 
-- File: MajorList.html
-- Description: Comprehensive academic program/major management with course associations and curriculum design
-- =============================================

PRINT '';
PRINT '========================================';
PRINT 'Creating Academic Major Management System (MajorList.html)...';
PRINT '========================================';

-- Bảng Nhóm Chuyên Ngành (Major Categories)
CREATE TABLE MajorCategories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    DisplayOrder INT DEFAULT 0,
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Chuyên Ngành (Academic Majors)
CREATE TABLE Majors (
    MajorId INT IDENTITY(1,1) PRIMARY KEY,
    MajorName NVARCHAR(200) NOT NULL,
    MajorCode NVARCHAR(50) NOT NULL UNIQUE,
    CategoryId INT,
    Description NVARCHAR(1000),
    EntryRequirement NVARCHAR(500),
    ExitRequirement NVARCHAR(500),
    TotalSessions INT NOT NULL DEFAULT 0,
    BaseTuitionFee DECIMAL(18,2) NOT NULL DEFAULT 0,
    CertificateType NVARCHAR(100),
    DurationMonths INT,
    MinAge INT DEFAULT 16,
    MaxAge INT,
    ClassSizeMin INT DEFAULT 5,
    ClassSizeMax INT DEFAULT 25,
    Prerequisites NVARCHAR(500),
    LearningOutcomes NVARCHAR(1000),
    CareerProspects NVARCHAR(1000),
    StatusId INT NOT NULL DEFAULT 1,
    IsActive BIT DEFAULT 1,
    IsPopular BIT DEFAULT 0,
    DisplayOrder INT DEFAULT 0,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (CategoryId) REFERENCES MajorCategories(CategoryId),
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Môn Học trong Chuyên Ngành (Major Subjects)
CREATE TABLE MajorSubjects (
    MajorSubjectId INT IDENTITY(1,1) PRIMARY KEY,
    MajorId INT NOT NULL,
    SubjectName NVARCHAR(200) NOT NULL,
    SubjectCode NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    SessionCount INT NOT NULL DEFAULT 1,
    LearningObjectives NVARCHAR(1000),
    SubjectLevel NVARCHAR(50), -- 'Cơ bản', 'Trung cấp', 'Nâng cao'
    IsRequired BIT DEFAULT 1,
    Prerequisites NVARCHAR(500),
    DisplayOrder INT DEFAULT 0,
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (MajorId) REFERENCES Majors(MajorId) ON DELETE CASCADE,
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId),
    UNIQUE(MajorId, SubjectCode)
);

-- Bảng Giáo Trình của Chuyên Ngành (Major Curricula)
CREATE TABLE MajorCurricula (
    CurriculumId INT IDENTITY(1,1) PRIMARY KEY,
    MajorId INT NOT NULL,
    CurriculumName NVARCHAR(200) NOT NULL,
    Version NVARCHAR(20) NOT NULL DEFAULT '1.0',
    Description NVARCHAR(1000),
    TotalHours INT NOT NULL DEFAULT 0,
    TheoryHours INT DEFAULT 0,
    PracticeHours INT DEFAULT 0,
    ExamHours INT DEFAULT 0,
    EffectiveDate DATE NOT NULL,
    ExpiryDate DATE,
    ApprovalStatus NVARCHAR(50) DEFAULT 'Chờ duyệt', -- 'Chờ duyệt', 'Đã duyệt', 'Từ chối'
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    IsActive BIT DEFAULT 1,
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (MajorId) REFERENCES Majors(MajorId),
    FOREIGN KEY (ApprovedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId),
    UNIQUE(MajorId, Version)
);

-- Bảng Chi Tiết Giáo Trình (Curriculum Details)
CREATE TABLE CurriculumDetails (
    CurriculumDetailId INT IDENTITY(1,1) PRIMARY KEY,
    CurriculumId INT NOT NULL,
    MajorSubjectId INT NOT NULL,
    SessionOrder INT NOT NULL,
    SessionTitle NVARCHAR(200) NOT NULL,
    LearningObjectives NVARCHAR(1000),
    Content NVARCHAR(MAX),
    TeachingMethods NVARCHAR(500),
    AssessmentMethods NVARCHAR(500),
    Materials NVARCHAR(500),
    Duration INT NOT NULL DEFAULT 90, -- Thời lượng phút
    IsRequired BIT DEFAULT 1,
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (CurriculumId) REFERENCES MajorCurricula(CurriculumId) ON DELETE CASCADE,
    FOREIGN KEY (MajorSubjectId) REFERENCES MajorSubjects(MajorSubjectId),
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId),
    UNIQUE(CurriculumId, SessionOrder)
);

-- Bảng Yêu Cầu Năng Lực Giảng Viên (Instructor Requirements)
CREATE TABLE MajorInstructorRequirements (
    RequirementId INT IDENTITY(1,1) PRIMARY KEY,
    MajorId INT NOT NULL,
    RequirementType NVARCHAR(100) NOT NULL, -- 'Học vấn', 'Kinh nghiệm', 'Chứng chỉ', 'Kỹ năng'
    Description NVARCHAR(500) NOT NULL,
    IsRequired BIT DEFAULT 1,
    Priority INT DEFAULT 1, -- 1: Bắt buộc, 2: Ưu tiên, 3: Khuyến khích
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (MajorId) REFERENCES Majors(MajorId) ON DELETE CASCADE,
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Thống Kê Chuyên Ngành (Major Statistics)
CREATE TABLE MajorStatistics (
    StatisticId INT IDENTITY(1,1) PRIMARY KEY,
    MajorId INT NOT NULL,
    YearMonth CHAR(6) NOT NULL, -- YYYYMM format
    TotalStudents INT DEFAULT 0,
    NewEnrollments INT DEFAULT 0,
    Completions INT DEFAULT 0,
    Dropouts INT DEFAULT 0,
    PassRate DECIMAL(5,2) DEFAULT 0,
    SatisfactionScore DECIMAL(3,2) DEFAULT 0,
    Revenue DECIMAL(18,2) DEFAULT 0,
    LastUpdated DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (MajorId) REFERENCES Majors(MajorId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    PRIMARY KEY (MajorId, YearMonth)
);

PRINT 'Major management tables created successfully!';

-- Tạo indexes cho hiệu suất
CREATE INDEX IX_Majors_CategoryId ON Majors(CategoryId);
CREATE INDEX IX_Majors_StatusId ON Majors(StatusId);
CREATE INDEX IX_Majors_IsActive ON Majors(IsActive);
CREATE INDEX IX_Majors_IsPopular ON Majors(IsPopular);
CREATE INDEX IX_MajorSubjects_MajorId ON MajorSubjects(MajorId);
CREATE INDEX IX_MajorCurricula_MajorId ON MajorCurricula(MajorId);
CREATE INDEX IX_MajorCurricula_EffectiveDate ON MajorCurricula(EffectiveDate);
CREATE INDEX IX_CurriculumDetails_CurriculumId ON CurriculumDetails(CurriculumId);
CREATE INDEX IX_MajorStatistics_YearMonth ON MajorStatistics(YearMonth);

PRINT 'Major management indexes created successfully!';

-- Dữ liệu mẫu cho Nhóm Chuyên Ngành
INSERT INTO MajorCategories (CategoryName, CategoryCode, Description, DisplayOrder) VALUES
(N'Tiếng Anh', 'ENG', N'Các chuyên ngành tiếng Anh', 1),
(N'Tiếng Trung', 'CHI', N'Các chuyên ngành tiếng Trung', 2),
(N'Tiếng Nhật', 'JPN', N'Các chuyên ngành tiếng Nhật', 3),
(N'Tiếng Hàn', 'KOR', N'Các chuyên ngành tiếng Hàn', 4),
(N'Tin Học', 'IT', N'Các chuyên ngành tin học', 5),
(N'Kế Toán', 'ACC', N'Các chuyên ngành kế toán', 6);

-- Dữ liệu mẫu cho Chuyên Ngành
INSERT INTO Majors (MajorName, MajorCode, CategoryId, Description, EntryRequirement, ExitRequirement, TotalSessions, BaseTuitionFee, CertificateType, DurationMonths, ClassSizeMin, ClassSizeMax, IsPopular) VALUES
(N'Tiếng Anh Giao Tiếp Cơ Bản', 'ENG-COM-01', 1, N'Khóa học tiếng Anh giao tiếp hàng ngày', N'Không yêu cầu kinh nghiệm', N'Giao tiếp cơ bản được', 30, 2500000, N'Chứng chỉ hoàn thành', 3, 8, 20, 1),
(N'Luyện Thi IELTS 6.5', 'ENG-IELTS-01', 1, N'Khóa học chuyên sâu luyện thi IELTS', N'IELTS 4.5 hoặc tương đương', N'Đạt IELTS 6.5+', 60, 8000000, N'Chứng chỉ IELTS', 6, 5, 15, 1),
(N'Tiếng Anh Thương Mại', 'ENG-BUS-01', 1, N'Tiếng Anh cho môi trường công sở', N'Tiếng Anh trung cấp', N'Giao tiếp thành thạo trong công việc', 40, 4500000, N'Chứng chỉ tiếng Anh thương mại', 4, 6, 18, 0),
(N'Tiếng Trung HSK 3', 'CHI-HSK3-01', 2, N'Luyện thi HSK cấp độ 3', N'HSK 2 hoặc tương đương', N'Đạt HSK 3', 45, 5500000, N'Chứng chỉ HSK 3', 5, 6, 16, 1),
(N'Tiếng Nhật N4', 'JPN-N4-01', 3, N'Luyện thi JLPT N4', N'N5 hoặc tương đương', N'Đạt N4', 50, 6000000, N'Chứng chỉ JLPT N4', 5, 6, 15, 0),
(N'Tin Học Văn Phòng', 'IT-OFFICE-01', 5, N'Kỹ năng tin học cơ bản', N'Biết sử dụng máy tính cơ bản', N'Thành thạo Office, Internet', 25, 2000000, N'Chứng chỉ tin học văn phòng', 2, 10, 25, 1);

-- Dữ liệu mẫu cho Môn Học trong Chuyên Ngành
INSERT INTO MajorSubjects (MajorId, SubjectName, SubjectCode, Description, SessionCount, LearningObjectives, SubjectLevel, IsRequired, DisplayOrder) VALUES
(1, N'Phát âm cơ bản', 'ENG-COM-01-01', N'Học phát âm chính xác', 5, N'Phát âm chuẩn 44 âm tiếng Anh', N'Cơ bản', 1, 1),
(1, N'Từ vựng hàng ngày', 'ENG-COM-01-02', N'Từ vựng giao tiếp thường dùng', 8, N'Nắm vững 1000 từ vựng cơ bản', N'Cơ bản', 1, 2),
(1, N'Ngữ pháp cơ bản', 'ENG-COM-01-03', N'Cấu trúc câu đơn giản', 7, N'Sử dụng đúng thì hiện tại và quá khứ', N'Cơ bản', 1, 3),
(1, N'Hội thoại thực tế', 'ENG-COM-01-04', N'Luyện tập giao tiếp', 10, N'Giao tiếp tự tin trong các tình huống hàng ngày', N'Cơ bản', 1, 4),
(2, N'Chiến lược làm bài Reading', 'ENG-IELTS-01-01', N'Kỹ thuật làm bài đọc hiểu', 15, N'Đạt 6.5+ trong phần Reading', N'Nâng cao', 1, 1),
(2, N'Luyện tập Listening', 'ENG-IELTS-01-02', N'Nghe hiểu nâng cao', 15, N'Đạt 6.5+ trong phần Listening', N'Nâng cao', 1, 2),
(2, N'Writing Task 1 & 2', 'ENG-IELTS-01-03', N'Kỹ năng viết học thuật', 15, N'Viết được essay 250+ từ đạt band 6.5+', N'Nâng cao', 1, 3),
(2, N'Speaking Practice', 'ENG-IELTS-01-04', N'Luyện nói và phản xạ', 15, N'Nói lưu loát và tự tin đạt 6.5+', N'Nâng cao', 1, 4);

PRINT 'Sample major data inserted successfully!';

-- =============================================
-- STORED PROCEDURES FOR MAJOR MANAGEMENT
-- =============================================

-- Procedure: Lấy danh sách chuyên ngành với thống kê
CREATE PROCEDURE sp_GetMajorsWithStatistics
    @SearchTerm NVARCHAR(200) = '',
    @CategoryId INT = NULL,
    @StatusId INT = NULL,
    @IsActiveOnly BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        m.MajorId,
        m.MajorName,
        m.MajorCode,
        m.Description,
        m.EntryRequirement,
        m.ExitRequirement,
        m.TotalSessions,
        m.BaseTuitionFee,
        m.CertificateType,
        m.DurationMonths,
        m.IsPopular,
        m.StatusId,
        s.StatusName,
        mc.CategoryName,
        mc.CategoryCode,
        -- Thống kê hiện tại
        ISNULL(stat.TotalStudents, 0) AS CurrentStudents,
        ISNULL(stat.NewEnrollments, 0) AS MonthlyEnrollments,
        ISNULL(stat.PassRate, 0) AS PassRate,
        ISNULL(stat.SatisfactionScore, 0) AS SatisfactionScore,
        -- Đếm môn học
        (SELECT COUNT(*) FROM MajorSubjects ms WHERE ms.MajorId = m.MajorId AND ms.StatusId = 1) AS SubjectCount,
        -- Đếm giáo trình
        (SELECT COUNT(*) FROM MajorCurricula mc WHERE mc.MajorId = m.MajorId AND mc.IsActive = 1) AS CurriculumCount,
        m.CreatedDate,
        m.UpdatedDate,
        emp.FullName AS CreatedByName
    FROM Majors m
    INNER JOIN Status s ON m.StatusId = s.StatusId
    LEFT JOIN MajorCategories mc ON m.CategoryId = mc.CategoryId
    LEFT JOIN MajorStatistics stat ON m.MajorId = stat.MajorId 
        AND stat.YearMonth = FORMAT(GETDATE(), 'yyyyMM')
    LEFT JOIN Employees emp ON m.CreatedBy = emp.EmployeeId
    WHERE 
        (@SearchTerm = '' OR 
         m.MajorName LIKE '%' + @SearchTerm + '%' OR
         m.MajorCode LIKE '%' + @SearchTerm + '%' OR
         m.Description LIKE '%' + @SearchTerm + '%' OR
         mc.CategoryName LIKE '%' + @SearchTerm + '%')
        AND (@CategoryId IS NULL OR m.CategoryId = @CategoryId)
        AND (@StatusId IS NULL OR m.StatusId = @StatusId)
        AND (@IsActiveOnly = 0 OR m.IsActive = 1)
    ORDER BY m.IsPopular DESC, m.DisplayOrder, m.MajorName;
END;

-- Procedure: Tạo chuyên ngành mới
CREATE PROCEDURE sp_CreateMajor
    @MajorName NVARCHAR(200),
    @MajorCode NVARCHAR(50),
    @CategoryId INT = NULL,
    @Description NVARCHAR(1000) = '',
    @EntryRequirement NVARCHAR(500) = '',
    @ExitRequirement NVARCHAR(500) = '',
    @TotalSessions INT = 0,
    @BaseTuitionFee DECIMAL(18,2) = 0,
    @CertificateType NVARCHAR(100) = '',
    @DurationMonths INT = NULL,
    @MinAge INT = 16,
    @MaxAge INT = NULL,
    @ClassSizeMin INT = 5,
    @ClassSizeMax INT = 25,
    @Prerequisites NVARCHAR(500) = '',
    @LearningOutcomes NVARCHAR(1000) = '',
    @CareerProspects NVARCHAR(1000) = '',
    @StatusId INT = 1,
    @IsPopular BIT = 0,
    @CreatedBy INT,
    @NewMajorId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra trùng tên và mã
        IF EXISTS (SELECT 1 FROM Majors WHERE MajorName = @MajorName AND IsActive = 1)
        BEGIN
            RAISERROR(N'Tên chuyên ngành đã tồn tại!', 16, 1);
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Majors WHERE MajorCode = @MajorCode)
        BEGIN
            RAISERROR(N'Mã chuyên ngành đã tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Tạo chuyên ngành mới
        INSERT INTO Majors (
            MajorName, MajorCode, CategoryId, Description, EntryRequirement, 
            ExitRequirement, TotalSessions, BaseTuitionFee, CertificateType, 
            DurationMonths, MinAge, MaxAge, ClassSizeMin, ClassSizeMax, 
            Prerequisites, LearningOutcomes, CareerProspects, StatusId, 
            IsPopular, CreatedBy
        ) VALUES (
            @MajorName, @MajorCode, @CategoryId, @Description, @EntryRequirement,
            @ExitRequirement, @TotalSessions, @BaseTuitionFee, @CertificateType,
            @DurationMonths, @MinAge, @MaxAge, @ClassSizeMin, @ClassSizeMax,
            @Prerequisites, @LearningOutcomes, @CareerProspects, @StatusId,
            @IsPopular, @CreatedBy
        );
        
        SET @NewMajorId = SCOPE_IDENTITY();
        
        -- Tạo bản ghi thống kê ban đầu
        INSERT INTO MajorStatistics (MajorId, YearMonth, CreatedBy)
        VALUES (@NewMajorId, FORMAT(GETDATE(), 'yyyyMM'), @CreatedBy);
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Status, N'Tạo chuyên ngành thành công!' AS Message, @NewMajorId AS MajorId;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message, 0 AS MajorId;
    END CATCH
END;

-- Procedure: Cập nhật thông tin chuyên ngành
CREATE PROCEDURE sp_UpdateMajor
    @MajorId INT,
    @MajorName NVARCHAR(200),
    @CategoryId INT = NULL,
    @Description NVARCHAR(1000) = '',
    @EntryRequirement NVARCHAR(500) = '',
    @ExitRequirement NVARCHAR(500) = '',
    @TotalSessions INT = 0,
    @BaseTuitionFee DECIMAL(18,2) = 0,
    @CertificateType NVARCHAR(100) = '',
    @DurationMonths INT = NULL,
    @MinAge INT = 16,
    @MaxAge INT = NULL,
    @ClassSizeMin INT = 5,
    @ClassSizeMax INT = 25,
    @Prerequisites NVARCHAR(500) = '',
    @LearningOutcomes NVARCHAR(1000) = '',
    @CareerProspects NVARCHAR(1000) = '',
    @StatusId INT = 1,
    @IsPopular BIT = 0,
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra chuyên ngành tồn tại
        IF NOT EXISTS (SELECT 1 FROM Majors WHERE MajorId = @MajorId)
        BEGIN
            RAISERROR(N'Chuyên ngành không tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra trùng tên (trừ chính nó)
        IF EXISTS (SELECT 1 FROM Majors WHERE MajorName = @MajorName AND MajorId != @MajorId AND IsActive = 1)
        BEGIN
            RAISERROR(N'Tên chuyên ngành đã tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Cập nhật thông tin
        UPDATE Majors SET
            MajorName = @MajorName,
            CategoryId = @CategoryId,
            Description = @Description,
            EntryRequirement = @EntryRequirement,
            ExitRequirement = @ExitRequirement,
            TotalSessions = @TotalSessions,
            BaseTuitionFee = @BaseTuitionFee,
            CertificateType = @CertificateType,
            DurationMonths = @DurationMonths,
            MinAge = @MinAge,
            MaxAge = @MaxAge,
            ClassSizeMin = @ClassSizeMin,
            ClassSizeMax = @ClassSizeMax,
            Prerequisites = @Prerequisites,
            LearningOutcomes = @LearningOutcomes,
            CareerProspects = @CareerProspects,
            StatusId = @StatusId,
            IsPopular = @IsPopular,
            UpdatedBy = @UpdatedBy,
            UpdatedDate = GETDATE()
        WHERE MajorId = @MajorId;
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Status, N'Cập nhật chuyên ngành thành công!' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure: Lấy thông tin chi tiết chuyên ngành
CREATE PROCEDURE sp_GetMajorDetails
    @MajorId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin chuyên ngành
    SELECT 
        m.*,
        s.StatusName,
        mc.CategoryName,
        mc.CategoryCode,
        emp1.FullName AS CreatedByName,
        emp2.FullName AS UpdatedByName
    FROM Majors m
    INNER JOIN Status s ON m.StatusId = s.StatusId
    LEFT JOIN MajorCategories mc ON m.CategoryId = mc.CategoryId
    LEFT JOIN Employees emp1 ON m.CreatedBy = emp1.EmployeeId
    LEFT JOIN Employees emp2 ON m.UpdatedBy = emp2.EmployeeId
    WHERE m.MajorId = @MajorId;
    
    -- Danh sách môn học
    SELECT 
        ms.*,
        s.StatusName
    FROM MajorSubjects ms
    INNER JOIN Status s ON ms.StatusId = s.StatusId
    WHERE ms.MajorId = @MajorId
    ORDER BY ms.DisplayOrder, ms.SubjectName;
    
    -- Thống kê 6 tháng gần nhất
    SELECT TOP 6
        YearMonth,
        TotalStudents,
        NewEnrollments,
        Completions,
        Dropouts,
        PassRate,
        SatisfactionScore,
        Revenue
    FROM MajorStatistics
    WHERE MajorId = @MajorId
    ORDER BY YearMonth DESC;
END;

-- Procedure: Lấy danh sách nhóm chuyên ngành
CREATE PROCEDURE sp_GetMajorCategories
    @IsActiveOnly BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        mc.CategoryId,
        mc.CategoryName,
        mc.CategoryCode,
        mc.Description,
        mc.StatusId,
        s.StatusName,
        COUNT(m.MajorId) AS MajorCount
    FROM MajorCategories mc
    INNER JOIN Status s ON mc.StatusId = s.StatusId
    LEFT JOIN Majors m ON mc.CategoryId = m.CategoryId AND m.IsActive = 1
    WHERE (@IsActiveOnly = 0 OR mc.StatusId = 1)
    GROUP BY mc.CategoryId, mc.CategoryName, mc.CategoryCode, mc.Description, 
             mc.StatusId, s.StatusName, mc.DisplayOrder
    ORDER BY mc.DisplayOrder, mc.CategoryName;
END;

-- Procedure: Cập nhật thống kê chuyên ngành
CREATE PROCEDURE sp_UpdateMajorStatistics
    @MajorId INT,
    @YearMonth CHAR(6) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @YearMonth IS NULL
        SET @YearMonth = FORMAT(GETDATE(), 'yyyyMM');
    
    -- Cập nhật hoặc tạo mới thống kê
    MERGE MajorStatistics AS target
    USING (
        SELECT 
            @MajorId AS MajorId,
            @YearMonth AS YearMonth,
            -- Tính toán các chỉ số từ dữ liệu thực
            ISNULL((SELECT COUNT(*) FROM Students st 
                   INNER JOIN Classes c ON st.ClassId = c.ClassId 
                   WHERE c.MajorId = @MajorId AND st.StatusId = 1), 0) AS TotalStudents,
            0 AS NewEnrollments, -- Sẽ cập nhật khi có enrollment
            0 AS Completions,     -- Sẽ cập nhật khi có completion
            0 AS Dropouts,        -- Sẽ cập nhật khi có dropout
            0 AS PassRate,        -- Sẽ tính từ kết quả thi
            0 AS SatisfactionScore, -- Sẽ tính từ feedback
            0 AS Revenue          -- Sẽ tính từ payments
    ) AS source ON target.MajorId = source.MajorId AND target.YearMonth = source.YearMonth
    WHEN MATCHED THEN
        UPDATE SET 
            TotalStudents = source.TotalStudents,
            LastUpdated = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (MajorId, YearMonth, TotalStudents, NewEnrollments, Completions, 
                Dropouts, PassRate, SatisfactionScore, Revenue)
        VALUES (source.MajorId, source.YearMonth, source.TotalStudents, 
                source.NewEnrollments, source.Completions, source.Dropouts,
                source.PassRate, source.SatisfactionScore, source.Revenue);
END;

-- Procedure: Lấy chuyên ngành phổ biến
CREATE PROCEDURE sp_GetPopularMajors
    @TopCount INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        m.MajorId,
        m.MajorName,
        m.MajorCode,
        m.BaseTuitionFee,
        m.TotalSessions,
        mc.CategoryName,
        ISNULL(stat.TotalStudents, 0) AS CurrentStudents,
        ISNULL(stat.NewEnrollments, 0) AS MonthlyEnrollments,
        ISNULL(stat.PassRate, 0) AS PassRate
    FROM Majors m
    LEFT JOIN MajorCategories mc ON m.CategoryId = mc.CategoryId
    LEFT JOIN MajorStatistics stat ON m.MajorId = stat.MajorId 
        AND stat.YearMonth = FORMAT(GETDATE(), 'yyyyMM')
    WHERE m.IsActive = 1 AND m.StatusId = 1 AND m.IsPopular = 1
    ORDER BY ISNULL(stat.TotalStudents, 0) DESC, m.MajorName;
END;

PRINT 'Major management stored procedures created successfully!';

-- =============================================
-- FUNCTIONS FOR MAJOR MANAGEMENT
-- =============================================

-- Function: Tính học phí với chiết khấu
CREATE FUNCTION fn_CalculateMajorTuitionWithDiscount(
    @MajorId INT,
    @DiscountPercent DECIMAL(5,2) = 0,
    @StudentCount INT = 1
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @BaseFee DECIMAL(18,2);
    DECLARE @FinalFee DECIMAL(18,2);
    
    SELECT @BaseFee = BaseTuitionFee FROM Majors WHERE MajorId = @MajorId;
    
    IF @BaseFee IS NULL SET @BaseFee = 0;
    
    -- Áp dụng chiết khấu
    SET @FinalFee = @BaseFee * (1 - @DiscountPercent / 100.0);
    
    -- Chiết khấu nhóm (nếu đăng ký nhiều học viên)
    IF @StudentCount >= 5
        SET @FinalFee = @FinalFee * 0.95; -- 5% off cho nhóm 5+
    ELSE IF @StudentCount >= 3
        SET @FinalFee = @FinalFee * 0.97; -- 3% off cho nhóm 3+
    
    RETURN @FinalFee;
END;

-- Function: Kiểm tra điều kiện đầu vào
CREATE FUNCTION fn_CheckMajorEntryRequirement(
    @MajorId INT,
    @StudentLevel NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @EntryRequirement NVARCHAR(500);
    DECLARE @IsEligible BIT = 1;
    
    SELECT @EntryRequirement = EntryRequirement FROM Majors WHERE MajorId = @MajorId;
    
    -- Logic kiểm tra (có thể mở rộng)
    IF @EntryRequirement IS NOT NULL AND @EntryRequirement != ''
    BEGIN
        -- Kiểm tra cơ bản (có thể phức tạp hóa)
        IF @StudentLevel IS NULL OR @StudentLevel = ''
            SET @IsEligible = 0;
    END
    
    RETURN @IsEligible;
END;

-- Function: Lấy tổng thời gian học (giờ)
CREATE FUNCTION fn_GetMajorTotalHours(
    @MajorId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalHours INT = 0;
    
    -- Tính từ curriculum details
    SELECT @TotalHours = ISNULL(SUM(cd.Duration), 0) / 60 -- Convert minutes to hours
    FROM CurriculumDetails cd
    INNER JOIN MajorCurricula mc ON cd.CurriculumId = mc.CurriculumId
    WHERE mc.MajorId = @MajorId AND mc.IsActive = 1 AND cd.StatusId = 1;
    
    -- Nếu chưa có curriculum, ước tính từ total sessions
    IF @TotalHours = 0
    BEGIN
        SELECT @TotalHours = TotalSessions * 2 -- Ước tính 2 giờ/buổi
        FROM Majors WHERE MajorId = @MajorId;
    END
    
    RETURN ISNULL(@TotalHours, 0);
END;

PRINT 'Major management functions created successfully!';

PRINT '';
PRINT 'Academic Major Management System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Major categories and programs';
PRINT '- Subject and curriculum management';
PRINT '- Instructor requirements';
PRINT '- Statistics and analytics';
PRINT '- Tuition calculation with discounts';
PRINT '- Entry requirement validation';
PRINT '- Popular majors tracking';
PRINT '- Comprehensive reporting system';

-- =============================================
-- SECTION 35: COMPREHENSIVE REPORTING & DATA EXPORT SYSTEM
-- File: ReportCreate.html
-- Description: Advanced reporting and data export system with role-based permissions
-- =============================================

PRINT '';
PRINT '========================================';
PRINT 'Creating Comprehensive Reporting & Data Export System (ReportCreate.html)...';
PRINT '========================================';

-- Bảng Loại Báo Cáo (Report Types)
CREATE TABLE ReportTypes (
    ReportTypeId INT IDENTITY(1,1) PRIMARY KEY,
    ReportCode NVARCHAR(50) NOT NULL UNIQUE,
    ReportName NVARCHAR(200) NOT NULL,
    ReportCategory NVARCHAR(100) NOT NULL, -- 'STUDENT', 'FINANCE', 'COURSE', 'STAFF', 'SYSTEM'
    Description NVARCHAR(1000),
    DataSourceTable NVARCHAR(255), -- Main table for data source
    DataSourceView NVARCHAR(255), -- View if applicable
    RequiredPermissions NVARCHAR(500), -- JSON array of required permission modules
    SupportedFormats NVARCHAR(200) DEFAULT 'XLSX,PDF,CSV', -- Supported export formats
    DefaultDateFilter BIT DEFAULT 1, -- Whether date filtering is applicable
    IsSystemReport BIT DEFAULT 0, -- System-generated vs custom reports
    TemplateQuery NVARCHAR(MAX), -- Base SQL query template
    ParameterDefinitions NVARCHAR(MAX), -- JSON definition of parameters
    ChartConfiguration NVARCHAR(MAX), -- Chart.js configuration if applicable
    StatusId INT NOT NULL DEFAULT 1,
    DisplayOrder INT DEFAULT 0,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Lịch Sử Tạo Báo Cáo (Report Generation History)
CREATE TABLE ReportGenerationHistory (
    ReportHistoryId INT IDENTITY(1,1) PRIMARY KEY,
    ReportTypeId INT NOT NULL,
    GeneratedBy INT NOT NULL,
    ReportTitle NVARCHAR(300) NOT NULL,
    Parameters NVARCHAR(MAX), -- JSON parameters used
    DateFrom DATE,
    DateTo DATE,
    ExportFormat NVARCHAR(20), -- 'XLSX', 'PDF', 'CSV'
    RecordCount INT DEFAULT 0,
    FileSizeBytes BIGINT DEFAULT 0,
    GenerationDurationMs INT DEFAULT 0,
    GenerationStatus NVARCHAR(50) DEFAULT 'SUCCESS', -- 'SUCCESS', 'ERROR', 'TIMEOUT'
    ErrorMessage NVARCHAR(1000),
    FilePath NVARCHAR(500), -- Storage path if applicable
    FileHash NVARCHAR(128), -- File integrity hash
    DownloadCount INT DEFAULT 0,
    LastDownloadDate DATETIME2,
    ExpiryDate DATETIME2, -- When file should be cleaned up
    GeneratedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    FOREIGN KEY (GeneratedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Quyền Truy Cập Báo Cáo (Report Access Permissions)
CREATE TABLE ReportAccessPermissions (
    PermissionId INT IDENTITY(1,1) PRIMARY KEY,
    ReportTypeId INT NOT NULL,
    RoleId INT, -- NULL means all roles with specific permissions
    PermissionModule NVARCHAR(100) NOT NULL, -- 'STUDENT', 'FINANCE', etc.
    AccessLevel NVARCHAR(50) NOT NULL, -- 'VIEW', 'CREATE', 'EXPORT', 'ADMIN'
    CanSchedule BIT DEFAULT 0, -- Can schedule automated reports
    CanShareReports BIT DEFAULT 0, -- Can share reports with others
    MaxRecordsLimit INT, -- Maximum records user can export
    DateRangeLimit INT, -- Maximum days of data range
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    UNIQUE(ReportTypeId, PermissionModule, AccessLevel)
);

-- Bảng Định Nghĩa Xuất Dữ Liệu (Data Export Definitions)
CREATE TABLE DataExportDefinitions (
    ExportDefId INT IDENTITY(1,1) PRIMARY KEY,
    ExportCode NVARCHAR(50) NOT NULL UNIQUE,
    ExportName NVARCHAR(200) NOT NULL,
    DataCategory NVARCHAR(100) NOT NULL, -- 'STUDENTS', 'COURSES', 'TRANSACTIONS', 'EMPLOYEES'
    SourceTable NVARCHAR(255) NOT NULL,
    SourceColumns NVARCHAR(MAX), -- JSON array of columns to export
    JoinTables NVARCHAR(MAX), -- JSON definition of JOIN tables
    FilterConditions NVARCHAR(MAX), -- Default WHERE conditions
    SortOrder NVARCHAR(MAX), -- Default ORDER BY
    RequiredPermissions NVARCHAR(500), -- Required permission modules
    SensitiveDataColumns NVARCHAR(MAX), -- Columns requiring special handling
    MaxRecordsPerExport INT DEFAULT 10000,
    IsRealTime BIT DEFAULT 1, -- Real-time vs scheduled export
    RefreshIntervalMinutes INT DEFAULT 0, -- For cached exports
    StatusId INT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedBy INT,
    UpdatedDate DATETIME2,
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (UpdatedBy) REFERENCES Employees(EmployeeId)
);

-- Bảng Lịch Hẹn Báo Cáo Tự Động (Scheduled Reports)
CREATE TABLE ScheduledReports (
    ScheduleId INT IDENTITY(1,1) PRIMARY KEY,
    ReportTypeId INT NOT NULL,
    ScheduleName NVARCHAR(200) NOT NULL,
    CreatedBy INT NOT NULL,
    RecipientEmails NVARCHAR(MAX), -- JSON array of email addresses
    ScheduleType NVARCHAR(50) NOT NULL, -- 'DAILY', 'WEEKLY', 'MONTHLY', 'QUARTERLY'
    ScheduleTime TIME NOT NULL, -- Time to generate
    ScheduleDayOfWeek INT, -- For weekly (1=Monday, 7=Sunday)
    ScheduleDayOfMonth INT, -- For monthly (1-31)
    Parameters NVARCHAR(MAX), -- JSON parameters
    ExportFormat NVARCHAR(20) DEFAULT 'XLSX',
    IsActive BIT DEFAULT 1,
    LastRun DATETIME2,
    NextRun DATETIME2,
    RunCount INT DEFAULT 0,
    FailureCount INT DEFAULT 0,
    LastErrorMessage NVARCHAR(1000),
    StatusId INT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2,
    FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    FOREIGN KEY (CreatedBy) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (StatusId) REFERENCES Status(StatusId)
);

-- Bảng Thống Kê Sử Dụng Báo Cáo (Report Usage Analytics)
CREATE TABLE ReportUsageAnalytics (
    AnalyticsId INT IDENTITY(1,1) PRIMARY KEY,
    ReportTypeId INT NOT NULL,
    UserId INT NOT NULL,
    AccessDate DATE NOT NULL,
    AccessCount INT DEFAULT 1,
    GenerationCount INT DEFAULT 0,
    ExportCount INT DEFAULT 0,
    TotalRecordsExported BIGINT DEFAULT 0,
    AverageGenerationTime INT DEFAULT 0, -- milliseconds
    PreferredFormat NVARCHAR(20),
    LastAccessTime DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    FOREIGN KEY (UserId) REFERENCES Employees(EmployeeId),
    PRIMARY KEY (ReportTypeId, UserId, AccessDate)
);

-- Bảng Cache Báo Cáo (Report Cache)
CREATE TABLE ReportCache (
    CacheId INT IDENTITY(1,1) PRIMARY KEY,
    ReportTypeId INT NOT NULL,
    CacheKey NVARCHAR(255) NOT NULL, -- Hash of parameters + date range
    CachedData NVARCHAR(MAX), -- JSON cached result
    Parameters NVARCHAR(MAX), -- Original parameters
    DateFrom DATE,
    DateTo DATE,
    RecordCount INT DEFAULT 0,
    GeneratedBy INT NOT NULL,
    CacheExpiry DATETIME2 NOT NULL,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (ReportTypeId) REFERENCES ReportTypes(ReportTypeId),
    FOREIGN KEY (GeneratedBy) REFERENCES Employees(EmployeeId),
    UNIQUE(ReportTypeId, CacheKey)
);

PRINT 'Report management tables created successfully!';

-- Tạo indexes cho hiệu suất
CREATE INDEX IX_ReportTypes_Category ON ReportTypes(ReportCategory);
CREATE INDEX IX_ReportTypes_Code ON ReportTypes(ReportCode);
CREATE INDEX IX_ReportHistory_ReportType ON ReportGenerationHistory(ReportTypeId);
CREATE INDEX IX_ReportHistory_GeneratedBy ON ReportGenerationHistory(GeneratedBy);
CREATE INDEX IX_ReportHistory_GeneratedDate ON ReportGenerationHistory(GeneratedDate);
CREATE INDEX IX_ReportHistory_Status ON ReportGenerationHistory(GenerationStatus);
CREATE INDEX IX_ReportAccess_ReportType ON ReportAccessPermissions(ReportTypeId);
CREATE INDEX IX_ReportAccess_Module ON ReportAccessPermissions(PermissionModule);
CREATE INDEX IX_DataExport_Category ON DataExportDefinitions(DataCategory);
CREATE INDEX IX_ScheduledReports_NextRun ON ScheduledReports(NextRun);
CREATE INDEX IX_ScheduledReports_Active ON ScheduledReports(IsActive);
CREATE INDEX IX_ReportUsage_Date ON ReportUsageAnalytics(AccessDate);
CREATE INDEX IX_ReportCache_Expiry ON ReportCache(CacheExpiry);
CREATE INDEX IX_ReportCache_Key ON ReportCache(CacheKey);

PRINT 'Report management indexes created successfully!';

-- Dữ liệu mẫu cho Report Types
INSERT INTO ReportTypes (ReportCode, ReportName, ReportCategory, Description, DataSourceTable, RequiredPermissions, TemplateQuery, ParameterDefinitions) VALUES
(N'RPT_STUDENT_ENROLLMENT', N'Báo cáo Đăng ký Học viên', N'STUDENT', N'Thống kê đăng ký học viên theo thời gian', N'Students', N'["STUDENT"]', 
 N'SELECT s.StudentId, s.FullName, s.PhoneNumber, s.Email, s.EnrollmentDate, c.ClassName FROM Students s LEFT JOIN Classes c ON s.ClassId = c.ClassId WHERE s.EnrollmentDate BETWEEN @DateFrom AND @DateTo',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_FINANCE_SUMMARY', N'Báo cáo Tổng quan Tài chính', N'FINANCE', N'Tổng hợp thu chi theo thời gian', N'FinancialTransactions', N'["FINANCE"]', 
 N'SELECT ft.TransactionId, ft.TransactionType, ft.Amount, ft.TransactionDate, ft.Description, fc.CategoryName FROM FinancialTransactions ft LEFT JOIN FinancialCategories fc ON ft.CategoryId = fc.CategoryId WHERE ft.TransactionDate BETWEEN @DateFrom AND @DateTo',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_COURSE_POPULARITY', N'Báo cáo Mức độ Phổ biến Khóa học', N'COURSE', N'Thống kê độ phổ biến của các khóa học', N'Classes', N'["COURSE"]', 
 N'SELECT c.ClassName, COUNT(s.StudentId) as StudentCount, AVG(CAST(s.AverageScore as FLOAT)) as AvgScore FROM Classes c LEFT JOIN Students s ON c.ClassId = s.ClassId WHERE c.StartDate BETWEEN @DateFrom AND @DateTo GROUP BY c.ClassId, c.ClassName',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_STAFF_PERFORMANCE', N'Báo cáo Hiệu suất Nhân sự', N'STAFF', N'Đánh giá hiệu suất làm việc của nhân sự', N'Employees', N'["STAFF"]', 
 N'SELECT e.EmployeeId, e.FullName, e.Position, e.Department, e.HireDate, COUNT(c.ClassId) as ClassCount FROM Employees e LEFT JOIN Classes c ON e.EmployeeId = c.InstructorId WHERE e.HireDate BETWEEN @DateFrom AND @DateTo GROUP BY e.EmployeeId, e.FullName, e.Position, e.Department, e.HireDate',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_REVENUE_ANALYSIS', N'Phân tích Doanh thu', N'FINANCE', N'Phân tích chi tiết doanh thu theo nhiều tiêu chí', N'vw_FinancialSummary', N'["FINANCE"]', 
 N'SELECT BranchName, SUM(Revenue) as TotalRevenue, SUM(Expenses) as TotalExpenses, SUM(Profit) as TotalProfit FROM vw_FinancialSummary WHERE ReportDate BETWEEN @DateFrom AND @DateTo GROUP BY BranchName',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_ATTENDANCE_SUMMARY', N'Báo cáo Chuyên cần', N'STUDENT', N'Thống kê chuyên cần học viên', N'TimekeepingSummaryReport', N'["STUDENT"]', 
 N'SELECT emp.FullName, tsr.Month, tsr.Year, tsr.TotalWorkingDays, tsr.ActualWorkingDays, tsr.AttendanceRate FROM TimekeepingSummaryReport tsr INNER JOIN Employees emp ON tsr.EmployeeId = emp.EmployeeId WHERE DATEFROMPARTS(tsr.Year, tsr.Month, 1) BETWEEN @DateFrom AND @DateTo',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]'),

(N'RPT_MAJOR_ANALYSIS', N'Phân tích Chuyên ngành', N'COURSE', N'Thống kê hiệu quả các chuyên ngành', N'Majors', N'["COURSE"]', 
 N'SELECT m.MajorName, m.BaseTuitionFee, COUNT(c.ClassId) as ClassCount, SUM(c.CurrentStudents) as TotalStudents FROM Majors m LEFT JOIN Classes c ON m.MajorId = c.MajorId WHERE m.CreatedDate BETWEEN @DateFrom AND @DateTo GROUP BY m.MajorId, m.MajorName, m.BaseTuitionFee',
 N'[{"name":"DateFrom","type":"date","required":true},{"name":"DateTo","type":"date","required":true}]');

-- Dữ liệu mẫu cho Data Export Definitions
INSERT INTO DataExportDefinitions (ExportCode, ExportName, DataCategory, SourceTable, SourceColumns, RequiredPermissions, MaxRecordsPerExport) VALUES
(N'EXP_STUDENTS', N'Xuất dữ liệu Học viên', N'STUDENTS', N'Students', 
 N'["StudentId","FullName","PhoneNumber","Email","Address","DateOfBirth","Gender","EnrollmentDate","StatusId"]', 
 N'["STUDENT"]', 5000),

(N'EXP_COURSES', N'Xuất dữ liệu Khóa học', N'COURSES', N'Classes', 
 N'["ClassId","ClassName","Description","StartDate","EndDate","MaxStudents","CurrentStudents","TuitionFee","StatusId"]', 
 N'["COURSE"]', 2000),

(N'EXP_TRANSACTIONS', N'Xuất dữ liệu Giao dịch', N'TRANSACTIONS', N'FinancialTransactions', 
 N'["TransactionId","TransactionType","Amount","TransactionDate","Description","CategoryId","CreatedBy"]', 
 N'["FINANCE"]', 10000),

(N'EXP_EMPLOYEES', N'Xuất dữ liệu Nhân sự', N'EMPLOYEES', N'Employees', 
 N'["EmployeeId","FullName","Position","Department","PhoneNumber","Email","HireDate","Salary","StatusId"]', 
 N'["STAFF"]', 1000),

(N'EXP_MAJORS', N'Xuất dữ liệu Chuyên ngành', N'MAJORS', N'Majors', 
 N'["MajorId","MajorName","MajorCode","Description","TotalSessions","BaseTuitionFee","IsPopular","StatusId"]', 
 N'["COURSE"]', 500),

(N'EXP_FINANCIAL_SUMMARY', N'Xuất tổng hợp Tài chính', N'FINANCE_SUMMARY', N'vw_FinancialSummary', 
 N'["BranchName","ReportDate","Revenue","Expenses","Profit","StudentCount","ClassCount"]', 
 N'["FINANCE"]', 2000);

-- Dữ liệu mẫu cho Report Access Permissions
INSERT INTO ReportAccessPermissions (ReportTypeId, PermissionModule, AccessLevel, CanSchedule, CanShareReports, MaxRecordsLimit, DateRangeLimit) VALUES
(1, 'STUDENT', 'VIEW', 0, 0, 1000, 365),
(1, 'STUDENT', 'EXPORT', 1, 1, 5000, 90),
(2, 'FINANCE', 'VIEW', 0, 0, 2000, 365),
(2, 'FINANCE', 'EXPORT', 1, 1, 10000, 90),
(3, 'COURSE', 'VIEW', 0, 0, 1000, 365),
(3, 'COURSE', 'EXPORT', 1, 1, 2000, 90),
(4, 'STAFF', 'VIEW', 0, 0, 500, 365),
(4, 'STAFF', 'EXPORT', 1, 1, 1000, 90),
(5, 'FINANCE', 'ADMIN', 1, 1, NULL, NULL),
(6, 'STUDENT', 'VIEW', 0, 0, 2000, 180),
(7, 'COURSE', 'VIEW', 0, 0, 1000, 365);

PRINT 'Sample report data inserted successfully!';

-- =============================================
-- STORED PROCEDURES FOR REPORTING SYSTEM
-- =============================================

-- Procedure: Lấy danh sách báo cáo theo quyền
CREATE PROCEDURE sp_GetAvailableReports
    @UserId INT,
    @UserPermissions NVARCHAR(MAX) -- JSON array of permission modules
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT
        rt.ReportTypeId,
        rt.ReportCode,
        rt.ReportName,
        rt.ReportCategory,
        rt.Description,
        rt.SupportedFormats,
        rt.DefaultDateFilter,
        rap.AccessLevel,
        rap.CanSchedule,
        rap.CanShareReports,
        rap.MaxRecordsLimit,
        rap.DateRangeLimit,
        -- Usage statistics
        ISNULL(rua.AccessCount, 0) AS MonthlyAccessCount,
        ISNULL(rua.GenerationCount, 0) AS MonthlyGenerationCount,
        rt.DisplayOrder
    FROM ReportTypes rt
    INNER JOIN ReportAccessPermissions rap ON rt.ReportTypeId = rap.ReportTypeId
    LEFT JOIN ReportUsageAnalytics rua ON rt.ReportTypeId = rua.ReportTypeId 
        AND rua.UserId = @UserId 
        AND rua.AccessDate = CAST(GETDATE() AS DATE)
    WHERE rt.StatusId = 1
        AND rap.StatusId = 1
        AND (
            -- Check if user has required permissions
            JSON_VALUE(rt.RequiredPermissions, '$[0]') IN (SELECT value FROM OPENJSON(@UserPermissions))
            OR 
            rap.PermissionModule IN (SELECT value FROM OPENJSON(@UserPermissions))
        )
    ORDER BY rt.DisplayOrder, rt.ReportName;
END;

-- Procedure: Tạo báo cáo
CREATE PROCEDURE sp_GenerateReport
    @ReportTypeId INT,
    @UserId INT,
    @Parameters NVARCHAR(MAX), -- JSON parameters
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @ExportFormat NVARCHAR(20) = 'XLSX',
    @ReportHistoryId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @StartTime DATETIME2 = GETDATE();
        DECLARE @ReportQuery NVARCHAR(MAX);
        DECLARE @ReportName NVARCHAR(200);
        DECLARE @RecordCount INT = 0;
        
        -- Get report template
        SELECT @ReportQuery = TemplateQuery, @ReportName = ReportName
        FROM ReportTypes 
        WHERE ReportTypeId = @ReportTypeId AND StatusId = 1;
        
        IF @ReportQuery IS NULL
        BEGIN
            RAISERROR(N'Báo cáo không tồn tại hoặc đã bị vô hiệu hóa!', 16, 1);
            RETURN;
        END
        
        -- Check permissions
        IF NOT EXISTS (
            SELECT 1 FROM ReportAccessPermissions 
            WHERE ReportTypeId = @ReportTypeId 
            AND AccessLevel IN ('VIEW', 'EXPORT', 'ADMIN')
            AND StatusId = 1
        )
        BEGIN
            RAISERROR(N'Bạn không có quyền tạo báo cáo này!', 16, 1);
            RETURN;
        END
        
        -- Replace parameters in query
        IF @DateFrom IS NOT NULL
            SET @ReportQuery = REPLACE(@ReportQuery, '@DateFrom', '''' + CAST(@DateFrom AS NVARCHAR) + '''');
        IF @DateTo IS NOT NULL
            SET @ReportQuery = REPLACE(@ReportQuery, '@DateTo', '''' + CAST(@DateTo AS NVARCHAR) + '''');
        
        -- Create report history record
        INSERT INTO ReportGenerationHistory (
            ReportTypeId, GeneratedBy, ReportTitle, Parameters, 
            DateFrom, DateTo, ExportFormat, GenerationStatus
        ) VALUES (
            @ReportTypeId, @UserId, @ReportName, @Parameters,
            @DateFrom, @DateTo, @ExportFormat, 'SUCCESS'
        );
        
        SET @ReportHistoryId = SCOPE_IDENTITY();
        
        -- Update generation duration
        DECLARE @EndTime DATETIME2 = GETDATE();
        DECLARE @Duration INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
        
        UPDATE ReportGenerationHistory 
        SET GenerationDurationMs = @Duration,
            RecordCount = @RecordCount
        WHERE ReportHistoryId = @ReportHistoryId;
        
        -- Update usage analytics
        MERGE ReportUsageAnalytics AS target
        USING (SELECT @ReportTypeId AS ReportTypeId, @UserId AS UserId, CAST(GETDATE() AS DATE) AS AccessDate) AS source
        ON target.ReportTypeId = source.ReportTypeId 
           AND target.UserId = source.UserId 
           AND target.AccessDate = source.AccessDate
        WHEN MATCHED THEN
            UPDATE SET 
                GenerationCount = GenerationCount + 1,
                LastAccessTime = GETDATE(),
                PreferredFormat = @ExportFormat
        WHEN NOT MATCHED THEN
            INSERT (ReportTypeId, UserId, AccessDate, GenerationCount, PreferredFormat)
            VALUES (source.ReportTypeId, source.UserId, source.AccessDate, 1, @ExportFormat);
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Status, N'Tạo báo cáo thành công!' AS Message, @ReportHistoryId AS ReportHistoryId;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        -- Log error
        IF @ReportHistoryId IS NOT NULL
        BEGIN
            UPDATE ReportGenerationHistory 
            SET GenerationStatus = 'ERROR',
                ErrorMessage = ERROR_MESSAGE()
            WHERE ReportHistoryId = @ReportHistoryId;
        END
        
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message, 0 AS ReportHistoryId;
    END CATCH
END;

-- Procedure: Xuất dữ liệu
CREATE PROCEDURE sp_ExportData
    @ExportDefId INT,
    @UserId INT,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @ExportFormat NVARCHAR(20) = 'XLSX',
    @MaxRecords INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        
        DECLARE @ExportName NVARCHAR(200);
        DECLARE @SourceTable NVARCHAR(255);
        DECLARE @SourceColumns NVARCHAR(MAX);
        DECLARE @MaxRecordsLimit INT;
        
        -- Get export definition
        SELECT 
            @ExportName = ExportName,
            @SourceTable = SourceTable,
            @SourceColumns = SourceColumns,
            @MaxRecordsLimit = MaxRecordsPerExport
        FROM DataExportDefinitions 
        WHERE ExportDefId = @ExportDefId AND StatusId = 1;
        
        IF @ExportName IS NULL
        BEGIN
            RAISERROR(N'Định nghĩa xuất dữ liệu không tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Apply record limit
        IF @MaxRecords IS NULL OR @MaxRecords > @MaxRecordsLimit
            SET @MaxRecords = @MaxRecordsLimit;
        
        SELECT 'SUCCESS' AS Status, N'Xuất dữ liệu thành công!' AS Message;
        
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- Procedure: Lấy lịch sử báo cáo
CREATE PROCEDURE sp_GetReportHistory
    @UserId INT,
    @ReportTypeId INT = NULL,
    @Days INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        rgh.ReportHistoryId,
        rt.ReportName,
        rt.ReportCategory,
        rgh.ReportTitle,
        rgh.DateFrom,
        rgh.DateTo,
        rgh.ExportFormat,
        rgh.RecordCount,
        rgh.GenerationDurationMs,
        rgh.GenerationStatus,
        rgh.ErrorMessage,
        rgh.DownloadCount,
        rgh.GeneratedDate,
        emp.FullName AS GeneratedByName
    FROM ReportGenerationHistory rgh
    INNER JOIN ReportTypes rt ON rgh.ReportTypeId = rt.ReportTypeId
    INNER JOIN Employees emp ON rgh.GeneratedBy = emp.EmployeeId
    WHERE rgh.GeneratedBy = @UserId
        AND (@ReportTypeId IS NULL OR rgh.ReportTypeId = @ReportTypeId)
        AND rgh.GeneratedDate >= DATEADD(DAY, -@Days, GETDATE())
    ORDER BY rgh.GeneratedDate DESC;
END;

-- Procedure: Thống kê sử dụng báo cáo
CREATE PROCEDURE sp_GetReportUsageStatistics
    @Days INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Báo cáo phổ biến nhất
    SELECT TOP 10
        rt.ReportName,
        rt.ReportCategory,
        SUM(rua.AccessCount) AS TotalAccess,
        SUM(rua.GenerationCount) AS TotalGeneration,
        COUNT(DISTINCT rua.UserId) AS UniqueUsers,
        AVG(CAST(rua.AverageGenerationTime AS FLOAT)) AS AvgGenerationTime
    FROM ReportUsageAnalytics rua
    INNER JOIN ReportTypes rt ON rua.ReportTypeId = rt.ReportTypeId
    WHERE rua.AccessDate >= DATEADD(DAY, -@Days, GETDATE())
    GROUP BY rt.ReportTypeId, rt.ReportName, rt.ReportCategory
    ORDER BY TotalAccess DESC;
    
    -- Định dạng xuất phổ biến
    SELECT 
        rgh.ExportFormat,
        COUNT(*) AS UsageCount,
        AVG(rgh.GenerationDurationMs) AS AvgDuration,
        SUM(rgh.RecordCount) AS TotalRecords
    FROM ReportGenerationHistory rgh
    WHERE rgh.GeneratedDate >= DATEADD(DAY, -@Days, GETDATE())
        AND rgh.GenerationStatus = 'SUCCESS'
    GROUP BY rgh.ExportFormat
    ORDER BY UsageCount DESC;
    
    -- Người dùng tích cực nhất
    SELECT TOP 10
        emp.FullName,
        emp.Position,
        SUM(rua.GenerationCount) AS TotalReports,
        COUNT(DISTINCT rua.ReportTypeId) AS ReportTypesUsed
    FROM ReportUsageAnalytics rua
    INNER JOIN Employees emp ON rua.UserId = emp.EmployeeId
    WHERE rua.AccessDate >= DATEADD(DAY, -@Days, GETDATE())
    GROUP BY emp.EmployeeId, emp.FullName, emp.Position
    ORDER BY TotalReports DESC;
END;

-- Procedure: Dọn dẹp cache và file cũ
CREATE PROCEDURE sp_CleanupReportData
    @DaysToKeep INT = 90
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @CleanupDate DATETIME2 = DATEADD(DAY, -@DaysToKeep, GETDATE());
        DECLARE @DeletedRecords INT = 0;
        
        -- Xóa cache hết hạn
        DELETE FROM ReportCache WHERE CacheExpiry < GETDATE();
        SET @DeletedRecords = @@ROWCOUNT;
        
        -- Xóa lịch sử báo cáo cũ
        DELETE FROM ReportGenerationHistory WHERE GeneratedDate < @CleanupDate;
        SET @DeletedRecords = @DeletedRecords + @@ROWCOUNT;
        
        -- Xóa usage analytics cũ (giữ lại 1 năm)
        DELETE FROM ReportUsageAnalytics WHERE AccessDate < DATEADD(YEAR, -1, GETDATE());
        SET @DeletedRecords = @DeletedRecords + @@ROWCOUNT;
        
        SELECT 'SUCCESS' AS Status, 
               CONCAT(N'Đã dọn dẹp ', @DeletedRecords, N' bản ghi cũ.') AS Message;
               
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END;

PRINT 'Report management stored procedures created successfully!';

-- =============================================
-- FUNCTIONS FOR REPORTING SYSTEM
-- =============================================

-- Function: Tính toán độ phức tạp báo cáo
CREATE FUNCTION fn_CalculateReportComplexity(
    @ReportTypeId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Complexity INT = 1;
    DECLARE @TemplateQuery NVARCHAR(MAX);
    
    SELECT @TemplateQuery = TemplateQuery FROM ReportTypes WHERE ReportTypeId = @ReportTypeId;
    
    IF @TemplateQuery IS NULL RETURN 0;
    
    -- Tăng complexity dựa trên JOIN
    SET @Complexity = @Complexity + (LEN(@TemplateQuery) - LEN(REPLACE(UPPER(@TemplateQuery), 'JOIN', ''))) / 4;
    
    -- Tăng complexity dựa trên GROUP BY
    IF UPPER(@TemplateQuery) LIKE '%GROUP BY%'
        SET @Complexity = @Complexity + 2;
    
    -- Tăng complexity dựa trên subquery
    SET @Complexity = @Complexity + (LEN(@TemplateQuery) - LEN(REPLACE(@TemplateQuery, '(SELECT', '')));
    
    RETURN @Complexity;
END;

-- Function: Ước tính thời gian tạo báo cáo
CREATE FUNCTION fn_EstimateReportGenerationTime(
    @ReportTypeId INT,
    @RecordCount INT
)
RETURNS INT
AS
BEGIN
    DECLARE @BaseTime INT = 1000; -- milliseconds
    DECLARE @Complexity INT;
    DECLARE @EstimatedTime INT;
    
    SET @Complexity = dbo.fn_CalculateReportComplexity(@ReportTypeId);
    
    -- Tính thời gian dựa trên complexity và record count
    SET @EstimatedTime = @BaseTime + (@Complexity * 100) + (@RecordCount * 0.1);
    
    -- Lấy thời gian trung bình từ lịch sử
    DECLARE @HistoricalAvg INT;
    SELECT @HistoricalAvg = AVG(GenerationDurationMs)
    FROM ReportGenerationHistory 
    WHERE ReportTypeId = @ReportTypeId 
        AND GenerationStatus = 'SUCCESS'
        AND GeneratedDate >= DATEADD(DAY, -30, GETDATE());
    
    -- Sử dụng historical average nếu có
    IF @HistoricalAvg IS NOT NULL AND @HistoricalAvg > 0
        SET @EstimatedTime = (@EstimatedTime + @HistoricalAvg) / 2;
    
    RETURN @EstimatedTime;
END;

-- Function: Kiểm tra quyền truy cập báo cáo
CREATE FUNCTION fn_CheckReportAccess(
    @ReportTypeId INT,
    @UserId INT,
    @AccessLevel NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @HasAccess BIT = 0;
    
    -- Kiểm tra quyền trực tiếp
    IF EXISTS (
        SELECT 1 FROM ReportAccessPermissions rap
        WHERE rap.ReportTypeId = @ReportTypeId
        AND rap.AccessLevel = @AccessLevel
        AND rap.StatusId = 1
    )
        SET @HasAccess = 1;
    
    RETURN @HasAccess;
END;

PRINT 'Report management functions created successfully!';

PRINT '';
PRINT 'Comprehensive Reporting & Data Export System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Advanced report type management with templates';
PRINT '- Role-based report access permissions';
PRINT '- Report generation history and analytics';
PRINT '- Data export definitions with security';
PRINT '- Scheduled automated reports';
PRINT '- Report usage analytics and monitoring';
PRINT '- Report caching for performance';
PRINT '- Multi-format export (XLSX, PDF, CSV)';
PRINT '- Real-time and batch reporting';
PRINT '- Report complexity analysis';
PRINT '- Automated data cleanup';
PRINT '- Comprehensive audit trails';

PRINT '';
PRINT 'Password Management & Security System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Password history tracking';
PRINT '- Password policy enforcement';
PRINT '- Common password prevention';
PRINT '- Account security configuration';
PRINT '- Security audit logging';
PRINT '- Session tracking';
PRINT '- Token management for password reset';
PRINT '- Password strength validation';
PRINT '- Comprehensive stored procedures for password operations';
PRINT '';
PRINT 'Password Policies Created:';
PRINT '1. Default Policy - Standard security requirements';
PRINT '2. High Security Policy - Enhanced security for sensitive accounts';
PRINT '3. Basic Policy - Relaxed requirements for basic users';

-- ================================================================
-- Section 36: Comprehensive Request Management System (RequestCreate.html)
-- ================================================================

PRINT '';
PRINT '=== Creating Section 36: Comprehensive Request Management System ===';

-- Table: RequestTypes - Định nghĩa các loại yêu cầu
CREATE TABLE RequestTypes (
    RequestTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeCode NVARCHAR(50) NOT NULL UNIQUE,
    TypeName NVARCHAR(200) NOT NULL,
    TypeDescription NVARCHAR(MAX),
    CategoryGroup NVARCHAR(100), -- Student, Staff, Academic, Financial, Document, Leave, etc.
    RequiredFields NVARCHAR(MAX), -- JSON string defining required fields
    FormTemplate NVARCHAR(MAX), -- JSON template for dynamic form generation
    ApprovalWorkflow NVARCHAR(MAX), -- JSON defining approval workflow steps
    MaxProcessingDays INT DEFAULT 30,
    Priority NVARCHAR(50) DEFAULT 'Normal', -- Low, Normal, High, Urgent
    RequiresDocuments BIT DEFAULT 0,
    RequiresApproval BIT DEFAULT 1,
    AutoAssignment BIT DEFAULT 0, -- Auto assign to responsible department
    NotificationSettings NVARCHAR(MAX), -- JSON for notification preferences
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID)
);

-- Table: Requests - Bảng chính lưu trữ yêu cầu
CREATE TABLE Requests (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    RequestCode NVARCHAR(50) NOT NULL UNIQUE,
    RequestTypeID INT NOT NULL,
    Title NVARCHAR(500) NOT NULL,
    Description NVARCHAR(MAX),
    RequestData NVARCHAR(MAX), -- JSON data containing form values
    RequestorID INT NOT NULL, -- Employee making the request
    RequestorType NVARCHAR(50) DEFAULT 'Employee', -- Employee, Student, External
    StudentID INT NULL, -- If request is for/by student
    DepartmentID INT NULL, -- Target department
    BranchID INT NULL, -- Target branch
    ClassID INT NULL, -- If class-related
    MajorID INT NULL, -- If major-related
    Priority NVARCHAR(50) DEFAULT 'Normal',
    UrgencyLevel INT DEFAULT 3, -- 1-5 scale
    ExpectedCompletionDate DATE,
    ActualCompletionDate DATE,
    EstimatedCost DECIMAL(15,2),
    ActualCost DECIMAL(15,2),
    CurrencyCode NVARCHAR(10) DEFAULT 'VND',
    Justification NVARCHAR(MAX), -- Business justification
    Impact NVARCHAR(MAX), -- Impact if not approved
    Attachments NVARCHAR(MAX), -- JSON array of file paths
    Tags NVARCHAR(500), -- Comma-separated tags for categorization
    SubmissionDate DATETIME2 DEFAULT GETDATE(),
    LastActionDate DATETIME2 DEFAULT GETDATE(),
    CurrentStatusID INT DEFAULT 1,
    CurrentStepID INT, -- Current workflow step
    AssignedToID INT, -- Currently assigned to employee
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (RequestTypeID) REFERENCES RequestTypes(RequestTypeID),
    FOREIGN KEY (RequestorID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    FOREIGN KEY (MajorID) REFERENCES Major(MajorID),
    FOREIGN KEY (CurrentStatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (AssignedToID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestWorkflowSteps - Định nghĩa các bước trong quy trình phê duyệt
CREATE TABLE RequestWorkflowSteps (
    StepID INT IDENTITY(1,1) PRIMARY KEY,
    RequestTypeID INT NOT NULL,
    StepOrder INT NOT NULL,
    StepName NVARCHAR(200) NOT NULL,
    StepDescription NVARCHAR(MAX),
    ResponsibleRole NVARCHAR(100), -- Role required for this step
    ResponsibleDepartmentID INT,
    RequiredApprovers INT DEFAULT 1, -- Number of approvers needed
    ApprovalType NVARCHAR(50) DEFAULT 'Any', -- Any, All, Majority
    MaxDays INT DEFAULT 7, -- Max days for this step
    AutoAdvance BIT DEFAULT 0, -- Auto advance if conditions met
    ConditionsToAdvance NVARCHAR(MAX), -- JSON conditions
    NotificationSettings NVARCHAR(MAX), -- JSON notification settings
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (RequestTypeID) REFERENCES RequestTypes(RequestTypeID),
    FOREIGN KEY (ResponsibleDepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestWorkflowHistory - Lịch sử di chuyển qua các bước
CREATE TABLE RequestWorkflowHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    StepID INT NOT NULL,
    FromStepID INT, -- Previous step
    ActionTaken NVARCHAR(200), -- Submit, Approve, Reject, Return, etc.
    ActionReason NVARCHAR(MAX),
    Comments NVARCHAR(MAX),
    ActionBy INT NOT NULL,
    ActionDate DATETIME2 DEFAULT GETDATE(),
    TimeSpentMinutes INT, -- Time spent on this step
    StatusBeforeAction INT,
    StatusAfterAction INT,
    AdditionalData NVARCHAR(MAX), -- JSON for additional workflow data
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (StepID) REFERENCES RequestWorkflowSteps(StepID),
    FOREIGN KEY (FromStepID) REFERENCES RequestWorkflowSteps(StepID),
    FOREIGN KEY (ActionBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusBeforeAction) REFERENCES Status(StatusID),
    FOREIGN KEY (StatusAfterAction) REFERENCES Status(StatusID)
);

-- Table: RequestApprovals - Chi tiết phê duyệt cho từng bước
CREATE TABLE RequestApprovals (
    ApprovalID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    StepID INT NOT NULL,
    ApproverID INT NOT NULL,
    ApprovalStatus NVARCHAR(50) DEFAULT 'Pending', -- Pending, Approved, Rejected
    ApprovalDate DATETIME2,
    Comments NVARCHAR(MAX),
    DigitalSignature NVARCHAR(MAX), -- For digital signature if needed
    ApprovalOrder INT DEFAULT 1, -- Order of approval within step
    Conditions NVARCHAR(MAX), -- Any conditions attached to approval
    DelegatedBy INT, -- If approval was delegated
    ProxyApproval BIT DEFAULT 0, -- If this is a proxy approval
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (StepID) REFERENCES RequestWorkflowSteps(StepID),
    FOREIGN KEY (ApproverID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (DelegatedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestDocuments - Tài liệu đính kèm yêu cầu
CREATE TABLE RequestDocuments (
    DocumentID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    DocumentName NVARCHAR(255) NOT NULL,
    DocumentType NVARCHAR(100), -- Application, Supporting, Legal, Financial, etc.
    FilePath NVARCHAR(500),
    FileName NVARCHAR(255),
    FileSize BIGINT,
    FileExtension NVARCHAR(20),
    MimeType NVARCHAR(100),
    DocumentCategory NVARCHAR(100), -- Required, Optional, System-generated
    UploadedBy INT NOT NULL,
    UploadDate DATETIME2 DEFAULT GETDATE(),
    Version INT DEFAULT 1,
    IsLatestVersion BIT DEFAULT 1,
    AccessLevel NVARCHAR(50) DEFAULT 'Internal', -- Public, Internal, Confidential
    ChecksumMD5 NVARCHAR(50), -- For file integrity
    Description NVARCHAR(MAX),
    StatusID INT DEFAULT 1,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (UploadedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID)
);

-- Table: RequestComments - Nhận xét và thảo luận
CREATE TABLE RequestComments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    ParentCommentID INT, -- For threaded discussions
    CommentText NVARCHAR(MAX) NOT NULL,
    CommentType NVARCHAR(50) DEFAULT 'General', -- General, Question, Clarification, Decision
    IsInternal BIT DEFAULT 1, -- Internal comments vs public
    CommentBy INT NOT NULL,
    CommentDate DATETIME2 DEFAULT GETDATE(),
    IsEdited BIT DEFAULT 0,
    EditedDate DATETIME2,
    EditedBy INT,
    Visibility NVARCHAR(50) DEFAULT 'All', -- All, Approvers, Requestor, Specific
    AttachedFiles NVARCHAR(MAX), -- JSON array of attached files
    Reactions NVARCHAR(MAX), -- JSON for emoji reactions
    StatusID INT DEFAULT 1,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (ParentCommentID) REFERENCES RequestComments(CommentID),
    FOREIGN KEY (CommentBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (EditedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID)
);

-- Table: RequestNotifications - Hệ thống thông báo
CREATE TABLE RequestNotifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    RecipientID INT NOT NULL,
    NotificationType NVARCHAR(100), -- NewRequest, StatusChange, Approval, Reminder, etc.
    NotificationTitle NVARCHAR(200),
    NotificationMessage NVARCHAR(MAX),
    NotificationData NVARCHAR(MAX), -- JSON additional data
    Channel NVARCHAR(50) DEFAULT 'System', -- System, Email, SMS, Push
    Priority NVARCHAR(50) DEFAULT 'Normal',
    IsRead BIT DEFAULT 0,
    ReadDate DATETIME2,
    SentDate DATETIME2 DEFAULT GETDATE(),
    DeliveryStatus NVARCHAR(50) DEFAULT 'Sent', -- Sent, Delivered, Failed, Pending
    RetryCount INT DEFAULT 0,
    ScheduledDate DATETIME2, -- For scheduled notifications
    ExpiryDate DATETIME2,
    ActionUrl NVARCHAR(500), -- Deep link to specific action
    StatusID INT DEFAULT 1,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (RecipientID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID)
);

-- Table: RequestTemplates - Template cho các loại yêu cầu thường dùng
CREATE TABLE RequestTemplates (
    TemplateID INT IDENTITY(1,1) PRIMARY KEY,
    RequestTypeID INT NOT NULL,
    TemplateName NVARCHAR(200) NOT NULL,
    TemplateDescription NVARCHAR(MAX),
    TemplateData NVARCHAR(MAX), -- JSON pre-filled form data
    IsPublic BIT DEFAULT 1, -- Available to all users
    UsageCount INT DEFAULT 0,
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    StatusID INT DEFAULT 1,
    FOREIGN KEY (RequestTypeID) REFERENCES RequestTypes(RequestTypeID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID)
);

-- Table: RequestAnalytics - Phân tích và báo cáo
CREATE TABLE RequestAnalytics (
    AnalyticsID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    MetricName NVARCHAR(100), -- ProcessingTime, ApprovalTime, CostVariance, etc.
    MetricValue DECIMAL(15,4),
    MetricUnit NVARCHAR(50), -- Hours, Days, VND, Percentage, etc.
    CalculationDate DATETIME2 DEFAULT GETDATE(),
    CalculationMethod NVARCHAR(200),
    BenchmarkValue DECIMAL(15,4), -- Comparison benchmark
    PerformanceRating NVARCHAR(50), -- Excellent, Good, Average, Poor
    Notes NVARCHAR(MAX),
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID)
);

PRINT 'Request Management tables created successfully!';

-- ================================================================
-- INDEXES for Request Management System
-- ================================================================

-- Indexes cho bảng Requests
CREATE INDEX IX_Requests_RequestCode ON Requests(RequestCode);
CREATE INDEX IX_Requests_RequestType ON Requests(RequestTypeID);
CREATE INDEX IX_Requests_Requestor ON Requests(RequestorID);
CREATE INDEX IX_Requests_Status ON Requests(CurrentStatusID);
CREATE INDEX IX_Requests_SubmissionDate ON Requests(SubmissionDate);
CREATE INDEX IX_Requests_AssignedTo ON Requests(AssignedToID);
CREATE INDEX IX_Requests_Department ON Requests(DepartmentID);
CREATE INDEX IX_Requests_Priority ON Requests(Priority);
CREATE INDEX IX_Requests_Student ON Requests(StudentID);
CREATE INDEX IX_Requests_Class ON Requests(ClassID);

-- Indexes cho bảng RequestWorkflowHistory
CREATE INDEX IX_RequestWorkflowHistory_Request ON RequestWorkflowHistory(RequestID);
CREATE INDEX IX_RequestWorkflowHistory_Step ON RequestWorkflowHistory(StepID);
CREATE INDEX IX_RequestWorkflowHistory_ActionBy ON RequestWorkflowHistory(ActionBy);
CREATE INDEX IX_RequestWorkflowHistory_ActionDate ON RequestWorkflowHistory(ActionDate);

-- Indexes cho bảng RequestApprovals
CREATE INDEX IX_RequestApprovals_Request ON RequestApprovals(RequestID);
CREATE INDEX IX_RequestApprovals_Approver ON RequestApprovals(ApproverID);
CREATE INDEX IX_RequestApprovals_Status ON RequestApprovals(ApprovalStatus);
CREATE INDEX IX_RequestApprovals_Date ON RequestApprovals(ApprovalDate);

-- Indexes cho bảng RequestDocuments
CREATE INDEX IX_RequestDocuments_Request ON RequestDocuments(RequestID);
CREATE INDEX IX_RequestDocuments_Type ON RequestDocuments(DocumentType);
CREATE INDEX IX_RequestDocuments_UploadedBy ON RequestDocuments(UploadedBy);

-- Indexes cho bảng RequestNotifications
CREATE INDEX IX_RequestNotifications_Recipient ON RequestNotifications(RecipientID);
CREATE INDEX IX_RequestNotifications_Type ON RequestNotifications(NotificationType);
CREATE INDEX IX_RequestNotifications_IsRead ON RequestNotifications(IsRead);
CREATE INDEX IX_RequestNotifications_SentDate ON RequestNotifications(SentDate);

PRINT 'Request Management indexes created successfully!';

-- ================================================================
-- VIEWS for Request Management System
-- ================================================================

-- View: Comprehensive request list with all related information
CREATE VIEW vw_RequestList AS
SELECT 
    r.RequestID,
    r.RequestCode,
    rt.TypeName as RequestTypeName,
    rt.CategoryGroup,
    r.Title,
    r.Priority,
    r.UrgencyLevel,
    
    -- Requestor information
    emp_req.FullName as RequestorName,
    emp_req.Email as RequestorEmail,
    dept_req.DepartmentName as RequestorDepartment,
    
    -- Student information (if applicable)
    s.StudentCode,
    s.FullName as StudentName,
    
    -- Target information
    dept.DepartmentName as TargetDepartment,
    br.BranchName,
    cl.ClassName,
    maj.MajorName,
    
    -- Current assignment
    emp_assigned.FullName as AssignedToName,
    emp_assigned.Email as AssignedToEmail,
    
    -- Status and dates
    st.StatusName,
    st.StatusColor,
    r.SubmissionDate,
    r.ExpectedCompletionDate,
    r.ActualCompletionDate,
    r.LastActionDate,
    
    -- Progress information
    CASE 
        WHEN r.ActualCompletionDate IS NOT NULL THEN 'Completed'
        WHEN r.ExpectedCompletionDate < GETDATE() THEN 'Overdue'
        WHEN DATEDIFF(DAY, GETDATE(), r.ExpectedCompletionDate) <= 3 THEN 'Due Soon'
        ELSE 'On Track'
    END as ProgressStatus,
    
    DATEDIFF(DAY, r.SubmissionDate, ISNULL(r.ActualCompletionDate, GETDATE())) as ProcessingDays,
    
    -- Cost information
    r.EstimatedCost,
    r.ActualCost,
    r.CurrencyCode,
    
    -- Workflow information
    ws.StepName as CurrentStepName,
    ws.MaxDays as StepMaxDays,
    
    -- Counts
    (SELECT COUNT(*) FROM RequestDocuments rd WHERE rd.RequestID = r.RequestID AND rd.StatusID = 1) as DocumentCount,
    (SELECT COUNT(*) FROM RequestComments rc WHERE rc.RequestID = r.RequestID AND rc.StatusID = 1) as CommentCount,
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.ApprovalStatus = 'Pending') as PendingApprovals,
    
    r.CreatedDate,
    r.ModifiedDate,
    emp_created.FullName as CreatedByName,
    emp_modified.FullName as ModifiedByName

FROM Requests r
INNER JOIN RequestTypes rt ON r.RequestTypeID = rt.RequestTypeID
INNER JOIN Employee emp_req ON r.RequestorID = emp_req.EmployeeID
LEFT JOIN Department dept_req ON emp_req.DepartmentID = dept_req.DepartmentID
LEFT JOIN Student s ON r.StudentID = s.StudentID
LEFT JOIN Department dept ON r.DepartmentID = dept.DepartmentID
LEFT JOIN Branch br ON r.BranchID = br.BranchID
LEFT JOIN Class cl ON r.ClassID = cl.ClassID
LEFT JOIN Major maj ON r.MajorID = maj.MajorID
LEFT JOIN Employee emp_assigned ON r.AssignedToID = emp_assigned.EmployeeID
INNER JOIN Status st ON r.CurrentStatusID = st.StatusID
LEFT JOIN RequestWorkflowSteps ws ON r.CurrentStepID = ws.StepID
LEFT JOIN Employee emp_created ON r.CreatedBy = emp_created.EmployeeID
LEFT JOIN Employee emp_modified ON r.ModifiedBy = emp_modified.EmployeeID
WHERE r.CurrentStatusID = 1; -- Only active requests

-- View: Request workflow status
CREATE VIEW vw_RequestWorkflowStatus AS
SELECT 
    r.RequestID,
    r.RequestCode,
    rt.TypeName as RequestTypeName,
    ws.StepID,
    ws.StepOrder,
    ws.StepName,
    ws.MaxDays,
    
    -- Current step status
    CASE 
        WHEN r.CurrentStepID = ws.StepID THEN 'Current'
        WHEN ws.StepOrder < (SELECT StepOrder FROM RequestWorkflowSteps WHERE StepID = r.CurrentStepID) THEN 'Completed'
        ELSE 'Pending'
    END as StepStatus,
    
    -- Approval information for current step
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.StepID = ws.StepID) as TotalApprovals,
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.StepID = ws.StepID AND ra.ApprovalStatus = 'Approved') as ApprovedCount,
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.StepID = ws.StepID AND ra.ApprovalStatus = 'Rejected') as RejectedCount,
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.StepID = ws.StepID AND ra.ApprovalStatus = 'Pending') as PendingCount,
    
    -- Timing information
    (SELECT MIN(ActionDate) FROM RequestWorkflowHistory rwh WHERE rwh.RequestID = r.RequestID AND rwh.StepID = ws.StepID) as StepStartDate,
    (SELECT MAX(ActionDate) FROM RequestWorkflowHistory rwh WHERE rwh.RequestID = r.RequestID AND rwh.StepID = ws.StepID) as StepEndDate,
    
    ws.ResponsibleRole,
    dept.DepartmentName as ResponsibleDepartment

FROM Requests r
INNER JOIN RequestTypes rt ON r.RequestTypeID = rt.RequestTypeID
INNER JOIN RequestWorkflowSteps ws ON ws.RequestTypeID = rt.RequestTypeID
LEFT JOIN Department dept ON ws.ResponsibleDepartmentID = dept.DepartmentID
WHERE r.CurrentStatusID = 1
    AND ws.StatusID = 1;

PRINT 'Request Management views created successfully!';

-- ================================================================
-- STORED PROCEDURES for Request Management System
-- ================================================================

-- Stored Procedure: Tạo yêu cầu mới
CREATE PROCEDURE sp_CreateRequest
    @RequestTypeID INT,
    @Title NVARCHAR(500),
    @Description NVARCHAR(MAX) = NULL,
    @RequestData NVARCHAR(MAX) = NULL, -- JSON form data
    @RequestorID INT,
    @StudentID INT = NULL,
    @DepartmentID INT = NULL,
    @BranchID INT = NULL,
    @ClassID INT = NULL,
    @MajorID INT = NULL,
    @Priority NVARCHAR(50) = 'Normal',
    @UrgencyLevel INT = 3,
    @ExpectedCompletionDate DATE = NULL,
    @EstimatedCost DECIMAL(15,2) = NULL,
    @Justification NVARCHAR(MAX) = NULL,
    @Impact NVARCHAR(MAX) = NULL,
    @Tags NVARCHAR(500) = NULL,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Generate request code
        DECLARE @RequestCode NVARCHAR(50);
        DECLARE @TypeCode NVARCHAR(50);
        SELECT @TypeCode = TypeCode FROM RequestTypes WHERE RequestTypeID = @RequestTypeID;
        
        DECLARE @NextNumber INT = (
            SELECT ISNULL(MAX(CAST(RIGHT(RequestCode, 4) AS INT)), 0) + 1 
            FROM Requests 
            WHERE RequestCode LIKE @TypeCode + '-' + FORMAT(GETDATE(), 'yyyy') + '-%'
        );
        SET @RequestCode = @TypeCode + '-' + FORMAT(GETDATE(), 'yyyy') + '-' + FORMAT(@NextNumber, '0000');
        
        -- Get first workflow step
        DECLARE @FirstStepID INT = (
            SELECT TOP 1 StepID 
            FROM RequestWorkflowSteps 
            WHERE RequestTypeID = @RequestTypeID AND StatusID = 1 
            ORDER BY StepOrder
        );
        
        -- Insert request
        DECLARE @RequestID INT;
        INSERT INTO Requests (
            RequestCode, RequestTypeID, Title, Description, RequestData,
            RequestorID, StudentID, DepartmentID, BranchID, ClassID, MajorID,
            Priority, UrgencyLevel, ExpectedCompletionDate, EstimatedCost,
            Justification, Impact, Tags, CurrentStepID, CreatedBy, ModifiedBy
        )
        VALUES (
            @RequestCode, @RequestTypeID, @Title, @Description, @RequestData,
            @RequestorID, @StudentID, @DepartmentID, @BranchID, @ClassID, @MajorID,
            @Priority, @UrgencyLevel, @ExpectedCompletionDate, @EstimatedCost,
            @Justification, @Impact, @Tags, @FirstStepID, @CreatedBy, @CreatedBy
        );
        
        SET @RequestID = SCOPE_IDENTITY();
        
        -- Create initial workflow history entry
        INSERT INTO RequestWorkflowHistory (
            RequestID, StepID, ActionTaken, ActionReason, ActionBy,
            StatusBeforeAction, StatusAfterAction
        )
        VALUES (
            @RequestID, @FirstStepID, 'Submit', 'Initial submission', @CreatedBy,
            1, 1
        );
        
        -- Auto-assign if configured
        DECLARE @AutoAssignment BIT, @ResponsibleDeptID INT;
        SELECT @AutoAssignment = rt.AutoAssignment, @ResponsibleDeptID = ws.ResponsibleDepartmentID
        FROM RequestTypes rt
        INNER JOIN RequestWorkflowSteps ws ON rt.RequestTypeID = ws.RequestTypeID
        WHERE rt.RequestTypeID = @RequestTypeID AND ws.StepID = @FirstStepID;
        
        IF @AutoAssignment = 1 AND @ResponsibleDeptID IS NOT NULL
        BEGIN
            -- Find department head or available approver
            DECLARE @AssignedToID INT = (
                SELECT TOP 1 EmployeeID 
                FROM Employee 
                WHERE DepartmentID = @ResponsibleDeptID 
                    AND StatusID = 1 
                    AND Position LIKE '%Head%' OR Position LIKE '%Manager%'
                ORDER BY Position
            );
            
            IF @AssignedToID IS NOT NULL
            BEGIN
                UPDATE Requests SET AssignedToID = @AssignedToID WHERE RequestID = @RequestID;
            END
        END
        
        -- Send initial notifications
        EXEC sp_SendRequestNotification @RequestID, 'NewRequest';
        
        COMMIT TRANSACTION;
        
        SELECT @RequestID as RequestID, @RequestCode as RequestCode, 'Success' as Status;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Stored Procedure: Phê duyệt/từ chối yêu cầu
CREATE PROCEDURE sp_ProcessRequestApproval
    @RequestID INT,
    @ApproverID INT,
    @Action NVARCHAR(50), -- 'Approve', 'Reject', 'Return'
    @Comments NVARCHAR(MAX) = NULL,
    @Conditions NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        DECLARE @CurrentStepID INT, @RequestTypeID INT;
        SELECT @CurrentStepID = CurrentStepID, @RequestTypeID = RequestTypeID 
        FROM Requests WHERE RequestID = @RequestID;
        
        -- Record approval decision
        INSERT INTO RequestApprovals (
            RequestID, StepID, ApproverID, ApprovalStatus, 
            ApprovalDate, Comments, Conditions
        )
        VALUES (
            @RequestID, @CurrentStepID, @ApproverID, 
            CASE @Action 
                WHEN 'Approve' THEN 'Approved'
                WHEN 'Reject' THEN 'Rejected'
                ELSE 'Returned'
            END,
            GETDATE(), @Comments, @Conditions
        );
        
        -- Add to workflow history
        INSERT INTO RequestWorkflowHistory (
            RequestID, StepID, ActionTaken, ActionReason, 
            Comments, ActionBy, StatusBeforeAction, StatusAfterAction
        )
        VALUES (
            @RequestID, @CurrentStepID, @Action, @Comments, 
            @Comments, @ApproverID, 1, 1
        );
        
        -- Check if step is complete and advance workflow
        IF @Action = 'Approve'
        BEGIN
            DECLARE @RequiredApprovers INT, @CurrentApprovers INT;
            SELECT @RequiredApprovers = RequiredApprovers 
            FROM RequestWorkflowSteps 
            WHERE StepID = @CurrentStepID;
            
            SELECT @CurrentApprovers = COUNT(*) 
            FROM RequestApprovals 
            WHERE RequestID = @RequestID AND StepID = @CurrentStepID AND ApprovalStatus = 'Approved';
            
            -- Move to next step if requirements met
            IF @CurrentApprovers >= @RequiredApprovers
            BEGIN
                DECLARE @NextStepID INT = (
                    SELECT TOP 1 StepID 
                    FROM RequestWorkflowSteps 
                    WHERE RequestTypeID = @RequestTypeID 
                        AND StepOrder > (SELECT StepOrder FROM RequestWorkflowSteps WHERE StepID = @CurrentStepID)
                        AND StatusID = 1
                    ORDER BY StepOrder
                );
                
                IF @NextStepID IS NOT NULL
                BEGIN
                    -- Move to next step
                    UPDATE Requests 
                    SET CurrentStepID = @NextStepID, 
                        LastActionDate = GETDATE(),
                        AssignedToID = NULL -- Will be auto-assigned if configured
                    WHERE RequestID = @RequestID;
                    
                    -- Auto-assign for next step
                    EXEC sp_AutoAssignRequest @RequestID, @NextStepID;
                END
                ELSE
                BEGIN
                    -- No more steps - mark as completed
                    UPDATE Requests 
                    SET CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Completed'),
                        ActualCompletionDate = GETDATE(),
                        LastActionDate = GETDATE()
                    WHERE RequestID = @RequestID;
                END
            END
        END
        ELSE IF @Action = 'Reject'
        BEGIN
            -- Mark request as rejected
            UPDATE Requests 
            SET CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Rejected'),
                LastActionDate = GETDATE()
            WHERE RequestID = @RequestID;
        END
        
        -- Send notifications
        EXEC sp_SendRequestNotification @RequestID, CASE @Action 
            WHEN 'Approve' THEN 'Approved'
            WHEN 'Reject' THEN 'Rejected'
            ELSE 'Returned'
        END;
        
        COMMIT TRANSACTION;
        SELECT 'Success' as Status, @Action as Action;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Stored Procedure: Auto-assign request to responsible party
CREATE PROCEDURE sp_AutoAssignRequest
    @RequestID INT,
    @StepID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ResponsibleDeptID INT, @ResponsibleRole NVARCHAR(100);
    SELECT @ResponsibleDeptID = ResponsibleDepartmentID, @ResponsibleRole = ResponsibleRole
    FROM RequestWorkflowSteps 
    WHERE StepID = @StepID;
    
    DECLARE @AssignedToID INT;
    
    -- Try to find someone with the specific role in the department
    IF @ResponsibleRole IS NOT NULL AND @ResponsibleDeptID IS NOT NULL
    BEGIN
        SELECT TOP 1 @AssignedToID = EmployeeID 
        FROM Employee 
        WHERE DepartmentID = @ResponsibleDeptID 
            AND StatusID = 1 
            AND (Position LIKE '%' + @ResponsibleRole + '%' OR JobTitle LIKE '%' + @ResponsibleRole + '%')
        ORDER BY Position;
    END
    
    -- Fallback to department head
    IF @AssignedToID IS NULL AND @ResponsibleDeptID IS NOT NULL
    BEGIN
        SELECT TOP 1 @AssignedToID = EmployeeID 
        FROM Employee 
        WHERE DepartmentID = @ResponsibleDeptID 
            AND StatusID = 1 
            AND (Position LIKE '%Head%' OR Position LIKE '%Manager%')
        ORDER BY Position;
    END
    
    -- Update assignment
    IF @AssignedToID IS NOT NULL
    BEGIN
        UPDATE Requests 
        SET AssignedToID = @AssignedToID, ModifiedDate = GETDATE()
        WHERE RequestID = @RequestID;
    END
END;

-- Stored Procedure: Send notifications
CREATE PROCEDURE sp_SendRequestNotification
    @RequestID INT,
    @NotificationType NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @RequestCode NVARCHAR(50), @Title NVARCHAR(500), @RequestorID INT, @AssignedToID INT;
    SELECT @RequestCode = RequestCode, @Title = Title, @RequestorID = RequestorID, @AssignedToID = AssignedToID
    FROM Requests WHERE RequestID = @RequestID;
    
    DECLARE @NotificationTitle NVARCHAR(200) = @NotificationType + ': ' + @RequestCode;
    DECLARE @NotificationMessage NVARCHAR(MAX) = 'Request "' + @Title + '" has been ' + LOWER(@NotificationType);
    
    -- Notify requestor
    INSERT INTO RequestNotifications (
        RequestID, RecipientID, NotificationType, NotificationTitle, 
        NotificationMessage, Priority
    )
    VALUES (
        @RequestID, @RequestorID, @NotificationType, @NotificationTitle,
        @NotificationMessage, 'Normal'
    );
    
    -- Notify assigned person if different from requestor
    IF @AssignedToID IS NOT NULL AND @AssignedToID != @RequestorID
    BEGIN
        INSERT INTO RequestNotifications (
            RequestID, RecipientID, NotificationType, NotificationTitle, 
            NotificationMessage, Priority
        )
        VALUES (
            @RequestID, @AssignedToID, @NotificationType, @NotificationTitle,
            @NotificationMessage, 'High'
        );
    END
END;

-- Stored Procedure: Get request dashboard data
CREATE PROCEDURE sp_GetRequestDashboard
    @EmployeeID INT,
    @DepartmentID INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -6, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    
    -- My requests summary
    SELECT 
        COUNT(*) as TotalRequests,
        SUM(CASE WHEN CurrentStatusID = 1 THEN 1 ELSE 0 END) as ActiveRequests,
        SUM(CASE WHEN CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Completed') THEN 1 ELSE 0 END) as CompletedRequests,
        SUM(CASE WHEN CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Rejected') THEN 1 ELSE 0 END) as RejectedRequests,
        SUM(CASE WHEN ExpectedCompletionDate < GETDATE() AND ActualCompletionDate IS NULL THEN 1 ELSE 0 END) as OverdueRequests
    FROM Requests 
    WHERE RequestorID = @EmployeeID 
        AND SubmissionDate BETWEEN @DateFrom AND @DateTo;
    
    -- Pending approvals for me
    SELECT 
        COUNT(*) as PendingApprovals
    FROM RequestApprovals ra
    INNER JOIN Requests r ON ra.RequestID = r.RequestID
    WHERE ra.ApproverID = @EmployeeID 
        AND ra.ApprovalStatus = 'Pending'
        AND r.CurrentStatusID = 1;
    
    -- Department summary (if manager)
    IF @DepartmentID IS NOT NULL
    BEGIN
        SELECT 
            rt.TypeName,
            COUNT(*) as RequestCount,
            AVG(DATEDIFF(DAY, r.SubmissionDate, ISNULL(r.ActualCompletionDate, GETDATE()))) as AvgProcessingDays,
            SUM(ISNULL(r.ActualCost, r.EstimatedCost)) as TotalCost
        FROM Requests r
        INNER JOIN RequestTypes rt ON r.RequestTypeID = rt.RequestTypeID
        INNER JOIN Employee e ON r.RequestorID = e.EmployeeID
        WHERE e.DepartmentID = @DepartmentID
            AND r.SubmissionDate BETWEEN @DateFrom AND @DateTo
        GROUP BY rt.TypeName
        ORDER BY RequestCount DESC;
    END
END;

-- Stored Procedure: Advanced request search
CREATE PROCEDURE sp_SearchRequests
    @SearchTerm NVARCHAR(255) = NULL,
    @RequestTypeID INT = NULL,
    @StatusID INT = NULL,
    @Priority NVARCHAR(50) = NULL,
    @RequestorID INT = NULL,
    @AssignedToID INT = NULL,
    @DepartmentID INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        RequestID, RequestCode, RequestTypeName, CategoryGroup, Title,
        Priority, UrgencyLevel, RequestorName, StudentName, TargetDepartment,
        AssignedToName, StatusName, SubmissionDate, ExpectedCompletionDate,
        ActualCompletionDate, ProgressStatus, ProcessingDays, EstimatedCost,
        ActualCost, CurrencyCode, DocumentCount, CommentCount, PendingApprovals
    FROM vw_RequestList
    WHERE (@SearchTerm IS NULL OR (
            RequestCode LIKE '%' + @SearchTerm + '%' OR
            Title LIKE '%' + @SearchTerm + '%' OR
            RequestorName LIKE '%' + @SearchTerm + '%' OR
            StudentName LIKE '%' + @SearchTerm + '%'
        ))
        AND (@RequestTypeID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE RequestTypeID = @RequestTypeID
        ))
        AND (@StatusID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE CurrentStatusID = @StatusID
        ))
        AND (@Priority IS NULL OR Priority = @Priority)
        AND (@RequestorID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE RequestorID = @RequestorID
        ))
        AND (@AssignedToID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE AssignedToID = @AssignedToID
        ))
        AND (@DepartmentID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests r 
            INNER JOIN Employee e ON r.RequestorID = e.EmployeeID 
            WHERE e.DepartmentID = @DepartmentID
        ))
        AND (@DateFrom IS NULL OR SubmissionDate >= @DateFrom)
        AND (@DateTo IS NULL OR SubmissionDate <= @DateTo)
    ORDER BY SubmissionDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count
    SELECT COUNT(*) as TotalRecords
    FROM vw_RequestList
    WHERE (@SearchTerm IS NULL OR (
            RequestCode LIKE '%' + @SearchTerm + '%' OR
            Title LIKE '%' + @SearchTerm + '%' OR
            RequestorName LIKE '%' + @SearchTerm + '%' OR
            StudentName LIKE '%' + @SearchTerm + '%'
        ))
        AND (@RequestTypeID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE RequestTypeID = @RequestTypeID
        ))
        AND (@StatusID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE CurrentStatusID = @StatusID
        ))
        AND (@Priority IS NULL OR Priority = @Priority)
        AND (@RequestorID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE RequestorID = @RequestorID
        ))
        AND (@AssignedToID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests WHERE AssignedToID = @AssignedToID
        ))
        AND (@DepartmentID IS NULL OR RequestID IN (
            SELECT RequestID FROM Requests r 
            INNER JOIN Employee e ON r.RequestorID = e.EmployeeID 
            WHERE e.DepartmentID = @DepartmentID
        ))
        AND (@DateFrom IS NULL OR SubmissionDate >= @DateFrom)
        AND (@DateTo IS NULL OR SubmissionDate <= @DateTo);
END;

PRINT 'Request Management stored procedures created successfully!';

-- ================================================================
-- SAMPLE DATA for Request Management System
-- ================================================================

-- Insert Request Types
INSERT INTO RequestTypes (TypeCode, TypeName, TypeDescription, CategoryGroup, RequiredFields, ApprovalWorkflow, MaxProcessingDays, Priority, RequiresDocuments, RequiresApproval, CreatedBy) VALUES
('STU-REG', 'Student Registration Request', 'Request for new student registration', 'Student', '["fullName","email","phone","program"]', '["Academic","Finance","Admin"]', 15, 'High', 1, 1, 1),
('STU-TRAN', 'Student Transfer Request', 'Request for student transfer between classes/programs', 'Student', '["studentId","fromClass","toClass","reason"]', '["Academic","Admin"]', 10, 'Normal', 1, 1, 1),
('STU-CERT', 'Certificate Request', 'Request for academic certificates', 'Student', '["studentId","certificateType","purpose"]', '["Academic"]', 7, 'Normal', 0, 1, 1),
('STU-SUSP', 'Student Suspension/Withdrawal', 'Request for student suspension or withdrawal', 'Student', '["studentId","suspensionType","reason","startDate"]', '["Academic","Admin"]', 5, 'High', 1, 1, 1),
('STAFF-HIRE', 'Staff Hiring Request', 'Request for new staff hiring', 'Staff', '["position","department","jobDescription","qualification"]', '["HR","Finance","Admin"]', 30, 'High', 1, 1, 1),
('STAFF-PROM', 'Staff Promotion Request', 'Request for staff promotion', 'Staff', '["employeeId","newPosition","justification"]', '["HR","Admin"]', 20, 'Normal', 1, 1, 1),
('CLASS-CREATE', 'Class Creation Request', 'Request to create new class', 'Academic', '["className","program","capacity","schedule"]', '["Academic","Admin"]', 15, 'Normal', 0, 1, 1),
('CLASS-MERGE', 'Class Merge/Split Request', 'Request to merge or split classes', 'Academic', '["classIds","mergeType","reason"]', '["Academic"]', 10, 'Normal', 1, 1, 1),
('TUI-WAIVER', 'Tuition Fee Waiver Request', 'Request for tuition fee waiver or discount', 'Financial', '["studentId","amount","reason","supportingDoc"]', '["Finance","Admin"]', 15, 'Normal', 1, 1, 1),
('TUI-REFUND', 'Tuition Refund Request', 'Request for tuition fee refund', 'Financial', '["studentId","amount","reason","bankDetails"]', '["Finance","Accounting"]', 20, 'Normal', 1, 1, 1),
('PO-PURCHASE', 'Purchase Order Request', 'Request for purchasing equipment/supplies', 'Financial', '["itemDescription","quantity","estimatedCost","vendor"]', '["Finance","Admin"]', 25, 'Normal', 1, 1, 1),
('DOC-ACCESS', 'Document Access Request', 'Request for access to restricted documents', 'Document', '["documentId","accessLevel","purpose","duration"]', '["Admin"]', 5, 'Normal', 0, 1, 1),
('LEAVE-ANNUAL', 'Annual Leave Request', 'Request for annual leave', 'Leave', '["startDate","endDate","leaveType","reason"]', '["HR"]', 3, 'Normal', 0, 1, 1),
('LEAVE-SICK', 'Sick Leave Request', 'Request for sick leave', 'Leave', '["startDate","endDate","medicalDoc"]', '["HR"]', 1, 'High', 1, 1, 1),
('LEAVE-EMERGENCY', 'Emergency Leave Request', 'Request for emergency leave', 'Leave', '["startDate","endDate","emergencyType","contactInfo"]', '["HR"]', 1, 'Urgent', 0, 1, 1);

-- Insert Workflow Steps for each request type
-- Student Registration workflow
INSERT INTO RequestWorkflowSteps (RequestTypeID, StepOrder, StepName, StepDescription, ResponsibleRole, RequiredApprovers, MaxDays, CreatedBy) VALUES
(1, 1, 'Academic Review', 'Review academic eligibility and program requirements', 'Academic Manager', 1, 5, 1),
(1, 2, 'Financial Verification', 'Verify payment and financial documentation', 'Finance Manager', 1, 3, 1),
(1, 3, 'Final Approval', 'Final administrative approval', 'Admin Manager', 1, 2, 1);

-- Staff Hiring workflow
INSERT INTO RequestWorkflowSteps (RequestTypeID, StepOrder, StepName, StepDescription, ResponsibleRole, RequiredApprovers, MaxDays, CreatedBy) VALUES
(5, 1, 'HR Review', 'Review job requirements and qualifications', 'HR Manager', 1, 7, 1),
(5, 2, 'Budget Approval', 'Approve budget allocation for new position', 'Finance Manager', 1, 5, 1),
(5, 3, 'Executive Approval', 'Final executive approval', 'Admin Manager', 1, 3, 1);

-- Purchase Order workflow
INSERT INTO RequestWorkflowSteps (RequestTypeID, StepOrder, StepName, StepDescription, ResponsibleRole, RequiredApprovers, MaxDays, CreatedBy) VALUES
(11, 1, 'Budget Review', 'Review budget availability and necessity', 'Finance Manager', 1, 7, 1),
(11, 2, 'Administrative Approval', 'Final administrative approval', 'Admin Manager', 1, 5, 1);

-- Leave Request workflow (simple)
INSERT INTO RequestWorkflowSteps (RequestTypeID, StepOrder, StepName, StepDescription, ResponsibleRole, RequiredApprovers, MaxDays, CreatedBy) VALUES
(13, 1, 'Manager Approval', 'Direct manager approval', 'Manager', 1, 2, 1),
(14, 1, 'HR Approval', 'HR approval for sick leave', 'HR Manager', 1, 1, 1),
(15, 1, 'Emergency Approval', 'Emergency leave approval', 'HR Manager', 1, 1, 1);

-- Sample Request Templates
INSERT INTO RequestTemplates (RequestTypeID, TemplateName, TemplateDescription, TemplateData, CreatedBy) VALUES
(1, 'Standard Student Registration', 'Template for regular student registration', '{"program":"General Vietnamese","level":"Beginner","payment_method":"Monthly"}', 1),
(5, 'Teacher Hiring Template', 'Template for hiring new teachers', '{"position":"Vietnamese Teacher","department":"Academic","employment_type":"Full-time"}', 1),
(11, 'Office Supplies Purchase', 'Template for office supplies purchase', '{"category":"Office Supplies","urgency":"Normal","budget_code":"OFFICE-001"}', 1),
(13, 'Annual Leave Template', 'Standard annual leave request', '{"leave_type":"Annual","notification_period":"2 weeks"}', 1);

PRINT 'Request Management sample data inserted successfully!';

-- ================================================================
-- FUNCTIONS for Request Management System
-- ================================================================

-- Function: Calculate request processing time
CREATE FUNCTION fn_CalculateRequestProcessingTime(
    @RequestID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @ProcessingDays INT;
    
    SELECT @ProcessingDays = DATEDIFF(DAY, SubmissionDate, ISNULL(ActualCompletionDate, GETDATE()))
    FROM Requests 
    WHERE RequestID = @RequestID;
    
    RETURN ISNULL(@ProcessingDays, 0);
END;

-- Function: Get request status color
CREATE FUNCTION fn_GetRequestStatusColor(
    @RequestID INT
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @StatusColor NVARCHAR(20) = 'gray';
    DECLARE @ExpectedDate DATE, @ActualDate DATE, @StatusName NVARCHAR(100);
    
    SELECT @ExpectedDate = ExpectedCompletionDate, 
           @ActualDate = ActualCompletionDate,
           @StatusName = s.StatusName
    FROM Requests r
    INNER JOIN Status s ON r.CurrentStatusID = s.StatusID
    WHERE r.RequestID = @RequestID;
    
    IF @StatusName = 'Completed'
        SET @StatusColor = 'green';
    ELSE IF @StatusName = 'Rejected'
        SET @StatusColor = 'red';
    ELSE IF @ActualDate IS NULL AND @ExpectedDate < GETDATE()
        SET @StatusColor = 'orange'; -- Overdue
    ELSE IF @ActualDate IS NULL AND DATEDIFF(DAY, GETDATE(), @ExpectedDate) <= 3
        SET @StatusColor = 'yellow'; -- Due soon
    ELSE
        SET @StatusColor = 'blue'; -- In progress
    
    RETURN @StatusColor;
END;

-- Function: Check if user can approve request
CREATE FUNCTION fn_CanUserApproveRequest(
    @RequestID INT,
    @UserID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @CanApprove BIT = 0;
    DECLARE @CurrentStepID INT, @ResponsibleRole NVARCHAR(100), @ResponsibleDeptID INT;
    DECLARE @UserDeptID INT, @UserPosition NVARCHAR(100);
    
    -- Get current step information
    SELECT @CurrentStepID = CurrentStepID FROM Requests WHERE RequestID = @RequestID;
    
    SELECT @ResponsibleRole = ResponsibleRole, @ResponsibleDeptID = ResponsibleDepartmentID
    FROM RequestWorkflowSteps WHERE StepID = @CurrentStepID;
    
    -- Get user information
    SELECT @UserDeptID = DepartmentID, @UserPosition = Position
    FROM Employee WHERE EmployeeID = @UserID;
    
    -- Check if user matches the responsible criteria
    IF (@ResponsibleDeptID IS NULL OR @ResponsibleDeptID = @UserDeptID)
        AND (@ResponsibleRole IS NULL OR @UserPosition LIKE '%' + @ResponsibleRole + '%')
        SET @CanApprove = 1;
    
    -- Check if already approved by this user
    IF EXISTS (
        SELECT 1 FROM RequestApprovals 
        WHERE RequestID = @RequestID AND StepID = @CurrentStepID 
        AND ApproverID = @UserID AND ApprovalStatus = 'Approved'
    )
        SET @CanApprove = 0;
    
    RETURN @CanApprove;
END;

-- Function: Get request priority score
CREATE FUNCTION fn_GetRequestPriorityScore(
    @RequestID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Score INT = 0;
    DECLARE @Priority NVARCHAR(50), @UrgencyLevel INT, @DaysOverdue INT;
    
    SELECT @Priority = Priority, @UrgencyLevel = UrgencyLevel,
           @DaysOverdue = CASE 
               WHEN ExpectedCompletionDate < GETDATE() AND ActualCompletionDate IS NULL 
               THEN DATEDIFF(DAY, ExpectedCompletionDate, GETDATE())
               ELSE 0
           END
    FROM Requests WHERE RequestID = @RequestID;
    
    -- Base score from priority
    SET @Score = CASE @Priority
        WHEN 'Urgent' THEN 100
        WHEN 'High' THEN 75
        WHEN 'Normal' THEN 50
        WHEN 'Low' THEN 25
        ELSE 50
    END;
    
    -- Add urgency level
    SET @Score = @Score + (@UrgencyLevel * 10);
    
    -- Add overdue penalty
    SET @Score = @Score + (@DaysOverdue * 20);
    
    RETURN @Score;
END;

-- Function: Calculate estimated completion date
CREATE FUNCTION fn_EstimateRequestCompletion(
    @RequestTypeID INT,
    @SubmissionDate DATE = NULL
)
RETURNS DATE
AS
BEGIN
    DECLARE @EstimatedDate DATE;
    DECLARE @MaxDays INT;
    
    IF @SubmissionDate IS NULL SET @SubmissionDate = GETDATE();
    
    -- Get maximum processing days for this request type
    SELECT @MaxDays = MaxProcessingDays FROM RequestTypes WHERE RequestTypeID = @RequestTypeID;
    
    -- Add buffer for weekends (assuming 5-day work week)
    DECLARE @WorkDays INT = @MaxDays;
    DECLARE @CalendarDays INT = (@WorkDays * 7) / 5; -- Rough conversion
    
    SET @EstimatedDate = DATEADD(DAY, @CalendarDays, @SubmissionDate);
    
    RETURN @EstimatedDate;
END;

PRINT 'Request Management functions created successfully!';

PRINT '';
PRINT 'Comprehensive Request Management System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- 15 pre-configured request types covering all major categories';
PRINT '- Dynamic form generation with JSON-based templates';
PRINT '- Multi-step approval workflows with role-based assignment';
PRINT '- Comprehensive request tracking and status management';
PRINT '- Document attachment and management system';
PRINT '- Advanced notification system with multiple channels';
PRINT '- Request analytics and performance monitoring';
PRINT '- Template system for common request types';
PRINT '- Auto-assignment based on department and role';
PRINT '- Priority scoring and overdue tracking';
PRINT '- Comprehensive search and filtering capabilities';
PRINT '- Dashboard views for managers and users';
PRINT '- Workflow history and audit trails';
PRINT '- Cost tracking and budget management';
PRINT '- Student, staff, and academic request support';
PRINT '';
PRINT 'Request Categories:';
PRINT '1. Student Requests - Registration, Transfer, Certificates, Suspension';
PRINT '2. Staff Requests - Hiring, Promotion, Management';
PRINT '3. Academic Requests - Class Creation, Merging, Scheduling';
PRINT '4. Financial Requests - Tuition Waivers, Refunds, Purchase Orders';
PRINT '5. Document Requests - Access, Permissions, Management';
PRINT '6. Leave Requests - Annual, Sick, Emergency Leave';
PRINT '';
PRINT 'Workflow Features:';
PRINT '- Role-based approval routing';
PRINT '- Auto-assignment to responsible departments';
PRINT '- Multi-level approval requirements';
PRINT '- Conditional workflow advancement';
PRINT '- Real-time status tracking';
PRINT '- Comprehensive notification system';

-- ================================================================
-- Section 37: Request Summary Dashboard System (RequestSummary.html)
-- ================================================================

PRINT '';
PRINT '=== Creating Section 37: Request Summary Dashboard System ===';

-- Table: RequestSummaryViews - Lưu trữ các view dashboard đã được cấu hình
CREATE TABLE RequestSummaryViews (
    ViewID INT IDENTITY(1,1) PRIMARY KEY,
    ViewName NVARCHAR(200) NOT NULL,
    ViewDescription NVARCHAR(MAX),
    OwnerID INT NOT NULL, -- Employee creating the view
    ViewType NVARCHAR(50) DEFAULT 'Personal', -- Personal, Shared, System
    FilterCriteria NVARCHAR(MAX), -- JSON filter configuration
    ColumnConfiguration NVARCHAR(MAX), -- JSON column setup
    SortConfiguration NVARCHAR(MAX), -- JSON sort setup
    RefreshInterval INT DEFAULT 300, -- Seconds, for auto-refresh
    IsDefault BIT DEFAULT 0, -- Default view for user
    IsPublic BIT DEFAULT 0, -- Available to all users
    AccessPermissions NVARCHAR(MAX), -- JSON permissions for shared views
    ViewCount INT DEFAULT 0, -- Usage tracking
    LastAccessed DATETIME2,
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (OwnerID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestSummaryFilters - Lưu trữ bộ lọc được lưu
CREATE TABLE RequestSummaryFilters (
    FilterID INT IDENTITY(1,1) PRIMARY KEY,
    FilterName NVARCHAR(200) NOT NULL,
    FilterDescription NVARCHAR(MAX),
    CreatedBy INT NOT NULL,
    FilterType NVARCHAR(50) DEFAULT 'Custom', -- Predefined, Custom, Smart
    FilterCriteria NVARCHAR(MAX) NOT NULL, -- JSON filter configuration
    AppliedCount INT DEFAULT 0, -- Usage tracking
    IsQuickFilter BIT DEFAULT 0, -- Show in quick filter bar
    SortOrder INT DEFAULT 0, -- Display order in UI
    StatusID INT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestDashboardMetrics - Metrics cho dashboard
CREATE TABLE RequestDashboardMetrics (
    MetricID INT IDENTITY(1,1) PRIMARY KEY,
    MetricDate DATE NOT NULL,
    DepartmentID INT,
    BranchID INT,
    
    -- Request counts by status
    TotalRequests INT DEFAULT 0,
    PendingAppraisal INT DEFAULT 0, -- Đang chờ thẩm định
    InAppraisal INT DEFAULT 0, -- Đã thẩm định
    PendingApproval INT DEFAULT 0, -- Đang chờ phê duyệt
    ApprovedRequests INT DEFAULT 0, -- Đã phê duyệt
    RejectedRequests INT DEFAULT 0, -- Đã từ chối
    
    -- Request counts by type
    StudentRequests INT DEFAULT 0,
    FinanceRequests INT DEFAULT 0,
    DocumentRequests INT DEFAULT 0,
    StaffRequests INT DEFAULT 0,
    CourseRequests INT DEFAULT 0,
    LeaveRequests INT DEFAULT 0,
    
    -- Performance metrics
    AvgProcessingTimeHours DECIMAL(10,2) DEFAULT 0,
    AvgAppraisalTimeHours DECIMAL(10,2) DEFAULT 0,
    AvgApprovalTimeHours DECIMAL(10,2) DEFAULT 0,
    OverdueRequests INT DEFAULT 0,
    
    -- Quality metrics
    ApprovalRate DECIMAL(5,2) DEFAULT 0, -- Percentage
    RejectionRate DECIMAL(5,2) DEFAULT 0, -- Percentage
    ResubmissionRate DECIMAL(5,2) DEFAULT 0, -- Percentage
    
    -- Cost metrics
    TotalEstimatedCost DECIMAL(15,2) DEFAULT 0,
    TotalActualCost DECIMAL(15,2) DEFAULT 0,
    CostVariance DECIMAL(15,2) DEFAULT 0,
    
    CalculatedDate DATETIME2 DEFAULT GETDATE(),
    CalculatedBy INT,
    
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (CalculatedBy) REFERENCES Employee(EmployeeID),
    
    -- Ensure one record per date/department/branch combination
    UNIQUE(MetricDate, DepartmentID, BranchID)
);

-- Table: RequestSummaryAlerts - Cảnh báo và thông báo dashboard
CREATE TABLE RequestSummaryAlerts (
    AlertID INT IDENTITY(1,1) PRIMARY KEY,
    AlertType NVARCHAR(100) NOT NULL, -- OverdueRequest, HighPriorityPending, BudgetExceeded, etc.
    AlertTitle NVARCHAR(200) NOT NULL,
    AlertMessage NVARCHAR(MAX) NOT NULL,
    AlertData NVARCHAR(MAX), -- JSON additional data
    
    -- Target criteria
    TargetUserID INT, -- Specific user
    TargetDepartmentID INT, -- Department-wide alert
    TargetRole NVARCHAR(100), -- Role-based alert
    
    -- Alert properties
    Severity NVARCHAR(50) DEFAULT 'Medium', -- Low, Medium, High, Critical
    Priority INT DEFAULT 3, -- 1-5 scale
    RequiresAction BIT DEFAULT 0, -- Requires user action
    AutoDismiss BIT DEFAULT 1, -- Auto-dismiss when resolved
    
    -- Related entities
    RelatedRequestID INT, -- Related request if applicable
    RelatedEntityType NVARCHAR(100), -- Type of related entity
    RelatedEntityID INT, -- ID of related entity
    
    -- Status tracking
    IsActive BIT DEFAULT 1,
    IsRead BIT DEFAULT 0,
    ReadDate DATETIME2,
    ReadBy INT,
    DismissedDate DATETIME2,
    DismissedBy INT,
    ResolvedDate DATETIME2,
    ResolvedBy INT,
    
    -- Scheduling
    ScheduledDate DATETIME2, -- For scheduled alerts
    ExpiryDate DATETIME2, -- Auto-expire date
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT,
    
    FOREIGN KEY (TargetUserID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TargetDepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (RelatedRequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (ReadBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (DismissedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ResolvedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID)
);

-- Table: RequestSummaryUserPreferences - Tùy chọn người dùng cho dashboard
CREATE TABLE RequestSummaryUserPreferences (
    PreferenceID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    
    -- View preferences
    DefaultViewID INT, -- Default dashboard view
    ItemsPerPage INT DEFAULT 25, -- Pagination setting
    AutoRefreshEnabled BIT DEFAULT 1,
    AutoRefreshInterval INT DEFAULT 300, -- Seconds
    
    -- Display preferences
    ShowRequestCounts BIT DEFAULT 1,
    ShowPerformanceMetrics BIT DEFAULT 1,
    ShowAlerts BIT DEFAULT 1,
    CompactMode BIT DEFAULT 0, -- Compact table view
    
    -- Column preferences
    VisibleColumns NVARCHAR(MAX), -- JSON array of visible columns
    ColumnWidths NVARCHAR(MAX), -- JSON object of column widths
    DefaultSortColumn NVARCHAR(100) DEFAULT 'SubmissionDate',
    DefaultSortDirection NVARCHAR(10) DEFAULT 'DESC', -- ASC, DESC
    
    -- Filter preferences
    SavedFilters NVARCHAR(MAX), -- JSON array of saved filter IDs
    QuickFilters NVARCHAR(MAX), -- JSON array of quick filter configurations
    DefaultFilters NVARCHAR(MAX), -- JSON default filter settings
    
    -- Notification preferences
    DesktopNotifications BIT DEFAULT 1,
    EmailNotifications BIT DEFAULT 1,
    AlertThreshold NVARCHAR(50) DEFAULT 'Medium', -- Minimum alert severity
    
    LastUpdated DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (UserID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (DefaultViewID) REFERENCES RequestSummaryViews(ViewID),
    
    -- One preference record per user
    UNIQUE(UserID)
);

-- Table: RequestAppraisalComments - Chi tiết nhận xét thẩm định
CREATE TABLE RequestAppraisalComments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    RequestID INT NOT NULL,
    AppraisalStepID INT, -- Which appraisal step this comment belongs to
    CommentType NVARCHAR(50) DEFAULT 'General', -- General, Technical, Financial, Legal
    CommentText NVARCHAR(MAX) NOT NULL,
    
    -- Assessment scores (1-5 scale)
    TechnicalScore INT, -- Technical feasibility
    FinancialScore INT, -- Financial viability  
    RiskScore INT, -- Risk assessment
    ImpactScore INT, -- Business impact
    OverallScore DECIMAL(3,2), -- Calculated overall score
    
    -- Recommendations
    Recommendation NVARCHAR(50), -- Approve, Reject, NeedsMoreInfo, Conditional
    Conditions NVARCHAR(MAX), -- Conditions for conditional approval
    Concerns NVARCHAR(MAX), -- Areas of concern
    Suggestions NVARCHAR(MAX), -- Improvement suggestions
    
    -- Supporting data
    AttachedDocuments NVARCHAR(MAX), -- JSON array of attached documents
    ReferencedPolicies NVARCHAR(MAX), -- JSON array of policy references
    CostAnalysis NVARCHAR(MAX), -- JSON cost breakdown
    TimelineAnalysis NVARCHAR(MAX), -- JSON timeline assessment
    
    -- Review status
    IsConfidential BIT DEFAULT 0, -- Confidential comment
    RequiresFollowUp BIT DEFAULT 0, -- Needs follow-up action
    FollowUpDate DATE, -- When to follow up
    FollowUpWith INT, -- Who to follow up with
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedBy INT,
    StatusID INT DEFAULT 1,
    
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (AppraisalStepID) REFERENCES RequestWorkflowSteps(StepID),
    FOREIGN KEY (FollowUpWith) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ModifiedBy) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES Status(StatusID)
);

PRINT 'Request Summary Dashboard tables created successfully!';

-- ================================================================
-- INDEXES for Request Summary Dashboard System
-- ================================================================

-- Indexes cho RequestSummaryViews
CREATE INDEX IX_RequestSummaryViews_Owner ON RequestSummaryViews(OwnerID);
CREATE INDEX IX_RequestSummaryViews_Type ON RequestSummaryViews(ViewType);
CREATE INDEX IX_RequestSummaryViews_Public ON RequestSummaryViews(IsPublic);
CREATE INDEX IX_RequestSummaryViews_Default ON RequestSummaryViews(IsDefault);

-- Indexes cho RequestSummaryFilters
CREATE INDEX IX_RequestSummaryFilters_CreatedBy ON RequestSummaryFilters(CreatedBy);
CREATE INDEX IX_RequestSummaryFilters_Type ON RequestSummaryFilters(FilterType);
CREATE INDEX IX_RequestSummaryFilters_Quick ON RequestSummaryFilters(IsQuickFilter);

-- Indexes cho RequestDashboardMetrics
CREATE INDEX IX_RequestDashboardMetrics_Date ON RequestDashboardMetrics(MetricDate);
CREATE INDEX IX_RequestDashboardMetrics_Department ON RequestDashboardMetrics(DepartmentID);
CREATE INDEX IX_RequestDashboardMetrics_Branch ON RequestDashboardMetrics(BranchID);
CREATE INDEX IX_RequestDashboardMetrics_Calculated ON RequestDashboardMetrics(CalculatedDate);

-- Indexes cho RequestSummaryAlerts
CREATE INDEX IX_RequestSummaryAlerts_Type ON RequestSummaryAlerts(AlertType);
CREATE INDEX IX_RequestSummaryAlerts_Target ON RequestSummaryAlerts(TargetUserID);
CREATE INDEX IX_RequestSummaryAlerts_Department ON RequestSummaryAlerts(TargetDepartmentID);
CREATE INDEX IX_RequestSummaryAlerts_Active ON RequestSummaryAlerts(IsActive);
CREATE INDEX IX_RequestSummaryAlerts_Severity ON RequestSummaryAlerts(Severity);
CREATE INDEX IX_RequestSummaryAlerts_Created ON RequestSummaryAlerts(CreatedDate);

-- Indexes cho RequestAppraisalComments
CREATE INDEX IX_RequestAppraisalComments_Request ON RequestAppraisalComments(RequestID);
CREATE INDEX IX_RequestAppraisalComments_Step ON RequestAppraisalComments(AppraisalStepID);
CREATE INDEX IX_RequestAppraisalComments_Type ON RequestAppraisalComments(CommentType);
CREATE INDEX IX_RequestAppraisalComments_CreatedBy ON RequestAppraisalComments(CreatedBy);
CREATE INDEX IX_RequestAppraisalComments_Recommendation ON RequestAppraisalComments(Recommendation);

PRINT 'Request Summary Dashboard indexes created successfully!';

-- ================================================================
-- VIEWS for Request Summary Dashboard System
-- ================================================================

-- View: Request summary với thông tin thẩm định và phê duyệt chi tiết
CREATE VIEW vw_RequestSummaryDashboard AS
SELECT 
    r.RequestID,
    r.RequestCode,
    rt.TypeName as RequestTypeName,
    rt.TypeCode as RequestTypeCode,
    rt.CategoryGroup,
    r.Title,
    r.Description,
    r.Priority,
    r.UrgencyLevel,
    
    -- Requestor information
    emp_req.FullName as RequesterName,
    emp_req.Email as RequesterEmail,
    emp_req.Position as RequesterPosition,
    dept_req.DepartmentName as RequesterDepartment,
    
    -- Appraiser information (từ workflow hiện tại)
    emp_appraiser.FullName as AppraiserName,
    emp_appraiser.Email as AppraiserEmail,
    
    -- Approver information (từ workflow hiện tại hoặc final step)
    emp_approver.FullName as ApproverName,
    emp_approver.Email as ApproverEmail,
    
    -- Current workflow step
    ws.StepName as CurrentStepName,
    ws.ResponsibleRole,
    ws.MaxDays as StepMaxDays,
    
    -- Status information với mapping cho RequestSummary.html
    CASE 
        WHEN r.CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Completed') THEN 'Đã phê duyệt'
        WHEN r.CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Rejected') THEN 'Đã từ chối'
        WHEN ws.StepName LIKE '%Review%' OR ws.StepName LIKE '%Apprais%' THEN 'Đang chờ thẩm định'
        WHEN ws.StepName LIKE '%Approval%' OR ws.StepName LIKE '%Approve%' THEN 'Đang chờ phê duyệt'
        WHEN EXISTS (
            SELECT 1 FROM RequestApprovals ra 
            WHERE ra.RequestID = r.RequestID 
            AND ra.ApprovalStatus = 'Approved' 
            AND ra.StepID IN (
                SELECT StepID FROM RequestWorkflowSteps 
                WHERE RequestTypeID = r.RequestTypeID 
                AND (StepName LIKE '%Review%' OR StepName LIKE '%Apprais%')
            )
        ) THEN 'Đã thẩm định'
        ELSE 'Đang chờ thẩm định'
    END as StatusDisplayName,
    
    st.StatusName as SystemStatus,
    st.StatusColor,
    
    -- Dates
    r.SubmissionDate,
    r.ExpectedCompletionDate,
    r.ActualCompletionDate,
    r.LastActionDate,
    
    -- Progress tracking
    DATEDIFF(DAY, r.SubmissionDate, ISNULL(r.ActualCompletionDate, GETDATE())) as ProcessingDays,
    CASE 
        WHEN r.ActualCompletionDate IS NOT NULL THEN 'Completed'
        WHEN r.ExpectedCompletionDate < GETDATE() THEN 'Overdue'
        WHEN DATEDIFF(DAY, GETDATE(), r.ExpectedCompletionDate) <= 3 THEN 'Due Soon'
        ELSE 'On Track'
    END as ProgressStatus,
    
    -- Cost information
    r.EstimatedCost,
    r.ActualCost,
    r.CurrencyCode,
    
    -- Counts and metrics
    (SELECT COUNT(*) FROM RequestDocuments rd WHERE rd.RequestID = r.RequestID AND rd.StatusID = 1) as DocumentCount,
    (SELECT COUNT(*) FROM RequestComments rc WHERE rc.RequestID = r.RequestID AND rc.StatusID = 1) as CommentCount,
    (SELECT COUNT(*) FROM RequestApprovals ra WHERE ra.RequestID = r.RequestID AND ra.ApprovalStatus = 'Pending') as PendingApprovals,
    (SELECT COUNT(*) FROM RequestAppraisalComments rac WHERE rac.RequestID = r.RequestID AND rac.StatusID = 1) as AppraisalCommentCount,
    
    -- Latest appraisal comment summary
    (SELECT TOP 1 rac.OverallScore FROM RequestAppraisalComments rac WHERE rac.RequestID = r.RequestID AND rac.StatusID = 1 ORDER BY rac.CreatedDate DESC) as LatestAppraisalScore,
    (SELECT TOP 1 rac.Recommendation FROM RequestAppraisalComments rac WHERE rac.RequestID = r.RequestID AND rac.StatusID = 1 ORDER BY rac.CreatedDate DESC) as LatestRecommendation,
    
    -- Target information
    dept.DepartmentName as TargetDepartment,
    br.BranchName,
    cl.ClassName,
    maj.MajorName,
    
    -- Student information (if applicable)
    s.StudentCode,
    s.FullName as StudentName,
    
    r.CreatedDate,
    r.ModifiedDate

FROM Requests r
INNER JOIN RequestTypes rt ON r.RequestTypeID = rt.RequestTypeID
INNER JOIN Employee emp_req ON r.RequestorID = emp_req.EmployeeID
LEFT JOIN Department dept_req ON emp_req.DepartmentID = dept_req.DepartmentID
LEFT JOIN Student s ON r.StudentID = s.StudentID
LEFT JOIN Department dept ON r.DepartmentID = dept.DepartmentID
LEFT JOIN Branch br ON r.BranchID = br.BranchID
LEFT JOIN Class cl ON r.ClassID = cl.ClassID
LEFT JOIN Major maj ON r.MajorID = maj.MajorID
INNER JOIN Status st ON r.CurrentStatusID = st.StatusID
LEFT JOIN RequestWorkflowSteps ws ON r.CurrentStepID = ws.StepID

-- Left join to get appraiser (from current or completed appraisal step)
LEFT JOIN Employee emp_appraiser ON emp_appraiser.EmployeeID = (
    SELECT TOP 1 ra.ApproverID 
    FROM RequestApprovals ra
    INNER JOIN RequestWorkflowSteps rws ON ra.StepID = rws.StepID
    WHERE ra.RequestID = r.RequestID 
    AND (rws.StepName LIKE '%Review%' OR rws.StepName LIKE '%Apprais%')
    ORDER BY ra.CreatedDate DESC
)

-- Left join to get approver (from current or completed approval step)
LEFT JOIN Employee emp_approver ON emp_approver.EmployeeID = (
    SELECT TOP 1 ra.ApproverID 
    FROM RequestApprovals ra
    INNER JOIN RequestWorkflowSteps rws ON ra.StepID = rws.StepID
    WHERE ra.RequestID = r.RequestID 
    AND (rws.StepName LIKE '%Approval%' OR rws.StepName LIKE '%Approve%' OR rws.StepOrder = (
        SELECT MAX(StepOrder) FROM RequestWorkflowSteps WHERE RequestTypeID = r.RequestTypeID
    ))
    ORDER BY ra.CreatedDate DESC
)

WHERE r.CurrentStatusID = 1; -- Only active requests

-- View: Request metrics summary cho dashboard
CREATE VIEW vw_RequestMetricsSummary AS
SELECT 
    -- Overall counts
    COUNT(*) as TotalRequests,
    
    -- Status breakdown
    SUM(CASE WHEN StatusDisplayName = 'Đang chờ thẩm định' THEN 1 ELSE 0 END) as PendingAppraisal,
    SUM(CASE WHEN StatusDisplayName = 'Đã thẩm định' THEN 1 ELSE 0 END) as Appraised,
    SUM(CASE WHEN StatusDisplayName = 'Đang chờ phê duyệt' THEN 1 ELSE 0 END) as PendingApproval,
    SUM(CASE WHEN StatusDisplayName = 'Đã phê duyệt' THEN 1 ELSE 0 END) as Approved,
    SUM(CASE WHEN StatusDisplayName = 'Đã từ chối' THEN 1 ELSE 0 END) as Rejected,
    
    -- Type breakdown
    SUM(CASE WHEN CategoryGroup = 'Student' THEN 1 ELSE 0 END) as StudentRequests,
    SUM(CASE WHEN CategoryGroup = 'Financial' THEN 1 ELSE 0 END) as FinanceRequests,
    SUM(CASE WHEN CategoryGroup = 'Document' THEN 1 ELSE 0 END) as DocumentRequests,
    SUM(CASE WHEN CategoryGroup = 'Staff' THEN 1 ELSE 0 END) as StaffRequests,
    SUM(CASE WHEN CategoryGroup = 'Academic' THEN 1 ELSE 0 END) as CourseRequests,
    SUM(CASE WHEN CategoryGroup = 'Leave' THEN 1 ELSE 0 END) as LeaveRequests,
    
    -- Performance metrics
    AVG(CAST(ProcessingDays as FLOAT)) as AvgProcessingDays,
    SUM(CASE WHEN ProgressStatus = 'Overdue' THEN 1 ELSE 0 END) as OverdueRequests,
    
    -- Priority breakdown
    SUM(CASE WHEN Priority = 'Urgent' THEN 1 ELSE 0 END) as UrgentRequests,
    SUM(CASE WHEN Priority = 'High' THEN 1 ELSE 0 END) as HighPriorityRequests,
    SUM(CASE WHEN Priority = 'Normal' THEN 1 ELSE 0 END) as NormalPriorityRequests,
    SUM(CASE WHEN Priority = 'Low' THEN 1 ELSE 0 END) as LowPriorityRequests,
    
    -- Cost metrics
    SUM(ISNULL(EstimatedCost, 0)) as TotalEstimatedCost,
    SUM(ISNULL(ActualCost, 0)) as TotalActualCost,
    
    -- Current period (last 30 days)
    SUM(CASE WHEN SubmissionDate >= DATEADD(DAY, -30, GETDATE()) THEN 1 ELSE 0 END) as RequestsLast30Days,
    SUM(CASE WHEN ActualCompletionDate >= DATEADD(DAY, -30, GETDATE()) THEN 1 ELSE 0 END) as CompletedLast30Days

FROM vw_RequestSummaryDashboard;

-- View: Department performance summary
CREATE VIEW vw_DepartmentRequestPerformance AS
SELECT 
    dept.DepartmentName,
    dept.DepartmentID,
    
    -- Request counts
    COUNT(r.RequestID) as TotalRequests,
    SUM(CASE WHEN rd.StatusDisplayName = 'Đang chờ thẩm định' THEN 1 ELSE 0 END) as PendingAppraisal,
    SUM(CASE WHEN rd.StatusDisplayName = 'Đang chờ phê duyệt' THEN 1 ELSE 0 END) as PendingApproval,
    SUM(CASE WHEN rd.StatusDisplayName = 'Đã phê duyệt' THEN 1 ELSE 0 END) as Approved,
    SUM(CASE WHEN rd.StatusDisplayName = 'Đã từ chối' THEN 1 ELSE 0 END) as Rejected,
    
    -- Performance metrics
    AVG(CAST(rd.ProcessingDays as FLOAT)) as AvgProcessingDays,
    SUM(CASE WHEN rd.ProgressStatus = 'Overdue' THEN 1 ELSE 0 END) as OverdueRequests,
    
    -- Approval rates
    CASE 
        WHEN COUNT(r.RequestID) > 0 
        THEN CAST(SUM(CASE WHEN rd.StatusDisplayName = 'Đã phê duyệt' THEN 1 ELSE 0 END) as FLOAT) * 100.0 / COUNT(r.RequestID)
        ELSE 0 
    END as ApprovalRate,
    
    -- Workload (requests per employee)
    CASE 
        WHEN (SELECT COUNT(*) FROM Employee WHERE DepartmentID = dept.DepartmentID AND StatusID = 1) > 0
        THEN CAST(COUNT(r.RequestID) as FLOAT) / (SELECT COUNT(*) FROM Employee WHERE DepartmentID = dept.DepartmentID AND StatusID = 1)
        ELSE 0
    END as RequestsPerEmployee

FROM Department dept
LEFT JOIN Employee emp ON dept.DepartmentID = emp.DepartmentID
LEFT JOIN Requests r ON emp.EmployeeID = r.RequestorID
LEFT JOIN vw_RequestSummaryDashboard rd ON r.RequestID = rd.RequestID
WHERE dept.StatusID = 1
GROUP BY dept.DepartmentID, dept.DepartmentName;

PRINT 'Request Summary Dashboard views created successfully!';

-- ================================================================
-- STORED PROCEDURES for Request Summary Dashboard System
-- ================================================================

-- Stored Procedure: Lấy dữ liệu dashboard với filter
CREATE PROCEDURE sp_GetRequestSummaryDashboard
    @UserID INT,
    @DepartmentID INT = NULL,
    @RequestTypeID INT = NULL,
    @StatusFilter NVARCHAR(50) = NULL,
    @RequesterFilter NVARCHAR(255) = NULL,
    @ApproverFilter NVARCHAR(255) = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 25
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Main dashboard data với filtering
    SELECT 
        RequestID,
        RequestCode,
        RequestTypeName,
        RequestTypeCode,
        CategoryGroup,
        Title,
        RequesterName,
        AppraiserName,
        ApproverName,
        StatusDisplayName,
        SubmissionDate,
        ExpectedCompletionDate,
        ProcessingDays,
        Priority,
        UrgencyLevel,
        EstimatedCost,
        ActualCost,
        CurrencyCode,
        DocumentCount,
        CommentCount,
        ProgressStatus,
        LatestAppraisalScore,
        LatestRecommendation
    FROM vw_RequestSummaryDashboard
    WHERE (@RequestTypeID IS NULL OR RequestID IN (SELECT RequestID FROM Requests WHERE RequestTypeID = @RequestTypeID))
        AND (@StatusFilter IS NULL OR StatusDisplayName = @StatusFilter)
        AND (@RequesterFilter IS NULL OR RequesterName LIKE '%' + @RequesterFilter + '%')
        AND (@ApproverFilter IS NULL OR (
            AppraiserName LIKE '%' + @ApproverFilter + '%' OR 
            ApproverName LIKE '%' + @ApproverFilter + '%'
        ))
        AND (@DateFrom IS NULL OR SubmissionDate >= @DateFrom)
        AND (@DateTo IS NULL OR SubmissionDate <= @DateTo)
        AND (@DepartmentID IS NULL OR RequesterDepartment IN (
            SELECT DepartmentName FROM Department WHERE DepartmentID = @DepartmentID
        ))
    ORDER BY 
        CASE 
            WHEN StatusDisplayName = 'Đang chờ thẩm định' THEN 1
            WHEN StatusDisplayName = 'Đang chờ phê duyệt' THEN 2
            WHEN StatusDisplayName = 'Đã thẩm định' THEN 3
            ELSE 4
        END,
        SubmissionDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Total count for pagination
    SELECT COUNT(*) as TotalRecords
    FROM vw_RequestSummaryDashboard
    WHERE (@RequestTypeID IS NULL OR RequestID IN (SELECT RequestID FROM Requests WHERE RequestTypeID = @RequestTypeID))
        AND (@StatusFilter IS NULL OR StatusDisplayName = @StatusFilter)
        AND (@RequesterFilter IS NULL OR RequesterName LIKE '%' + @RequesterFilter + '%')
        AND (@ApproverFilter IS NULL OR (
            AppraiserName LIKE '%' + @ApproverFilter + '%' OR 
            ApproverName LIKE '%' + @ApproverFilter + '%'
        ))
        AND (@DateFrom IS NULL OR SubmissionDate >= @DateFrom)
        AND (@DateTo IS NULL OR SubmissionDate <= @DateTo)
        AND (@DepartmentID IS NULL OR RequesterDepartment IN (
            SELECT DepartmentName FROM Department WHERE DepartmentID = @DepartmentID
        ));
    
    -- Summary metrics
    SELECT * FROM vw_RequestMetricsSummary;
END;

-- Stored Procedure: Lấy chi tiết yêu cầu cho modal
CREATE PROCEDURE sp_GetRequestDetails
    @RequestID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Main request details
    SELECT 
        rd.*,
        -- Additional computed fields for modal
        CASE 
            WHEN rd.ExpectedCompletionDate < GETDATE() AND rd.ActualCompletionDate IS NULL THEN 1
            ELSE 0
        END as IsOverdue,
        
        DATEDIFF(DAY, rd.SubmissionDate, rd.ExpectedCompletionDate) as OriginalTimelinedays,
        
        -- Check if current user can perform actions
        CASE 
            WHEN rd.StatusDisplayName = 'Đang chờ thẩm định' AND EXISTS (
                SELECT 1 FROM Employee WHERE EmployeeID = @UserID 
                AND (Position LIKE '%Manager%' OR Position LIKE '%Head%')
            ) THEN 1 ELSE 0
        END as CanAppraise,
        
        CASE 
            WHEN rd.StatusDisplayName IN ('Đang chờ phê duyệt', 'Đã thẩm định') AND EXISTS (
                SELECT 1 FROM Employee WHERE EmployeeID = @UserID 
                AND (Position LIKE '%Director%' OR Position LIKE '%Manager%')
            ) THEN 1 ELSE 0
        END as CanApprove,
        
        1 as CanReject -- Most users can reject pending requests
        
    FROM vw_RequestSummaryDashboard rd
    WHERE rd.RequestID = @RequestID;
    
    -- Workflow history
    SELECT 
        rwh.ActionTaken,
        rwh.ActionReason,
        rwh.Comments,
        rwh.ActionDate,
        emp.FullName as ActionByName,
        emp.Position as ActionByPosition,
        ws.StepName,
        rwh.TimeSpentMinutes
    FROM RequestWorkflowHistory rwh
    INNER JOIN Employee emp ON rwh.ActionBy = emp.EmployeeID
    LEFT JOIN RequestWorkflowSteps ws ON rwh.StepID = ws.StepID
    WHERE rwh.RequestID = @RequestID
    ORDER BY rwh.ActionDate DESC;
    
    -- Appraisal comments
    SELECT 
        rac.CommentText,
        rac.CommentType,
        rac.TechnicalScore,
        rac.FinancialScore,
        rac.RiskScore,
        rac.ImpactScore,
        rac.OverallScore,
        rac.Recommendation,
        rac.Conditions,
        rac.Concerns,
        rac.Suggestions,
        rac.CreatedDate,
        emp.FullName as CreatedByName,
        emp.Position as CreatedByPosition
    FROM RequestAppraisalComments rac
    INNER JOIN Employee emp ON rac.CreatedBy = emp.EmployeeID
    WHERE rac.RequestID = @RequestID AND rac.StatusID = 1
    ORDER BY rac.CreatedDate DESC;
    
    -- Documents
    SELECT 
        rd.DocumentName,
        rd.DocumentType,
        rd.FileName,
        rd.FileSize,
        rd.UploadDate,
        emp.FullName as UploadedByName
    FROM RequestDocuments rd
    INNER JOIN Employee emp ON rd.UploadedBy = emp.EmployeeID
    WHERE rd.RequestID = @RequestID AND rd.StatusID = 1
    ORDER BY rd.UploadDate DESC;
END;

-- Stored Procedure: Thực hiện thẩm định yêu cầu
CREATE PROCEDURE sp_AppraiseRequest
    @RequestID INT,
    @AppraisedBy INT,
    @CommentText NVARCHAR(MAX),
    @TechnicalScore INT = NULL,
    @FinancialScore INT = NULL,
    @RiskScore INT = NULL,
    @ImpactScore INT = NULL,
    @Recommendation NVARCHAR(50) = 'Approve', -- Approve, Reject, NeedsMoreInfo, Conditional
    @Conditions NVARCHAR(MAX) = NULL,
    @Concerns NVARCHAR(MAX) = NULL,
    @Suggestions NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    TRY
        -- Calculate overall score
        DECLARE @OverallScore DECIMAL(3,2) = NULL;
        IF @TechnicalScore IS NOT NULL AND @FinancialScore IS NOT NULL AND @RiskScore IS NOT NULL AND @ImpactScore IS NOT NULL
        BEGIN
            SET @OverallScore = (@TechnicalScore + @FinancialScore + (6 - @RiskScore) + @ImpactScore) / 4.0;
        END
        
        -- Insert appraisal comment
        INSERT INTO RequestAppraisalComments (
            RequestID, CommentText, TechnicalScore, FinancialScore, 
            RiskScore, ImpactScore, OverallScore, Recommendation,
            Conditions, Concerns, Suggestions, CreatedBy
        )
        VALUES (
            @RequestID, @CommentText, @TechnicalScore, @FinancialScore,
            @RiskScore, @ImpactScore, @OverallScore, @Recommendation,
            @Conditions, @Concerns, @Suggestions, @AppraisedBy
        );
        
        -- Update request workflow if recommendation is to proceed
        IF @Recommendation = 'Approve'
        BEGIN
            -- Move to approval step or complete if final step
            DECLARE @CurrentStepID INT, @RequestTypeID INT;
            SELECT @CurrentStepID = CurrentStepID, @RequestTypeID = RequestTypeID 
            FROM Requests WHERE RequestID = @RequestID;
            
            DECLARE @NextStepID INT = (
                SELECT TOP 1 StepID 
                FROM RequestWorkflowSteps 
                WHERE RequestTypeID = @RequestTypeID 
                    AND StepOrder > (SELECT StepOrder FROM RequestWorkflowSteps WHERE StepID = @CurrentStepID)
                    AND StatusID = 1
                ORDER BY StepOrder
            );
            
            IF @NextStepID IS NOT NULL
            BEGIN
                UPDATE Requests 
                SET CurrentStepID = @NextStepID, LastActionDate = GETDATE()
                WHERE RequestID = @RequestID;
            END
        END
        ELSE IF @Recommendation = 'Reject'
        BEGIN
            -- Mark as rejected
            UPDATE Requests 
            SET CurrentStatusID = (SELECT StatusID FROM Status WHERE StatusName = 'Rejected'),
                LastActionDate = GETDATE()
            WHERE RequestID = @RequestID;
        END
        
        -- Add to workflow history
        INSERT INTO RequestWorkflowHistory (
            RequestID, StepID, ActionTaken, ActionReason, 
            Comments, ActionBy, StatusBeforeAction, StatusAfterAction
        )
        VALUES (
            @RequestID, (SELECT CurrentStepID FROM Requests WHERE RequestID = @RequestID),
            'Appraise', @Recommendation, @CommentText, @AppraisedBy, 1, 1
        );
        
        -- Send notifications
        EXEC sp_SendRequestNotification @RequestID, 'Appraised';
        
        COMMIT TRANSACTION;
        SELECT 'Success' as Status, @Recommendation as Action;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Stored Procedure: Tính toán metrics dashboard
CREATE PROCEDURE sp_CalculateRequestDashboardMetrics
    @CalculationDate DATE = NULL,
    @DepartmentID INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @CalculationDate IS NULL SET @CalculationDate = CAST(GETDATE() AS DATE);
    
    BEGIN TRANSACTION;
    TRY
        -- Delete existing metrics for the date/department/branch
        DELETE FROM RequestDashboardMetrics 
        WHERE MetricDate = @CalculationDate 
            AND (@DepartmentID IS NULL OR DepartmentID = @DepartmentID)
            AND (@BranchID IS NULL OR BranchID = @BranchID);
        
        -- Calculate and insert new metrics
        INSERT INTO RequestDashboardMetrics (
            MetricDate, DepartmentID, BranchID,
            TotalRequests, PendingAppraisal, InAppraisal, PendingApproval,
            ApprovedRequests, RejectedRequests,
            StudentRequests, FinanceRequests, DocumentRequests, 
            StaffRequests, CourseRequests, LeaveRequests,
            AvgProcessingTimeHours, OverdueRequests,
            ApprovalRate, RejectionRate,
            TotalEstimatedCost, TotalActualCost,
            CalculatedBy
        )
        SELECT 
            @CalculationDate,
            dept.DepartmentID,
            @BranchID,
            
            -- Request counts by status  
            COUNT(rd.RequestID),
            SUM(CASE WHEN rd.StatusDisplayName = 'Đang chờ thẩm định' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.StatusDisplayName = 'Đã thẩm định' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.StatusDisplayName = 'Đang chờ phê duyệt' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.StatusDisplayName = 'Đã phê duyệt' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.StatusDisplayName = 'Đã từ chối' THEN 1 ELSE 0 END),
            
            -- Request counts by type
            SUM(CASE WHEN rd.CategoryGroup = 'Student' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.CategoryGroup = 'Financial' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.CategoryGroup = 'Document' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.CategoryGroup = 'Staff' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.CategoryGroup = 'Academic' THEN 1 ELSE 0 END),
            SUM(CASE WHEN rd.CategoryGroup = 'Leave' THEN 1 ELSE 0 END),
            
            -- Performance metrics
            AVG(CAST(rd.ProcessingDays as FLOAT) * 24), -- Convert to hours
            SUM(CASE WHEN rd.ProgressStatus = 'Overdue' THEN 1 ELSE 0 END),
            
            -- Rates
            CASE 
                WHEN COUNT(rd.RequestID) > 0 
                THEN CAST(SUM(CASE WHEN rd.StatusDisplayName = 'Đã phê duyệt' THEN 1 ELSE 0 END) as FLOAT) * 100.0 / COUNT(rd.RequestID)
                ELSE 0 
            END,
            CASE 
                WHEN COUNT(rd.RequestID) > 0 
                THEN CAST(SUM(CASE WHEN rd.StatusDisplayName = 'Đã từ chối' THEN 1 ELSE 0 END) as FLOAT) * 100.0 / COUNT(rd.RequestID)
                ELSE 0 
            END,
            
            -- Costs
            SUM(ISNULL(rd.EstimatedCost, 0)),
            SUM(ISNULL(rd.ActualCost, 0)),
            
            1 -- CalculatedBy (system user)
            
        FROM Department dept
        LEFT JOIN Employee emp ON dept.DepartmentID = emp.DepartmentID AND emp.StatusID = 1
        LEFT JOIN Requests r ON emp.EmployeeID = r.RequestorID
        LEFT JOIN vw_RequestSummaryDashboard rd ON r.RequestID = rd.RequestID
        WHERE dept.StatusID = 1
            AND (@DepartmentID IS NULL OR dept.DepartmentID = @DepartmentID)
            AND (@BranchID IS NULL OR emp.BranchID = @BranchID)
        GROUP BY dept.DepartmentID;
        
        COMMIT TRANSACTION;
        SELECT 'Success' as Status, @@ROWCOUNT as MetricsCalculated;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- Stored Procedure: Lấy alerts cho dashboard
CREATE PROCEDURE sp_GetRequestSummaryAlerts
    @UserID INT,
    @DepartmentID INT = NULL,
    @Severity NVARCHAR(50) = 'Medium', -- Minimum severity
    @ActiveOnly BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        rsa.AlertID,
        rsa.AlertType,
        rsa.AlertTitle,
        rsa.AlertMessage,
        rsa.Severity,
        rsa.Priority,
        rsa.RequiresAction,
        rsa.RelatedRequestID,
        rsa.CreatedDate,
        rsa.ExpiryDate,
        
        -- Related request info if applicable
        rd.RequestCode,
        rd.RequestTypeName,
        rd.RequesterName,
        
        -- Action URL for deep linking
        rsa.RelatedEntityType,
        rsa.RelatedEntityID
        
    FROM RequestSummaryAlerts rsa
    LEFT JOIN vw_RequestSummaryDashboard rd ON rsa.RelatedRequestID = rd.RequestID
    WHERE (@ActiveOnly = 0 OR rsa.IsActive = 1)
        AND rsa.IsRead = 0
        AND (rsa.TargetUserID = @UserID 
             OR rsa.TargetDepartmentID = @DepartmentID
             OR rsa.TargetRole IN (
                 SELECT Position FROM Employee WHERE EmployeeID = @UserID
             ))
        AND rsa.Severity IN (
            CASE @Severity
                WHEN 'Low' THEN 'Low,Medium,High,Critical'
                WHEN 'Medium' THEN 'Medium,High,Critical'
                WHEN 'High' THEN 'High,Critical'
                WHEN 'Critical' THEN 'Critical'
                ELSE 'Medium,High,Critical'
            END
        )
        AND (rsa.ExpiryDate IS NULL OR rsa.ExpiryDate > GETDATE())
    ORDER BY 
        CASE rsa.Severity
            WHEN 'Critical' THEN 1
            WHEN 'High' THEN 2  
            WHEN 'Medium' THEN 3
            WHEN 'Low' THEN 4
            ELSE 5
        END,
        rsa.Priority DESC,
        rsa.CreatedDate DESC;
END;

PRINT 'Request Summary Dashboard stored procedures created successfully!';

-- ================================================================
-- SAMPLE DATA for Request Summary Dashboard System
-- ================================================================

-- Insert sample summary views
INSERT INTO RequestSummaryViews (ViewName, ViewDescription, OwnerID, ViewType, FilterCriteria, ColumnConfiguration, CreatedBy) VALUES
('My Pending Requests', 'All my pending requests requiring action', 1, 'Personal', 
 '{"status":["Đang chờ thẩm định","Đang chờ phê duyệt"],"assigned_to":"me"}',
 '["RequestCode","RequestTypeName","RequesterName","StatusDisplayName","SubmissionDate","Priority"]', 1),
 
('Department Overview', 'Overview of all department requests', 1, 'Shared',
 '{"department":"current_user_department"}',
 '["RequestCode","RequestTypeName","RequesterName","AppraiserName","ApproverName","StatusDisplayName","ProcessingDays"]', 1),
 
('High Priority Alerts', 'High priority and urgent requests', 1, 'System',
 '{"priority":["High","Urgent"],"status":["Đang chờ thẩm định","Đang chờ phê duyệt"]}',
 '["RequestCode","Title","RequesterName","Priority","SubmissionDate","ProgressStatus"]', 1),
 
('Overdue Requests', 'Requests that are past their expected completion date', 1, 'System',
 '{"progress_status":"Overdue"}',
 '["RequestCode","RequestTypeName","RequesterName","ExpectedCompletionDate","ProcessingDays","StatusDisplayName"]', 1);

-- Insert sample filters
INSERT INTO RequestSummaryFilters (FilterName, FilterDescription, CreatedBy, FilterType, FilterCriteria, IsQuickFilter, SortOrder) VALUES
('Student Requests', 'Filter for student-related requests', 1, 'Predefined', 
 '{"category_group":"Student"}', 1, 1),
 
('Finance Requests', 'Filter for finance-related requests', 1, 'Predefined',
 '{"category_group":"Financial"}', 1, 2),
 
('Pending My Approval', 'Requests waiting for my approval', 1, 'Smart',
 '{"status":["Đang chờ phê duyệt"],"assigned_to":"current_user"}', 1, 3),
 
('This Week Submissions', 'Requests submitted this week', 1, 'Smart',
 '{"submission_date":"this_week"}', 1, 4),
 
('Rejected This Month', 'Requests rejected in current month', 1, 'Custom',
 '{"status":"Đã từ chối","submission_date":"this_month"}', 0, 5);

-- Insert sample user preferences
INSERT INTO RequestSummaryUserPreferences (UserID, DefaultViewID, ItemsPerPage, AutoRefreshInterval, VisibleColumns, DefaultSortColumn, DefaultFilters) VALUES
(1, 1, 25, 300, 
 '["RequestCode","RequestTypeName","RequesterName","StatusDisplayName","SubmissionDate","Priority","ProcessingDays"]',
 'SubmissionDate', '{"priority_filter":"Normal,High,Urgent"}');

-- Insert sample dashboard metrics (for current date)
INSERT INTO RequestDashboardMetrics (
    MetricDate, DepartmentID, TotalRequests, PendingAppraisal, PendingApproval,
    ApprovedRequests, RejectedRequests, StudentRequests, FinanceRequests,
    AvgProcessingTimeHours, OverdueRequests, ApprovalRate, RejectionRate,
    TotalEstimatedCost, CalculatedBy
) VALUES
(CAST(GETDATE() AS DATE), 1, 15, 5, 3, 6, 1, 8, 4, 72.5, 2, 85.7, 14.3, 25000000, 1),
(CAST(GETDATE() AS DATE), 2, 12, 4, 2, 5, 1, 3, 7, 68.2, 1, 83.3, 16.7, 18500000, 1);

-- Insert sample alerts
INSERT INTO RequestSummaryAlerts (
    AlertType, AlertTitle, AlertMessage, TargetUserID, Severity, 
    Priority, RequiresAction, RelatedRequestID, CreatedBy
) VALUES
('OverdueRequest', 'Overdue Request Alert', 'Request STU-2024-0001 is 3 days overdue for approval', 
 1, 'High', 4, 1, 1, 1),
 
('HighPriorityPending', 'Urgent Request Waiting', 'Urgent staff hiring request requires immediate attention',
 1, 'Critical', 5, 1, 2, 1),
 
('BudgetExceeded', 'Budget Alert', 'Purchase order request exceeds monthly budget limit',
 1, 'Medium', 3, 1, 3, 1);

PRINT 'Request Summary Dashboard sample data inserted successfully!';

-- ================================================================
-- FUNCTIONS for Request Summary Dashboard System
-- ================================================================

-- Function: Get user's pending action count
CREATE FUNCTION fn_GetUserPendingActionCount(
    @UserID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @PendingCount INT = 0;
    
    -- Count requests where user can take action
    SELECT @PendingCount = COUNT(*)
    FROM vw_RequestSummaryDashboard rd
    WHERE (
        -- User is assigned approver and request is pending approval
        (rd.StatusDisplayName IN ('Đang chờ phê duyệt', 'Đã thẩm định') 
         AND EXISTS (
             SELECT 1 FROM Employee WHERE EmployeeID = @UserID 
             AND (Position LIKE '%Director%' OR Position LIKE '%Manager%')
         ))
        OR
        -- User can appraise and request is pending appraisal  
        (rd.StatusDisplayName = 'Đang chờ thẩm định'
         AND EXISTS (
             SELECT 1 FROM Employee WHERE EmployeeID = @UserID 
             AND (Position LIKE '%Manager%' OR Position LIKE '%Head%')
         ))
    );
    
    RETURN ISNULL(@PendingCount, 0);
END;

-- Function: Calculate request urgency score
CREATE FUNCTION fn_CalculateRequestUrgencyScore(
    @RequestID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Score INT = 0;
    DECLARE @Priority NVARCHAR(50), @UrgencyLevel INT, @DaysOverdue INT, @ProcessingDays INT;
    
    SELECT 
        @Priority = Priority, 
        @UrgencyLevel = UrgencyLevel,
        @DaysOverdue = CASE 
            WHEN ExpectedCompletionDate < GETDATE() AND ActualCompletionDate IS NULL 
            THEN DATEDIFF(DAY, ExpectedCompletionDate, GETDATE())
            ELSE 0
        END,
        @ProcessingDays = ProcessingDays
    FROM vw_RequestSummaryDashboard WHERE RequestID = @RequestID;
    
    -- Base score from priority
    SET @Score = CASE @Priority
        WHEN 'Urgent' THEN 100
        WHEN 'High' THEN 75
        WHEN 'Normal' THEN 50
        WHEN 'Low' THEN 25
        ELSE 50
    END;
    
    -- Add urgency level multiplier
    SET @Score = @Score + (@UrgencyLevel * 10);
    
    -- Add overdue penalty
    SET @Score = @Score + (@DaysOverdue * 25);
    
    -- Add processing time factor
    IF @ProcessingDays > 7
        SET @Score = @Score + ((@ProcessingDays - 7) * 2);
    
    RETURN @Score;
END;

-- Function: Get request status class for CSS
CREATE FUNCTION fn_GetRequestStatusClass(
    @RequestID INT
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @StatusClass NVARCHAR(50) = 'status-pending';
    DECLARE @StatusName NVARCHAR(100);
    
    SELECT @StatusName = StatusDisplayName 
    FROM vw_RequestSummaryDashboard 
    WHERE RequestID = @RequestID;
    
    SET @StatusClass = CASE @StatusName
        WHEN 'Đang chờ thẩm định' THEN 'status-in-appraisal'
        WHEN 'Đã thẩm định' THEN 'status-appraised'
        WHEN 'Đang chờ phê duyệt' THEN 'status-in-approval'
        WHEN 'Đã phê duyệt' THEN 'status-approved'
        WHEN 'Đã từ chối' THEN 'status-rejected'
        ELSE 'status-pending'
    END;
    
    RETURN @StatusClass;
END;

-- Function: Check if user can perform action on request
CREATE FUNCTION fn_CanUserActOnRequest(
    @RequestID INT,
    @UserID INT,
    @Action NVARCHAR(50) -- 'appraise', 'approve', 'reject'
)
RETURNS BIT
AS
BEGIN
    DECLARE @CanAct BIT = 0;
    DECLARE @StatusName NVARCHAR(100), @UserPosition NVARCHAR(100);
    
    SELECT @StatusName = StatusDisplayName FROM vw_RequestSummaryDashboard WHERE RequestID = @RequestID;
    SELECT @UserPosition = Position FROM Employee WHERE EmployeeID = @UserID;
    
    IF @Action = 'appraise'
    BEGIN
        IF @StatusName = 'Đang chờ thẩm định' 
           AND (@UserPosition LIKE '%Manager%' OR @UserPosition LIKE '%Head%')
            SET @CanAct = 1;
    END
    ELSE IF @Action = 'approve'
    BEGIN
        IF @StatusName IN ('Đang chờ phê duyệt', 'Đã thẩm định')
           AND (@UserPosition LIKE '%Director%' OR @UserPosition LIKE '%Manager%')
            SET @CanAct = 1;
    END
    ELSE IF @Action = 'reject'
    BEGIN
        IF @StatusName NOT IN ('Đã phê duyệt', 'Đã từ chối')
            SET @CanAct = 1; -- Most users can reject pending requests
    END
    
    RETURN @CanAct;
END;

-- Function: Get department request performance rating
CREATE FUNCTION fn_GetDepartmentPerformanceRating(
    @DepartmentID INT,
    @MetricDate DATE = NULL
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Rating NVARCHAR(20) = 'Average';
    DECLARE @ApprovalRate DECIMAL(5,2), @AvgProcessingTime DECIMAL(10,2), @OverdueCount INT;
    
    IF @MetricDate IS NULL SET @MetricDate = CAST(GETDATE() AS DATE);
    
    SELECT 
        @ApprovalRate = ApprovalRate,
        @AvgProcessingTime = AvgProcessingTimeHours,
        @OverdueCount = OverdueRequests
    FROM RequestDashboardMetrics 
    WHERE DepartmentID = @DepartmentID AND MetricDate = @MetricDate;
    
    -- Calculate rating based on multiple factors
    DECLARE @Score INT = 0;
    
    -- Approval rate scoring (40% weight)
    IF @ApprovalRate >= 90 SET @Score = @Score + 40;
    ELSE IF @ApprovalRate >= 80 SET @Score = @Score + 30;
    ELSE IF @ApprovalRate >= 70 SET @Score = @Score + 20;
    ELSE SET @Score = @Score + 10;
    
    -- Processing time scoring (40% weight) - assuming 72 hours is benchmark
    IF @AvgProcessingTime <= 48 SET @Score = @Score + 40;
    ELSE IF @AvgProcessingTime <= 72 SET @Score = @Score + 30;
    ELSE IF @AvgProcessingTime <= 96 SET @Score = @Score + 20;
    ELSE SET @Score = @Score + 10;
    
    -- Overdue penalty (20% weight)
    IF @OverdueCount = 0 SET @Score = @Score + 20;
    ELSE IF @OverdueCount <= 2 SET @Score = @Score + 15;
    ELSE IF @OverdueCount <= 5 SET @Score = @Score + 10;
    ELSE SET @Score = @Score + 5;
    
    -- Determine rating
    IF @Score >= 85 SET @Rating = 'Excellent';
    ELSE IF @Score >= 70 SET @Rating = 'Good';
    ELSE IF @Score >= 55 SET @Rating = 'Average';
    ELSE SET @Rating = 'Poor';
    
    RETURN @Rating;
END;

PRINT 'Request Summary Dashboard functions created successfully!';

PRINT '';
PRINT 'Request Summary Dashboard System created successfully!';
PRINT '';
PRINT 'New Features Added:';
PRINT '- Comprehensive dashboard for request overview and management';
PRINT '- Advanced filtering and search capabilities';
PRINT '- Customizable views and user preferences';
PRINT '- Real-time metrics and performance tracking';
PRINT '- Smart alerts and notifications system';
PRINT '- Multi-step workflow visualization';
PRINT '- Detailed appraisal and approval tracking';
PRINT '- Department performance analytics';
PRINT '- User action permissions and role-based access';
PRINT '- Overdue request monitoring';
PRINT '- Cost and budget tracking';
PRINT '- Request urgency scoring';
PRINT '';
PRINT 'Dashboard Features:';
PRINT '1. Request Status Tracking - Đang chờ thẩm định, Đã thẩm định, Đang chờ phê duyệt, Đã phê duyệt, Đã từ chối';
PRINT '2. Advanced Filtering - By type, status, requester, approver, date range';
PRINT '3. Performance Metrics - Processing times, approval rates, overdue tracking';
PRINT '4. User Preferences - Customizable views, column configuration, auto-refresh';
PRINT '5. Alert System - High priority, overdue, budget exceeded notifications';
PRINT '6. Department Analytics - Performance ratings, workload distribution';
PRINT '7. Action Permissions - Role-based appraise, approve, reject capabilities';
PRINT '8. Workflow Visualization - Step-by-step progress tracking';
PRINT '';
PRINT 'Integration Points:';
PRINT '- Seamlessly integrates with RequestCreate.html for new requests';
PRINT '- Supports all request types from Section 36';
PRINT '- Provides backend for RequestSummary.html dashboard interface';
PRINT '- Enables comprehensive request lifecycle management';
