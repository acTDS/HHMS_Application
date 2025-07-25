using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using HHMS_Application.Models;

namespace HHMS_Application.Services
{
    public class DashboardService
    {
        private readonly DatabaseService _dbService;

        public DashboardService()
        {
            _dbService = new DatabaseService();
        }

        public async Task<ApiResponse<List<DashboardMetric>>> GetDashboardMetricsAsync(int? branchId = null, int userId = 1)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@BranchID", branchId ?? (object)DBNull.Value),
                    new SqlParameter("@UserID", userId)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_GetDashboardData", parameters);
                var metrics = new List<DashboardMetric>();

                foreach (DataRow row in dataTable.Rows)
                {
                    metrics.Add(new DashboardMetric
                    {
                        MetricID = Convert.ToInt32(row["MetricID"]),
                        MetricName = row["MetricName"].ToString(),
                        DisplayName = row["DisplayName"].ToString(),
                        IconClass = row["IconClass"].ToString(),
                        Unit = row["Unit"].ToString(),
                        CurrentValue = Convert.ToDecimal(row["CurrentValue"]),
                        PreviousValue = row["PreviousValue"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["PreviousValue"]),
                        ChangePercentage = row["ChangePercentage"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["ChangePercentage"]),
                        ChangeType = row["ChangeType"].ToString(),
                        BranchName = row["BranchName"].ToString(),
                        LastUpdated = Convert.ToDateTime(row["LastUpdated"])
                    });
                }

                return new ApiResponse<List<DashboardMetric>>
                {
                    Success = true,
                    Data = metrics,
                    Message = "Dashboard metrics retrieved successfully",
                    TotalRecords = metrics.Count
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<List<DashboardMetric>>
                {
                    Success = false,
                    Message = $"Error retrieving dashboard metrics: {ex.Message}",
                    Data = new List<DashboardMetric>()
                };
            }
        }

        public async Task<ApiResponse<object>> GetDashboardSummaryAsync(int userId = 1)
        {
            try
            {
                var query = @"
                    SELECT 
                        (SELECT COUNT(*) FROM vw_RequestSummaryDashboard WHERE StatusDisplayName = 'Đang chờ thẩm định') as PendingAppraisal,
                        (SELECT COUNT(*) FROM vw_RequestSummaryDashboard WHERE StatusDisplayName = 'Đã thẩm định') as Appraised,
                        (SELECT COUNT(*) FROM vw_RequestSummaryDashboard WHERE StatusDisplayName = 'Đang chờ phê duyệt') as PendingApproval,
                        (SELECT COUNT(*) FROM vw_RequestSummaryDashboard WHERE StatusDisplayName = 'Đã phê duyệt') as Approved,
                        (SELECT COUNT(*) FROM vw_RequestSummaryDashboard WHERE StatusDisplayName = 'Đã từ chối') as Rejected,
                        (SELECT COUNT(*) FROM Staff WHERE StatusID = 1) as TotalStaff,
                        (SELECT COUNT(*) FROM Student WHERE StatusID = 1) as TotalStudents";

                var dataTable = await _dbService.ExecuteQueryAsync(query);
                
                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var summary = new
                    {
                        PendingAppraisal = Convert.ToInt32(row["PendingAppraisal"]),
                        Appraised = Convert.ToInt32(row["Appraised"]),
                        PendingApproval = Convert.ToInt32(row["PendingApproval"]),
                        Approved = Convert.ToInt32(row["Approved"]),
                        Rejected = Convert.ToInt32(row["Rejected"]),
                        TotalStaff = Convert.ToInt32(row["TotalStaff"]),
                        TotalStudents = Convert.ToInt32(row["TotalStudents"])
                    };

                    return new ApiResponse<object>
                    {
                        Success = true,
                        Data = summary,
                        Message = "Dashboard summary retrieved successfully"
                    };
                }

                return new ApiResponse<object>
                {
                    Success = false,
                    Message = "No dashboard data found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error retrieving dashboard summary: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> UpdateMetricsAsync(int? branchId = null)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@BranchID", branchId ?? (object)DBNull.Value)
                };

                await _dbService.ExecuteStoredProcedureAsync("sp_UpdateDashboardMetrics", parameters);

                return new ApiResponse<object>
                {
                    Success = true,
                    Message = "Dashboard metrics updated successfully"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error updating dashboard metrics: {ex.Message}"
                };
            }
        }
    }
}