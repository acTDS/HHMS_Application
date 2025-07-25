using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HHMS.API.Data;
using HHMS.API.Models;

namespace HHMS.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StaffController : ControllerBase
{
    private readonly HHMSDbContext _context;

    public StaffController(HHMSDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<object>>> GetStaff(
        [FromQuery] string? search = null,
        [FromQuery] int? branchId = null,
        [FromQuery] int? departmentId = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        try
        {
            var query = _context.Staff
                .Include(s => s.Branch)
                .Include(s => s.Department)
                .Include(s => s.Status)
                .Where(s => s.StatusID == 1); // Only active staff

            // Apply filters
            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(s => 
                    s.FullName.Contains(search) ||
                    s.StaffCode.Contains(search) ||
                    s.Email.Contains(search) ||
                    s.Phone.Contains(search));
            }

            if (branchId.HasValue)
            {
                query = query.Where(s => s.BranchID == branchId.Value);
            }

            if (departmentId.HasValue)
            {
                query = query.Where(s => s.DepartmentID == departmentId.Value);
            }

            var totalCount = await query.CountAsync();
            
            var staff = await query
                .OrderBy(s => s.StaffCode)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(s => new
                {
                    staffId = s.StaffID,
                    staffCode = s.StaffCode,
                    fullName = s.FullName,
                    gender = s.Gender,
                    idNumber = s.IDNumber,
                    birthDate = s.BirthDate.HasValue ? s.BirthDate.Value.ToString("dd/MM/yyyy") : null,
                    address = s.StaffAddress,
                    phone = s.Phone,
                    email = s.Email,
                    position = s.Position,
                    education = s.Education,
                    contractType = s.ContractType,
                    hireDate = s.HireDate.ToString("dd/MM/yyyy"),
                    baseSalary = s.BaseSalary,
                    branchName = s.Branch != null ? s.Branch.BranchName : "",
                    departmentName = s.Department != null ? s.Department.DepartmentName : "",
                    statusName = s.Status != null ? s.Status.StatusName : ""
                })
                .ToListAsync();

            return Ok(new
            {
                data = staff,
                totalCount = totalCount,
                page = page,
                pageSize = pageSize,
                totalPages = (int)Math.Ceiling((double)totalCount / pageSize)
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải danh sách nhân viên", error = ex.Message });
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<object>> GetStaff(int id)
    {
        try
        {
            var staff = await _context.Staff
                .Include(s => s.Branch)
                .Include(s => s.Department)
                .Include(s => s.Status)
                .Where(s => s.StaffID == id)
                .Select(s => new
                {
                    staffId = s.StaffID,
                    staffCode = s.StaffCode,
                    fullName = s.FullName,
                    gender = s.Gender,
                    idNumber = s.IDNumber,
                    birthDate = s.BirthDate,
                    address = s.StaffAddress,
                    phone = s.Phone,
                    email = s.Email,
                    position = s.Position,
                    education = s.Education,
                    contractType = s.ContractType,
                    contractCode = s.ContractCode,
                    hireDate = s.HireDate,
                    socialInsuranceNumber = s.SocialInsuranceNumber,
                    taxCode = s.TaxCode,
                    bankBranch = s.BankBranch,
                    bankAccountNumber = s.BankAccountNumber,
                    baseSalary = s.BaseSalary,
                    branchId = s.BranchID,
                    branchName = s.Branch != null ? s.Branch.BranchName : "",
                    departmentId = s.DepartmentID,
                    departmentName = s.Department != null ? s.Department.DepartmentName : "",
                    statusId = s.StatusID,
                    statusName = s.Status != null ? s.Status.StatusName : "",
                    avatarPath = s.AvatarPath,
                    createdDate = s.CreatedDate,
                    lastModified = s.LastModified
                })
                .FirstOrDefaultAsync();

            if (staff == null)
            {
                return NotFound(new { message = "Không tìm thấy nhân viên" });
            }

            return Ok(staff);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tải thông tin nhân viên", error = ex.Message });
        }
    }

    [HttpPost]
    public async Task<ActionResult<object>> CreateStaff([FromBody] StaffCreateRequest request)
    {
        try
        {
            // Validate required fields
            if (string.IsNullOrEmpty(request.StaffCode) || string.IsNullOrEmpty(request.FullName))
            {
                return BadRequest(new { message = "Mã nhân viên và họ tên là bắt buộc" });
            }

            // Check if staff code already exists
            var existingStaff = await _context.Staff.AnyAsync(s => s.StaffCode == request.StaffCode);
            if (existingStaff)
            {
                return BadRequest(new { message = "Mã nhân viên đã tồn tại" });
            }

            var staff = new Staff
            {
                StaffCode = request.StaffCode,
                FullName = request.FullName,
                Gender = request.Gender,
                IDNumber = request.IDNumber,
                BirthDate = request.BirthDate,
                StaffAddress = request.Address,
                Phone = request.Phone,
                Email = request.Email,
                Position = request.Position,
                Education = request.Education,
                ContractType = request.ContractType,
                ContractCode = request.ContractCode,
                BranchID = request.BranchID,
                DepartmentID = request.DepartmentID,
                HireDate = request.HireDate ?? DateTime.Now,
                SocialInsuranceNumber = request.SocialInsuranceNumber,
                TaxCode = request.TaxCode,
                BankBranch = request.BankBranch,
                BankAccountNumber = request.BankAccountNumber,
                BaseSalary = request.BaseSalary ?? 0,
                StatusID = 1 // Active
            };

            _context.Staff.Add(staff);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetStaff), new { id = staff.StaffID }, new { id = staff.StaffID, message = "Tạo nhân viên thành công" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi tạo nhân viên", error = ex.Message });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> UpdateStaff(int id, [FromBody] StaffUpdateRequest request)
    {
        try
        {
            var staff = await _context.Staff.FindAsync(id);
            if (staff == null)
            {
                return NotFound(new { message = "Không tìm thấy nhân viên" });
            }

            // Update fields
            staff.FullName = request.FullName ?? staff.FullName;
            staff.Gender = request.Gender ?? staff.Gender;
            staff.IDNumber = request.IDNumber ?? staff.IDNumber;
            staff.BirthDate = request.BirthDate ?? staff.BirthDate;
            staff.StaffAddress = request.Address ?? staff.StaffAddress;
            staff.Phone = request.Phone ?? staff.Phone;
            staff.Email = request.Email ?? staff.Email;
            staff.Position = request.Position ?? staff.Position;
            staff.Education = request.Education ?? staff.Education;
            staff.ContractType = request.ContractType ?? staff.ContractType;
            staff.ContractCode = request.ContractCode ?? staff.ContractCode;
            staff.BranchID = request.BranchID ?? staff.BranchID;
            staff.DepartmentID = request.DepartmentID ?? staff.DepartmentID;
            staff.SocialInsuranceNumber = request.SocialInsuranceNumber ?? staff.SocialInsuranceNumber;
            staff.TaxCode = request.TaxCode ?? staff.TaxCode;
            staff.BankBranch = request.BankBranch ?? staff.BankBranch;
            staff.BankAccountNumber = request.BankAccountNumber ?? staff.BankAccountNumber;
            staff.BaseSalary = request.BaseSalary ?? staff.BaseSalary;
            staff.LastModified = DateTime.Now;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Cập nhật nhân viên thành công" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi cập nhật nhân viên", error = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteStaff(int id)
    {
        try
        {
            var staff = await _context.Staff.FindAsync(id);
            if (staff == null)
            {
                return NotFound(new { message = "Không tìm thấy nhân viên" });
            }

            // Soft delete - set status to inactive
            staff.StatusID = 2; // Assuming 2 = Inactive
            staff.LastModified = DateTime.Now;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Xóa nhân viên thành công" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Lỗi khi xóa nhân viên", error = ex.Message });
        }
    }
}

// DTOs
public class StaffCreateRequest
{
    public string StaffCode { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string? Gender { get; set; }
    public string? IDNumber { get; set; }
    public DateTime? BirthDate { get; set; }
    public string? Address { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Position { get; set; }
    public string? Education { get; set; }
    public string? ContractType { get; set; }
    public string? ContractCode { get; set; }
    public int? BranchID { get; set; }
    public int? DepartmentID { get; set; }
    public DateTime? HireDate { get; set; }
    public string? SocialInsuranceNumber { get; set; }
    public string? TaxCode { get; set; }
    public string? BankBranch { get; set; }
    public string? BankAccountNumber { get; set; }
    public decimal? BaseSalary { get; set; }
}

public class StaffUpdateRequest
{
    public string? FullName { get; set; }
    public string? Gender { get; set; }
    public string? IDNumber { get; set; }
    public DateTime? BirthDate { get; set; }
    public string? Address { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Position { get; set; }
    public string? Education { get; set; }
    public string? ContractType { get; set; }
    public string? ContractCode { get; set; }
    public int? BranchID { get; set; }
    public int? DepartmentID { get; set; }
    public string? SocialInsuranceNumber { get; set; }
    public string? TaxCode { get; set; }
    public string? BankBranch { get; set; }
    public string? BankAccountNumber { get; set; }
    public decimal? BaseSalary { get; set; }
}