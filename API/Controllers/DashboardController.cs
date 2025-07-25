using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HHMS.API.Data;
using HHMS.API.Models;

namespace HHMS.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DashboardController : ControllerBase
{
    private readonly HHMSDbContext _context;

    public DashboardController(HHMSDbContext context)
    {
        _context = context;
    }

    [HttpGet("metrics")]
    public async Task<ActionResult<IEnumerable<object>>> GetDashboardMetrics()
    {
        try
        {
            var metrics = await _context.DashboardMetrics
                .Include(dm => dm.MetricType)
                .Include(dm => dm.Branch)
                .Where(dm => dm.MetricType != null && dm.MetricType.IsActive)
                .Select(dm => new
                {
                    title = dm.MetricType!.DisplayName,
                    value = dm.CurrentValue.ToString("N0"),
                    change = dm.ChangePercentage.HasValue 
                        ? (dm.ChangePercentage.Value >= 0 ? "+" : "") + dm.ChangePercentage.Value.ToString("F1") + "%"
                        : "0%",
                    icon = dm.MetricType.IconClass,
                    category = dm.MetricType.Category
                })
                .ToListAsync();

            return Ok(metrics);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải dữ liệu metrics", error = ex.Message });
        }
    }

    [HttpGet("activities")]
    public async Task<ActionResult<IEnumerable<object>>> GetDailyActivities()
    {
        try
        {
            // For now, return some sample activities since we don't have an ActivityLog table in our simplified model
            var activities = new[]
            {
                new { icon = "📝", details = "Nhân viên mới được thêm vào hệ thống", time = DateTime.Now.AddHours(-2).ToString("HH:mm") },
                new { icon = "📊", details = "Báo cáo tháng đã được tạo", time = DateTime.Now.AddHours(-4).ToString("HH:mm") },
                new { icon = "👥", details = "Cập nhật thông tin phòng ban", time = DateTime.Now.AddHours(-6).ToString("HH:mm") }
            };

            return Ok(activities);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải hoạt động trong ngày", error = ex.Message });
        }
    }

    [HttpGet("upcoming-classes")]
    public async Task<ActionResult<IEnumerable<object>>> GetUpcomingClasses()
    {
        try
        {
            // For now, return sample data since we don't have Class table in our simplified model
            var classes = new[]
            {
                new { title = "Tiếng Anh Giao Tiếp Cấp Tốc", instructor = "GV. Nguyễn Văn A", schedule = "Thứ 2, 18:00 - 20:00", students = "25 học sinh" },
                new { title = "Luyện Thi IELTS", instructor = "GV. Trần Thị B", schedule = "Thứ 4, 19:00 - 21:00", students = "18 học sinh" },
                new { title = "Business English", instructor = "GV. Lê Hoàng C", schedule = "Thứ 6, 17:30 - 19:30", students = "22 học sinh" }
            };

            return Ok(classes);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải lớp học sắp diễn ra", error = ex.Message });
        }
    }

    [HttpGet("pending-requests")]
    public async Task<ActionResult<IEnumerable<object>>> GetPendingRequests()
    {
        try
        {
            // For now, return sample data since we don't have Request table in our simplified model
            var requests = new[]
            {
                new { details = "Yêu cầu thay đổi lịch làm việc từ nhân viên", time = "Hôm nay, 10:30" },
                new { details = "Đơn xin nghỉ phép của giáo viên", time = "Hôm nay, 09:15" },
                new { details = "Yêu cầu cập nhật thông tin cá nhân", time = "Hôm qua, 16:45" }
            };

            return Ok(requests);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải yêu cầu chờ xử lý", error = ex.Message });
        }
    }

    [HttpGet("summary")]
    public async Task<ActionResult<object>> GetDashboardSummary()
    {
        try
        {
            var staffCount = await _context.Staff.Where(s => s.StatusID == 1).CountAsync();
            var branchCount = await _context.Branches.Where(b => b.StatusID == 1).CountAsync();
            var departmentCount = await _context.Departments.Where(d => d.StatusID == 1).CountAsync();

            var summary = new
            {
                totalStaff = staffCount,
                totalBranches = branchCount,
                totalDepartments = departmentCount,
                lastUpdated = DateTime.Now
            };

            return Ok(summary);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải tổng quan hệ thống", error = ex.Message });
        }
    }
}