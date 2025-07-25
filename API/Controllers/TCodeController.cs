using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HHMS.API.Data;

namespace HHMS.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TCodeController : ControllerBase
{
    private readonly HHMSDbContext _context;

    public TCodeController(HHMSDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<object>>> GetTCodes([FromQuery] string? userRole = "default")
    {
        try
        {
            var tcodes = await _context.TCodes
                .Where(t => t.IsActive)
                .OrderBy(t => t.DisplayOrder)
                .ThenBy(t => t.TCodeName)
                .Select(t => new
                {
                    tcode = t.TCodeValue,
                    description = t.TCodeName,
                    requiredRole = new[] { "admin", "manager", "teacher", "hr", "default" }, // For now, allow all roles
                    iconClass = t.IconClass,
                    category = t.Category,
                    uiFile = t.UIFile
                })
                .ToListAsync();

            return Ok(tcodes);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải danh sách T-Code", error = ex.Message });
        }
    }

    [HttpGet("{tcode}")]
    public async Task<ActionResult<object>> GetTCode(string tcode)
    {
        try
        {
            var tcodeItem = await _context.TCodes
                .Where(t => t.TCodeValue == tcode && t.IsActive)
                .Select(t => new
                {
                    tcode = t.TCodeValue,
                    name = t.TCodeName,
                    description = t.Description,
                    uiFile = t.UIFile,
                    iconClass = t.IconClass,
                    category = t.Category
                })
                .FirstOrDefaultAsync();

            if (tcodeItem == null)
            {
                return NotFound(new { message = "Không tìm thấy T-Code" });
            }

            return Ok(tcodeItem);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải thông tin T-Code", error = ex.Message });
        }
    }

    [HttpPost("validate")]
    public async Task<ActionResult<object>> ValidateTCode([FromBody] TCodeValidationRequest request)
    {
        try
        {
            var tcodeExists = await _context.TCodes
                .AnyAsync(t => t.TCodeValue == request.TCode && t.IsActive);

            if (!tcodeExists)
            {
                return BadRequest(new { message = "T-Code không tồn tại hoặc không hoạt động", hasPermission = false });
            }

            // For now, return true for all roles - in a real system, you'd check permissions
            var hasPermission = true;

            return Ok(new 
            { 
                message = hasPermission ? "T-Code hợp lệ" : "Bạn không có quyền truy cập T-Code này",
                hasPermission = hasPermission,
                tcode = request.TCode
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi xác thực T-Code", error = ex.Message });
        }
    }
}

public class TCodeValidationRequest
{
    public string TCode { get; set; } = string.Empty;
    public string? UserRole { get; set; }
    public int? UserId { get; set; }
}