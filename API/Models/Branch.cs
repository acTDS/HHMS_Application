using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("Branch")]
public class Branch
{
    [Key]
    public int BranchID { get; set; }
    
    [Required]
    [StringLength(20)]
    public string BranchCode { get; set; } = string.Empty;
    
    [Required]
    [StringLength(255)]
    public string BranchName { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string? BranchAddress { get; set; }
    
    [StringLength(20)]
    public string? Phone { get; set; }
    
    [StringLength(255)]
    public string? Email { get; set; }
    
    [StringLength(255)]
    public string? BranchLicense { get; set; }
    
    [StringLength(255)]
    public string? BranchDirector { get; set; }
    
    public DateTime? EstablishedDate { get; set; }
    
    public int StatusID { get; set; } = 1;
    
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime LastModified { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual GeneralStatus? Status { get; set; }
    public virtual ICollection<Staff> Staff { get; set; } = new List<Staff>();
    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();
}