using System;

namespace HHMS_Application.Models
{
    public class DashboardMetric
    {
        public int MetricID { get; set; }
        public string MetricName { get; set; }
        public string DisplayName { get; set; }
        public string IconClass { get; set; }
        public string Unit { get; set; }
        public decimal CurrentValue { get; set; }
        public decimal? PreviousValue { get; set; }
        public decimal? ChangePercentage { get; set; }
        public string ChangeType { get; set; }
        public string BranchName { get; set; }
        public DateTime LastUpdated { get; set; }
    }

    public class Account
    {
        public int AccountID { get; set; }
        public int StaffID { get; set; }
        public string StaffCode { get; set; }
        public string FullName { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string DisplayName { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public string AccountStatus { get; set; }
        public DateTime? LastLogin { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsLocked { get; set; }
        public int LoginAttempts { get; set; }
        public bool FirstLoginChangePwd { get; set; }
        public bool PasswordResetRequired { get; set; }
        public int EffectivePermissionCount { get; set; }
    }

    public class RequestSummary
    {
        public int RequestID { get; set; }
        public string RequestCode { get; set; }
        public string RequestTypeName { get; set; }
        public string RequestTypeCode { get; set; }
        public string CategoryGroup { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Priority { get; set; }
        public int UrgencyLevel { get; set; }
        public string RequesterName { get; set; }
        public string RequesterEmail { get; set; }
        public string RequesterPosition { get; set; }
        public string RequesterDepartment { get; set; }
        public string AppraiserName { get; set; }
        public string AppraiserEmail { get; set; }
        public string ApproverName { get; set; }
        public string ApproverEmail { get; set; }
        public string CurrentStepName { get; set; }
        public string ResponsibleRole { get; set; }
        public int StepMaxDays { get; set; }
        public string StatusDisplayName { get; set; }
        public string SystemStatus { get; set; }
        public string StatusColor { get; set; }
        public DateTime SubmissionDate { get; set; }
        public DateTime? ExpectedCompletionDate { get; set; }
        public DateTime? ActualCompletionDate { get; set; }
        public DateTime? LastActionDate { get; set; }
        public int ProcessingDays { get; set; }
        public string ProgressStatus { get; set; }
        public decimal? EstimatedCost { get; set; }
        public decimal? ActualCost { get; set; }
        public string CurrencyCode { get; set; }
        public int DocumentCount { get; set; }
        public int CommentCount { get; set; }
        public int PendingApprovals { get; set; }
        public int AppraisalCommentCount { get; set; }
        public decimal? LatestAppraisalScore { get; set; }
        public string LatestRecommendation { get; set; }
        public string TargetDepartment { get; set; }
        public string BranchName { get; set; }
        public string ClassName { get; set; }
        public string MajorName { get; set; }
        public string StudentCode { get; set; }
        public string StudentName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
    }

    public class Staff
    {
        public int StaffID { get; set; }
        public string StaffCode { get; set; }
        public string FullName { get; set; }
        public string Gender { get; set; }
        public string IDNumber { get; set; }
        public DateTime? BirthDate { get; set; }
        public string StaffAddress { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string ContractType { get; set; }
        public string Position { get; set; }
        public int? BranchID { get; set; }
        public int? DepartmentID { get; set; }
        public DateTime HireDate { get; set; }
        public decimal BaseSalary { get; set; }
        public int StatusID { get; set; }
        public string AvatarPath { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
    }

    public class Student
    {
        public int StudentID { get; set; }
        public string StudentCode { get; set; }
        public string FullName { get; set; }
        public string Gender { get; set; }
        public DateTime? BirthDate { get; set; }
        public string IDNumber { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string StudentAddress { get; set; }
        public int? ParentID { get; set; }
        public int? BranchID { get; set; }
        public DateTime EnrollmentDate { get; set; }
        public int StatusID { get; set; }
        public string AvatarPath { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
    }

    public class Branch
    {
        public int BranchID { get; set; }
        public string BranchCode { get; set; }
        public string BranchName { get; set; }
        public string BranchAddress { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string BranchLicense { get; set; }
        public string BranchDirector { get; set; }
        public DateTime? EstablishedDate { get; set; }
        public int StatusID { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
    }

    public class Department
    {
        public int DepartmentID { get; set; }
        public string DepartmentCode { get; set; }
        public string DepartmentName { get; set; }
        public string Description { get; set; }
        public string ManagerStaffName { get; set; }
        public int StaffQuota { get; set; }
        public int? BranchID { get; set; }
        public int StatusID { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModified { get; set; }
    }

    public class ApiResponse<T>
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public T Data { get; set; }
        public int TotalRecords { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.Now;
    }
}