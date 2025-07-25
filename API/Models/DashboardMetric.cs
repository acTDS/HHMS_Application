using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HHMS.API.Models;

[Table("DashboardMetric")]
public class DashboardMetric
{
    [Key]
    public int MetricID { get; set; }
    
    public int? MetricTypeID { get; set; }
    
    public int? BranchID { get; set; }
    
    [Column(TypeName = "decimal(19,2)")]
    public decimal CurrentValue { get; set; }
    
    [Column(TypeName = "decimal(19,2)")]
    public decimal? PreviousValue { get; set; }
    
    [Column(TypeName = "decimal(5,2)")]
    public decimal? ChangePercentage { get; set; }
    
    public DateTime LastUpdated { get; set; } = DateTime.Now;
    
    public int? CalculatedBy { get; set; }
    
    // Navigation properties
    public virtual MetricType? MetricType { get; set; }
    public virtual Branch? Branch { get; set; }
    public virtual Staff? Calculator { get; set; }
}

[Table("MetricType")]
public class MetricType
{
    [Key]
    public int MetricTypeID { get; set; }
    
    [Required]
    [StringLength(100)]
    public string MetricName { get; set; } = string.Empty;
    
    [Required]
    [StringLength(255)]
    public string DisplayName { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string? Description { get; set; }
    
    [StringLength(50)]
    public string? Unit { get; set; }
    
    [StringLength(100)]
    public string? IconClass { get; set; }
    
    [StringLength(100)]
    public string? Category { get; set; }
    
    public bool IsActive { get; set; } = true;
    
    public int DisplayOrder { get; set; } = 1;
    
    // Navigation properties
    public virtual ICollection<DashboardMetric> DashboardMetrics { get; set; } = new List<DashboardMetric>();
}