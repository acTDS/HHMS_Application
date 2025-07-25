using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HHMS.API.Data;

namespace HHMS.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly HHMSDbContext _context;

    public UserController(HHMSDbContext context)
    {
        _context = context;
    }

    [HttpGet("info")]
    public async Task<ActionResult<object>> GetUserInfo([FromQuery] int? userId = 1)
    {
        try
        {
            // For demo purposes, get the first admin user or create a default response
            var staff = await _context.Staff
                .Include(s => s.Department)
                .Include(s => s.Branch)
                .Where(s => s.StatusID == 1)
                .OrderBy(s => s.StaffID)
                .Select(s => new
                {
                    id = s.StaffID,
                    name = s.FullName,
                    title = s.Position ?? "Nhân viên",
                    role = s.Position != null && s.Position.Contains("Admin") ? "admin" :
                           s.Position != null && s.Position.Contains("Manager") ? "manager" :
                           s.Position != null && s.Position.Contains("Teacher") ? "teacher" :
                           s.Position != null && s.Position.Contains("HR") ? "hr" : "default",
                    email = s.Email,
                    department = s.Department != null ? s.Department.DepartmentName : "",
                    branch = s.Branch != null ? s.Branch.BranchName : "",
                    avatarPath = s.AvatarPath
                })
                .FirstOrDefaultAsync();

            if (staff == null)
            {
                // Return a default user if no staff found
                return Ok(new
                {
                    id = 1,
                    name = "Administrator",
                    title = "Quản trị viên hệ thống",
                    role = "admin",
                    email = "admin@nn68.edu.vn",
                    department = "Công nghệ thông tin",
                    branch = "Chi nhánh chính",
                    avatarPath = (string?)null
                });
            }

            return Ok(staff);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải thông tin người dùng", error = ex.Message });
        }
    }

    [HttpPost("login")]
    public async Task<ActionResult<object>> Login([FromBody] LoginRequest request)
    {
        try
        {
            // For demo purposes, accept any login and return admin user
            // In a real system, you would validate credentials against the Account table
            
            var staff = await _context.Staff
                .Include(s => s.Department)
                .Include(s => s.Branch)
                .Where(s => s.StatusID == 1)
                .OrderBy(s => s.StaffID)
                .Select(s => new
                {
                    id = s.StaffID,
                    name = s.FullName,
                    title = s.Position ?? "Nhân viên",
                    role = "admin", // For demo, always return admin role
                    email = s.Email,
                    department = s.Department != null ? s.Department.DepartmentName : "",
                    branch = s.Branch != null ? s.Branch.BranchName : ""
                })
                .FirstOrDefaultAsync();

            if (staff == null)
            {
                return Ok(new
                {
                    success = true,
                    user = new
                    {
                        id = 1,
                        name = "Administrator",
                        title = "Quản trị viên hệ thống",
                        role = "admin",
                        email = "admin@nn68.edu.vn",
                        department = "Công nghệ thông tin",
                        branch = "Chi nhánh chính"
                    },
                    message = "Đăng nhập thành công"
                });
            }

            return Ok(new
            {
                success = true,
                user = staff,
                message = "Đăng nhập thành công"
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi đăng nhập", error = ex.Message });
        }
    }

    [HttpPost("logout")]
    public ActionResult Logout()
    {
        return Ok(new { message = "Đăng xuất thành công" });
    }

    [HttpPost("change-password")]
    public ActionResult ChangePassword([FromBody] ChangePasswordRequest request)
    {
        try
        {
            // For demo purposes, just return success
            // In a real system, you would validate current password and update the Account table
            return Ok(new { message = "Đổi mật khẩu thành công" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi đổi mật khẩu", error = ex.Message });
        }
    }
}

public class LoginRequest
{
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class ChangePasswordRequest
{
    public string CurrentPassword { get; set; } = string.Empty;
    public string NewPassword { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
}