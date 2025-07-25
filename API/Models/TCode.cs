using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("TCode")]
public class TCode
{
    [Key]
    public int TCodeID { get; set; }
    
    [Required]
    [StringLength(20)]
    public string TCodeValue { get; set; } = string.Empty;
    
    [Required]
    [StringLength(255)]
    public string TCodeName { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string? Description { get; set; }
    
    [StringLength(255)]
    public string? UIFile { get; set; }
    
    [StringLength(100)]
    public string? IconClass { get; set; }
    
    [StringLength(100)]
    public string? Category { get; set; }
    
    public bool IsActive { get; set; } = true;
    
    public int DisplayOrder { get; set; } = 1;
    
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    public DateTime LastModified { get; set; } = DateTime.Now;
}