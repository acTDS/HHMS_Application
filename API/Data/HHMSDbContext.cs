using Microsoft.EntityFrameworkCore;
using HHMS.API.Models;

namespace HHMS.API.Data;

public class HHMSDbContext : DbContext
{
    public HHMSDbContext(DbContextOptions<HHMSDbContext> options) : base(options)
    {
    }

    public DbSet<Staff> Staff { get; set; }
    public DbSet<Branch> Branches { get; set; }
    public DbSet<Department> Departments { get; set; }
    public DbSet<GeneralStatus> GeneralStatuses { get; set; }
    public DbSet<TCode> TCodes { get; set; }
    public DbSet<DashboardMetric> DashboardMetrics { get; set; }
    public DbSet<MetricType> MetricTypes { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure Staff relationships
        modelBuilder.Entity<Staff>(entity =>
        {
            entity.HasOne(s => s.Branch)
                  .WithMany(b => b.Staff)
                  .HasForeignKey(s => s.BranchID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(s => s.Department)
                  .WithMany(d => d.Staff)
                  .HasForeignKey(s => s.DepartmentID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(s => s.Status)
                  .WithMany(gs => gs.Staff)
                  .HasForeignKey(s => s.StatusID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(s => s.StaffCode).IsUnique();
            entity.HasIndex(s => s.Email).IsUnique();
            entity.HasIndex(s => s.IDNumber).IsUnique();
        });

        // Configure Branch relationships
        modelBuilder.Entity<Branch>(entity =>
        {
            entity.HasOne(b => b.Status)
                  .WithMany(gs => gs.Branches)
                  .HasForeignKey(b => b.StatusID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(b => b.BranchCode).IsUnique();
        });

        // Configure Department relationships
        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasOne(d => d.Branch)
                  .WithMany(b => b.Departments)
                  .HasForeignKey(d => d.BranchID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(d => d.ParentDepartment)
                  .WithMany(pd => pd.SubDepartments)
                  .HasForeignKey(d => d.ParentDepartmentID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(d => d.Status)
                  .WithMany(gs => gs.Departments)
                  .HasForeignKey(d => d.StatusID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(d => d.DepartmentCode).IsUnique();
        });

        // Configure TCode
        modelBuilder.Entity<TCode>(entity =>
        {
            entity.HasIndex(t => t.TCodeValue).IsUnique();
        });

        // Configure DashboardMetric relationships
        modelBuilder.Entity<DashboardMetric>(entity =>
        {
            entity.HasOne(dm => dm.MetricType)
                  .WithMany(mt => mt.DashboardMetrics)
                  .HasForeignKey(dm => dm.MetricTypeID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(dm => dm.Branch)
                  .WithMany()
                  .HasForeignKey(dm => dm.BranchID)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(dm => dm.Calculator)
                  .WithMany()
                  .HasForeignKey(dm => dm.CalculatedBy)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Configure MetricType
        modelBuilder.Entity<MetricType>(entity =>
        {
            entity.HasIndex(mt => mt.MetricName).IsUnique();
        });
    }
}