using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("GeneralStatus")]
public class GeneralStatus
{
    [Key]
    public int StatusID { get; set; }
    
    [Required]
    [StringLength(100)]
    public string StatusName { get; set; } = string.Empty;
    
    [StringLength(50)]
    public string? StatusType { get; set; }
    
    public int DisplayOrder { get; set; } = 1;
    
    public bool IsActive { get; set; } = true;
    
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime LastModified { get; set; } = DateTime.Now;
    
    // Navigation properties
    public virtual ICollection<Staff> Staff { get; set; } = new List<Staff>();
    public virtual ICollection<Branch> Branches { get; set; } = new List<Branch>();
    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();
}