using Microsoft.EntityFrameworkCore;
using HHMS.API.Data;
using HHMS.API.Models;

namespace HHMS.API.Services;

public class DatabaseSeeder
{
    private readonly HHMSDbContext _context;

    public DatabaseSeeder(HHMSDbContext context)
    {
        _context = context;
    }

    public async Task SeedAsync()
    {
        // Ensure database is created
        await _context.Database.EnsureCreatedAsync();

        // Check if data already exists
        if (await _context.GeneralStatuses.AnyAsync())
        {
            return; // Database already seeded
        }

        // Seed General Statuses
        var statuses = new[]
        {
            new GeneralStatus { StatusName = "Active", StatusType = "Common", DisplayOrder = 1 },
            new GeneralStatus { StatusName = "Inactive", StatusType = "Common", DisplayOrder = 2 },
            new GeneralStatus { StatusName = "Pending", StatusType = "Common", DisplayOrder = 3 },
            new GeneralStatus { StatusName = "Completed", StatusType = "Common", DisplayOrder = 4 },
            new GeneralStatus { StatusName = "Cancelled", StatusType = "Common", DisplayOrder = 5 }
        };
        _context.GeneralStatuses.AddRange(statuses);
        await _context.SaveChangesAsync();

        // Seed Branches
        var branches = new[]
        {
            new Branch { BranchCode = "NN68-HN", BranchName = "Chi nhánh Hà Nội", BranchAddress = "123 Đường Láng, Đống Đa, Hà Nội", Phone = "024-1234-5678", Email = "hanoi@nn68.edu.vn", BranchDirector = "Nguyễn Văn Nam", StatusID = 1 },
            new Branch { BranchCode = "NN68-HCM", BranchName = "Chi nhánh TP.HCM", BranchAddress = "456 Nguyễn Trãi, Q.5, TP.HCM", Phone = "028-8765-4321", Email = "hcm@nn68.edu.vn", BranchDirector = "Trần Thị Mai", StatusID = 1 },
            new Branch { BranchCode = "NN68-DN", BranchName = "Chi nhánh Đà Nẵng", BranchAddress = "789 Lê Duẩn, Hải Châu, Đà Nẵng", Phone = "0236-567-890", Email = "danang@nn68.edu.vn", BranchDirector = "Lê Hoàng Tùng", StatusID = 1 }
        };
        _context.Branches.AddRange(branches);
        await _context.SaveChangesAsync();

        // Seed Departments
        var departments = new[]
        {
            new Department { DepartmentCode = "NN68-HR", DepartmentName = "Nhân sự", Description = "Quản lý nhân sự và tuyển dụng", ManagerStaffName = "Nguyễn Thị Lan", StaffQuota = 8, BranchID = 1, StatusID = 1 },
            new Department { DepartmentCode = "NN68-EDU", DepartmentName = "Giáo vụ", Description = "Quản lý chương trình đào tạo", ManagerStaffName = "Phạm Văn Minh", StaffQuota = 15, BranchID = 1, StatusID = 1 },
            new Department { DepartmentCode = "NN68-FIN", DepartmentName = "Tài chính", Description = "Quản lý tài chính và kế toán", ManagerStaffName = "Hoàng Thị Hoa", StaffQuota = 6, BranchID = 1, StatusID = 1 },
            new Department { DepartmentCode = "NN68-IT", DepartmentName = "Công nghệ thông tin", Description = "Quản lý hệ thống IT", ManagerStaffName = "Lê Văn Đức", StaffQuota = 5, BranchID = 1, StatusID = 1 },
            new Department { DepartmentCode = "NN68-MKT", DepartmentName = "Marketing", Description = "Tuyển sinh và quảng bá", ManagerStaffName = "Vũ Thị Thu", StaffQuota = 10, BranchID = 1, StatusID = 1 }
        };
        _context.Departments.AddRange(departments);
        await _context.SaveChangesAsync();

        // Seed Staff
        var staff = new[]
        {
            new Staff { StaffCode = "ST001", FullName = "Nguyễn Văn Admin", Gender = "Nam", IDNumber = "123456789012", Email = "admin@nn68.edu.vn", Position = "Quản trị hệ thống", Education = "Cử nhân Công nghệ thông tin", ContractType = "Full-time", BranchID = 1, DepartmentID = 4, BaseSalary = 15000000, StatusID = 1 },
            new Staff { StaffCode = "ST002", FullName = "Trần Thị Manager", Gender = "Nữ", IDNumber = "123456789013", Email = "manager@nn68.edu.vn", Position = "Trưởng phòng Giáo vụ", Education = "Thạc sĩ Giáo dục học", ContractType = "Full-time", BranchID = 1, DepartmentID = 2, BaseSalary = 12000000, StatusID = 1 },
            new Staff { StaffCode = "ST003", FullName = "Lê Hoàng Teacher", Gender = "Nam", IDNumber = "123456789014", Email = "teacher@nn68.edu.vn", Position = "Giảng viên", Education = "Cử nhân Ngôn ngữ Anh", ContractType = "Full-time", BranchID = 1, DepartmentID = 2, BaseSalary = 8000000, StatusID = 1 },
            new Staff { StaffCode = "ST004", FullName = "Phạm Thị Staff", Gender = "Nữ", IDNumber = "123456789015", Email = "staff@nn68.edu.vn", Position = "Nhân viên tư vấn", Education = "Cử nhân Kinh tế", ContractType = "Part-time", BranchID = 1, DepartmentID = 5, BaseSalary = 7000000, StatusID = 1 }
        };
        _context.Staff.AddRange(staff);
        await _context.SaveChangesAsync();

        // Seed T-Codes
        var tcodes = new[]
        {
            new TCode { TCodeValue = "T001", TCodeName = "Dashboard", Description = "Trang tổng quan hệ thống", UIFile = "DashBoard.html", IconClass = "fas fa-tachometer-alt", Category = "System", DisplayOrder = 1 },
            new TCode { TCodeValue = "T002", TCodeName = "Quản lý nhân viên", Description = "Quản lý thông tin nhân viên", UIFile = "StaffManagement.html", IconClass = "fas fa-users", Category = "HR", DisplayOrder = 2 },
            new TCode { TCodeValue = "T003", TCodeName = "Quản lý học viên", Description = "Quản lý thông tin học viên", UIFile = "StudentManagement.html", IconClass = "fas fa-user-graduate", Category = "Education", DisplayOrder = 3 },
            new TCode { TCodeValue = "T004", TCodeName = "Quản lý lớp học", Description = "Quản lý lớp học và khóa học", UIFile = "ClassManagement.html", IconClass = "fas fa-chalkboard-teacher", Category = "Education", DisplayOrder = 4 },
            new TCode { TCodeValue = "T005", TCodeName = "Quản lý tài chính", Description = "Quản lý thu chi và báo cáo tài chính", UIFile = "FinancialManagement.html", IconClass = "fas fa-chart-line", Category = "Finance", DisplayOrder = 5 },
            new TCode { TCodeValue = "T006", TCodeName = "Quản lý tài liệu", Description = "Quản lý tài liệu và giáo trình", UIFile = "DocumentManagement.html", IconClass = "fas fa-folder", Category = "Education", DisplayOrder = 6 },
            new TCode { TCodeValue = "T007", TCodeName = "Báo cáo thống kê", Description = "Xem báo cáo và thống kê", UIFile = "ReportManagement.html", IconClass = "fas fa-chart-bar", Category = "Report", DisplayOrder = 7 },
            new TCode { TCodeValue = "T008", TCodeName = "Quản lý tài khoản", Description = "Quản lý tài khoản và phân quyền", UIFile = "AccountManagement.html", IconClass = "fas fa-user-cog", Category = "System", DisplayOrder = 8 }
        };
        _context.TCodes.AddRange(tcodes);
        await _context.SaveChangesAsync();

        // Seed Metric Types
        var metricTypes = new[]
        {
            new MetricType { MetricName = "total_staff", DisplayName = "Tổng số nhân viên", Description = "Tổng số nhân viên đang làm việc", Unit = "Count", IconClass = "fas fa-users", Category = "HR", DisplayOrder = 1 },
            new MetricType { MetricName = "active_branches", DisplayName = "Chi nhánh hoạt động", Description = "Số chi nhánh đang hoạt động", Unit = "Count", IconClass = "fas fa-building", Category = "General", DisplayOrder = 2 },
            new MetricType { MetricName = "departments", DisplayName = "Phòng ban", Description = "Tổng số phòng ban", Unit = "Count", IconClass = "fas fa-sitemap", Category = "General", DisplayOrder = 3 }
        };
        _context.MetricTypes.AddRange(metricTypes);
        await _context.SaveChangesAsync();

        // Seed Dashboard Metrics
        var metrics = new[]
        {
            new DashboardMetric { MetricTypeID = 1, BranchID = 1, CurrentValue = 4, PreviousValue = 3, ChangePercentage = 33.33m, CalculatedBy = 1 },
            new DashboardMetric { MetricTypeID = 2, BranchID = 1, CurrentValue = 3, PreviousValue = 3, ChangePercentage = 0, CalculatedBy = 1 },
            new DashboardMetric { MetricTypeID = 3, BranchID = 1, CurrentValue = 5, PreviousValue = 4, ChangePercentage = 25.00m, CalculatedBy = 1 }
        };
        _context.DashboardMetrics.AddRange(metrics);
        await _context.SaveChangesAsync();

        Console.WriteLine("Database seeded successfully!");
    }
}