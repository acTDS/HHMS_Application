using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("Department")]
public class Department
{
    [Key]
    public int DepartmentID { get; set; }
    
    [Required]
    [StringLength(20)]
    public string DepartmentCode { get; set; } = string.Empty;
    
    [Required]
    [StringLength(255)]
    public string DepartmentName { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string? Description { get; set; }
    
    [StringLength(255)]
    public string? ManagerStaffName { get; set; }
    
    public int? ManagerEmployeeId { get; set; }
    
    public int StaffQuota { get; set; } = 0;
    
    public int CurrentStaffCount { get; set; } = 0;
    
    public int? BranchID { get; set; }
    
    public int? ParentDepartmentID { get; set; }
    
    public int DepartmentLevel { get; set; } = 1;
    
    public DateTime? EstablishedDate { get; set; }
    
    [Column(TypeName = "decimal(15,2)")]
    public decimal Budget { get; set; } = 0;
    
    [StringLength(20)]
    public string? ContactPhone { get; set; }
    
    [StringLength(255)]
    public string? ContactEmail { get; set; }
    
    [StringLength(500)]
    public string? OfficeLocation { get; set; }
    
    public string? Responsibilities { get; set; }
    
    public string? KPITargets { get; set; }
    
    public int StatusID { get; set; } = 1;
    
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime LastModified { get; set; } = DateTime.Now;
    
    public int? CreatedBy { get; set; }
    public int? ModifiedBy { get; set; }
    
    // Navigation properties
    public virtual Branch? Branch { get; set; }
    public virtual Department? ParentDepartment { get; set; }
    public virtual Staff? ManagerEmployee { get; set; }
    public virtual GeneralStatus? Status { get; set; }
    public virtual ICollection<Staff> Staff { get; set; } = new List<Staff>();
    public virtual ICollection<Department> SubDepartments { get; set; } = new List<Department>();
}