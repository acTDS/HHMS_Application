using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using HHMS_Application.Models;

namespace HHMS_Application.Services
{
    public class RequestService
    {
        private readonly DatabaseService _dbService;

        public RequestService()
        {
            _dbService = new DatabaseService();
        }

        public async Task<ApiResponse<List<RequestSummary>>> GetRequestSummaryAsync(
            int userId, 
            int? departmentId = null,
            int? requestTypeId = null,
            string statusFilter = null,
            string requesterFilter = null,
            string approverFilter = null,
            DateTime? dateFrom = null,
            DateTime? dateTo = null,
            int pageNumber = 1,
            int pageSize = 25)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@DepartmentID", departmentId ?? (object)DBNull.Value),
                    new SqlParameter("@RequestTypeID", requestTypeId ?? (object)DBNull.Value),
                    new SqlParameter("@StatusFilter", statusFilter ?? (object)DBNull.Value),
                    new SqlParameter("@RequesterFilter", requesterFilter ?? (object)DBNull.Value),
                    new SqlParameter("@ApproverFilter", approverFilter ?? (object)DBNull.Value),
                    new SqlParameter("@DateFrom", dateFrom ?? (object)DBNull.Value),
                    new SqlParameter("@DateTo", dateTo ?? (object)DBNull.Value),
                    new SqlParameter("@PageNumber", pageNumber),
                    new SqlParameter("@PageSize", pageSize)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_GetRequestSummaryDashboard", parameters);
                var requests = new List<RequestSummary>();

                foreach (DataRow row in dataTable.Rows)
                {
                    requests.Add(new RequestSummary
                    {
                        RequestID = Convert.ToInt32(row["RequestID"]),
                        RequestCode = row["RequestCode"].ToString(),
                        RequestTypeName = row["RequestTypeName"].ToString(),
                        RequestTypeCode = row["RequestTypeCode"].ToString(),
                        CategoryGroup = row["CategoryGroup"].ToString(),
                        Title = row["Title"].ToString(),
                        RequesterName = row["RequesterName"].ToString(),
                        AppraiserName = row["AppraiserName"]?.ToString(),
                        ApproverName = row["ApproverName"]?.ToString(),
                        StatusDisplayName = row["StatusDisplayName"].ToString(),
                        SubmissionDate = Convert.ToDateTime(row["SubmissionDate"]),
                        ExpectedCompletionDate = row["ExpectedCompletionDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["ExpectedCompletionDate"]),
                        ProcessingDays = Convert.ToInt32(row["ProcessingDays"]),
                        Priority = row["Priority"].ToString(),
                        UrgencyLevel = Convert.ToInt32(row["UrgencyLevel"]),
                        EstimatedCost = row["EstimatedCost"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["EstimatedCost"]),
                        ActualCost = row["ActualCost"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["ActualCost"]),
                        CurrencyCode = row["CurrencyCode"]?.ToString(),
                        DocumentCount = Convert.ToInt32(row["DocumentCount"]),
                        CommentCount = Convert.ToInt32(row["CommentCount"]),
                        ProgressStatus = row["ProgressStatus"].ToString(),
                        LatestAppraisalScore = row["LatestAppraisalScore"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["LatestAppraisalScore"]),
                        LatestRecommendation = row["LatestRecommendation"]?.ToString()
                    });
                }

                return new ApiResponse<List<RequestSummary>>
                {
                    Success = true,
                    Data = requests,
                    Message = "Request summary retrieved successfully",
                    TotalRecords = requests.Count
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<List<RequestSummary>>
                {
                    Success = false,
                    Message = $"Error retrieving request summary: {ex.Message}",
                    Data = new List<RequestSummary>()
                };
            }
        }

        public async Task<ApiResponse<RequestSummary>> GetRequestDetailsAsync(int requestId, int userId)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@RequestID", requestId),
                    new SqlParameter("@UserID", userId)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_GetRequestDetails", parameters);
                
                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var request = new RequestSummary
                    {
                        RequestID = Convert.ToInt32(row["RequestID"]),
                        RequestCode = row["RequestCode"].ToString(),
                        RequestTypeName = row["RequestTypeName"].ToString(),
                        RequestTypeCode = row["RequestTypeCode"].ToString(),
                        CategoryGroup = row["CategoryGroup"].ToString(),
                        Title = row["Title"].ToString(),
                        Description = row["Description"]?.ToString(),
                        RequesterName = row["RequesterName"].ToString(),
                        RequesterEmail = row["RequesterEmail"]?.ToString(),
                        RequesterPosition = row["RequesterPosition"]?.ToString(),
                        RequesterDepartment = row["RequesterDepartment"]?.ToString(),
                        AppraiserName = row["AppraiserName"]?.ToString(),
                        AppraiserEmail = row["AppraiserEmail"]?.ToString(),
                        ApproverName = row["ApproverName"]?.ToString(),
                        ApproverEmail = row["ApproverEmail"]?.ToString(),
                        CurrentStepName = row["CurrentStepName"]?.ToString(),
                        ResponsibleRole = row["ResponsibleRole"]?.ToString(),
                        StepMaxDays = row["StepMaxDays"] == DBNull.Value ? 0 : Convert.ToInt32(row["StepMaxDays"]),
                        StatusDisplayName = row["StatusDisplayName"].ToString(),
                        SystemStatus = row["SystemStatus"].ToString(),
                        StatusColor = row["StatusColor"]?.ToString(),
                        SubmissionDate = Convert.ToDateTime(row["SubmissionDate"]),
                        ExpectedCompletionDate = row["ExpectedCompletionDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["ExpectedCompletionDate"]),
                        ActualCompletionDate = row["ActualCompletionDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["ActualCompletionDate"]),
                        LastActionDate = row["LastActionDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["LastActionDate"]),
                        ProcessingDays = Convert.ToInt32(row["ProcessingDays"]),
                        ProgressStatus = row["ProgressStatus"].ToString(),
                        Priority = row["Priority"].ToString(),
                        UrgencyLevel = Convert.ToInt32(row["UrgencyLevel"]),
                        EstimatedCost = row["EstimatedCost"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["EstimatedCost"]),
                        ActualCost = row["ActualCost"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["ActualCost"]),
                        CurrencyCode = row["CurrencyCode"]?.ToString(),
                        DocumentCount = Convert.ToInt32(row["DocumentCount"]),
                        CommentCount = Convert.ToInt32(row["CommentCount"]),
                        PendingApprovals = Convert.ToInt32(row["PendingApprovals"]),
                        AppraisalCommentCount = Convert.ToInt32(row["AppraisalCommentCount"]),
                        LatestAppraisalScore = row["LatestAppraisalScore"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["LatestAppraisalScore"]),
                        LatestRecommendation = row["LatestRecommendation"]?.ToString(),
                        TargetDepartment = row["TargetDepartment"]?.ToString(),
                        BranchName = row["BranchName"]?.ToString(),
                        ClassName = row["ClassName"]?.ToString(),
                        MajorName = row["MajorName"]?.ToString(),
                        StudentCode = row["StudentCode"]?.ToString(),
                        StudentName = row["StudentName"]?.ToString(),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        ModifiedDate = Convert.ToDateTime(row["ModifiedDate"])
                    };

                    return new ApiResponse<RequestSummary>
                    {
                        Success = true,
                        Data = request,
                        Message = "Request details retrieved successfully"
                    };
                }

                return new ApiResponse<RequestSummary>
                {
                    Success = false,
                    Message = "Request not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<RequestSummary>
                {
                    Success = false,
                    Message = $"Error retrieving request details: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> AppraiseRequestAsync(
            int requestId, 
            int appraisedBy, 
            string commentText,
            int? technicalScore = null,
            int? financialScore = null,
            int? riskScore = null,
            int? impactScore = null,
            string recommendation = "Approve",
            string conditions = null,
            string concerns = null,
            string suggestions = null)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@RequestID", requestId),
                    new SqlParameter("@AppraisedBy", appraisedBy),
                    new SqlParameter("@CommentText", commentText),
                    new SqlParameter("@TechnicalScore", technicalScore ?? (object)DBNull.Value),
                    new SqlParameter("@FinancialScore", financialScore ?? (object)DBNull.Value),
                    new SqlParameter("@RiskScore", riskScore ?? (object)DBNull.Value),
                    new SqlParameter("@ImpactScore", impactScore ?? (object)DBNull.Value),
                    new SqlParameter("@Recommendation", recommendation),
                    new SqlParameter("@Conditions", conditions ?? (object)DBNull.Value),
                    new SqlParameter("@Concerns", concerns ?? (object)DBNull.Value),
                    new SqlParameter("@Suggestions", suggestions ?? (object)DBNull.Value)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_AppraiseRequest", parameters);
                
                if (dataTable.Rows.Count > 0)
                {
                    var result = dataTable.Rows[0];
                    return new ApiResponse<object>
                    {
                        Success = result["Status"].ToString() == "Success",
                        Data = new { Action = result["Action"].ToString() },
                        Message = "Request appraised successfully"
                    };
                }

                return new ApiResponse<object>
                {
                    Success = false,
                    Message = "Failed to appraise request"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error appraising request: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> GetRequestMetricsAsync()
        {
            try
            {
                var query = "SELECT * FROM vw_RequestMetricsSummary";
                var dataTable = await _dbService.ExecuteQueryAsync(query);
                
                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var metrics = new
                    {
                        TotalRequests = Convert.ToInt32(row["TotalRequests"]),
                        PendingAppraisal = Convert.ToInt32(row["PendingAppraisal"]),
                        Appraised = Convert.ToInt32(row["Appraised"]),
                        PendingApproval = Convert.ToInt32(row["PendingApproval"]),
                        Approved = Convert.ToInt32(row["Approved"]),
                        Rejected = Convert.ToInt32(row["Rejected"]),
                        StudentRequests = Convert.ToInt32(row["StudentRequests"]),
                        FinanceRequests = Convert.ToInt32(row["FinanceRequests"]),
                        DocumentRequests = Convert.ToInt32(row["DocumentRequests"]),
                        StaffRequests = Convert.ToInt32(row["StaffRequests"]),
                        CourseRequests = Convert.ToInt32(row["CourseRequests"]),
                        LeaveRequests = Convert.ToInt32(row["LeaveRequests"]),
                        AvgProcessingDays = row["AvgProcessingDays"] == DBNull.Value ? 0.0 : Convert.ToDouble(row["AvgProcessingDays"]),
                        OverdueRequests = Convert.ToInt32(row["OverdueRequests"]),
                        UrgentRequests = Convert.ToInt32(row["UrgentRequests"]),
                        HighPriorityRequests = Convert.ToInt32(row["HighPriorityRequests"]),
                        NormalPriorityRequests = Convert.ToInt32(row["NormalPriorityRequests"]),
                        LowPriorityRequests = Convert.ToInt32(row["LowPriorityRequests"]),
                        TotalEstimatedCost = Convert.ToDecimal(row["TotalEstimatedCost"]),
                        TotalActualCost = Convert.ToDecimal(row["TotalActualCost"]),
                        RequestsLast30Days = Convert.ToInt32(row["RequestsLast30Days"]),
                        CompletedLast30Days = Convert.ToInt32(row["CompletedLast30Days"])
                    };

                    return new ApiResponse<object>
                    {
                        Success = true,
                        Data = metrics,
                        Message = "Request metrics retrieved successfully"
                    };
                }

                return new ApiResponse<object>
                {
                    Success = false,
                    Message = "No metrics data found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error retrieving request metrics: {ex.Message}"
                };
            }
        }
    }
}