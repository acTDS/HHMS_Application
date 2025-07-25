using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("Staff")]
public class Staff
{
    [Key]
    public int StaffID { get; set; }
    
    [Required]
    [StringLength(20)]
    public string StaffCode { get; set; } = string.Empty;
    
    [Required]
    [StringLength(255)]
    public string FullName { get; set; } = string.Empty;
    
    [StringLength(10)]
    public string? Gender { get; set; }
    
    [StringLength(50)]
    public string? IDNumber { get; set; }
    
    public DateTime? BirthDate { get; set; }
    
    [StringLength(500)]
    public string? StaffAddress { get; set; }
    
    [StringLength(20)]
    public string? Phone { get; set; }
    
    [StringLength(255)]
    public string? Email { get; set; }
    
    [StringLength(50)]
    public string? ContractType { get; set; }
    
    [StringLength(50)]
    public string? ContractCode { get; set; }
    
    [StringLength(100)]
    public string? Position { get; set; }
    
    [StringLength(200)]
    public string? Education { get; set; }
    
    public int? BranchID { get; set; }
    public int? DepartmentID { get; set; }
    
    public DateTime HireDate { get; set; } = DateTime.Now;
    
    [StringLength(50)]
    public string? SocialInsuranceNumber { get; set; }
    
    [StringLength(50)]
    public string? TaxCode { get; set; }
    
    [StringLength(200)]
    public string? BankBranch { get; set; }
    
    [StringLength(50)]
    public string? BankAccountNumber { get; set; }
    
    [Column(TypeName = "decimal(19,2)")]
    public decimal BaseSalary { get; set; } = 0;
    
    public int StatusID { get; set; } = 1;
    
    [StringLength(500)]
    public string? AvatarPath { get; set; }
    
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime LastModified { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual Branch? Branch { get; set; }
    public virtual Department? Department { get; set; }
    public virtual GeneralStatus? Status { get; set; }
}