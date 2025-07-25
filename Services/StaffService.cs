using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using HHMS_Application.Models;

namespace HHMS_Application.Services
{
    public class StaffService
    {
        private readonly DatabaseService _dbService;

        public StaffService()
        {
            _dbService = new DatabaseService();
        }

        public async Task<ApiResponse<List<Staff>>> GetAllStaffAsync(string searchTerm = null, int? departmentId = null, int? branchId = null)
        {
            try
            {
                var query = @"
                    SELECT s.*, d.DepartmentName, b.BranchName 
                    FROM Staff s
                    LEFT JOIN Department d ON s.DepartmentID = d.DepartmentID
                    LEFT JOIN Branch b ON s.BranchID = b.BranchID
                    WHERE s.StatusID = 1";

                var parameters = new List<SqlParameter>();

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND (s.FullName LIKE @SearchTerm OR s.StaffCode LIKE @SearchTerm OR s.Email LIKE @SearchTerm)";
                    parameters.Add(new SqlParameter("@SearchTerm", $"%{searchTerm}%"));
                }

                if (departmentId.HasValue)
                {
                    query += " AND s.DepartmentID = @DepartmentID";
                    parameters.Add(new SqlParameter("@DepartmentID", departmentId.Value));
                }

                if (branchId.HasValue)
                {
                    query += " AND s.BranchID = @BranchID";
                    parameters.Add(new SqlParameter("@BranchID", branchId.Value));
                }

                query += " ORDER BY s.StaffCode";

                var dataTable = await _dbService.ExecuteQueryAsync(query, parameters.ToArray());
                var staffList = new List<Staff>();

                foreach (DataRow row in dataTable.Rows)
                {
                    staffList.Add(new Staff
                    {
                        StaffID = Convert.ToInt32(row["StaffID"]),
                        StaffCode = row["StaffCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Gender = row["Gender"]?.ToString(),
                        IDNumber = row["IDNumber"]?.ToString(),
                        BirthDate = row["BirthDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["BirthDate"]),
                        StaffAddress = row["StaffAddress"]?.ToString(),
                        Phone = row["Phone"]?.ToString(),
                        Email = row["Email"]?.ToString(),
                        ContractType = row["ContractType"]?.ToString(),
                        Position = row["Position"]?.ToString(),
                        BranchID = row["BranchID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["BranchID"]),
                        DepartmentID = row["DepartmentID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["DepartmentID"]),
                        HireDate = Convert.ToDateTime(row["HireDate"]),
                        BaseSalary = Convert.ToDecimal(row["BaseSalary"]),
                        StatusID = Convert.ToInt32(row["StatusID"]),
                        AvatarPath = row["AvatarPath"]?.ToString(),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        LastModified = Convert.ToDateTime(row["LastModified"])
                    });
                }

                return new ApiResponse<List<Staff>>
                {
                    Success = true,
                    Data = staffList,
                    Message = "Staff list retrieved successfully",
                    TotalRecords = staffList.Count
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<List<Staff>>
                {
                    Success = false,
                    Message = $"Error retrieving staff list: {ex.Message}",
                    Data = new List<Staff>()
                };
            }
        }

        public async Task<ApiResponse<Staff>> GetStaffByIdAsync(int staffId)
        {
            try
            {
                var query = @"
                    SELECT s.*, d.DepartmentName, b.BranchName 
                    FROM Staff s
                    LEFT JOIN Department d ON s.DepartmentID = d.DepartmentID
                    LEFT JOIN Branch b ON s.BranchID = b.BranchID
                    WHERE s.StaffID = @StaffID";

                var parameters = new[] { new SqlParameter("@StaffID", staffId) };
                var dataTable = await _dbService.ExecuteQueryAsync(query, parameters);

                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var staff = new Staff
                    {
                        StaffID = Convert.ToInt32(row["StaffID"]),
                        StaffCode = row["StaffCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Gender = row["Gender"]?.ToString(),
                        IDNumber = row["IDNumber"]?.ToString(),
                        BirthDate = row["BirthDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["BirthDate"]),
                        StaffAddress = row["StaffAddress"]?.ToString(),
                        Phone = row["Phone"]?.ToString(),
                        Email = row["Email"]?.ToString(),
                        ContractType = row["ContractType"]?.ToString(),
                        Position = row["Position"]?.ToString(),
                        BranchID = row["BranchID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["BranchID"]),
                        DepartmentID = row["DepartmentID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["DepartmentID"]),
                        HireDate = Convert.ToDateTime(row["HireDate"]),
                        BaseSalary = Convert.ToDecimal(row["BaseSalary"]),
                        StatusID = Convert.ToInt32(row["StatusID"]),
                        AvatarPath = row["AvatarPath"]?.ToString(),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        LastModified = Convert.ToDateTime(row["LastModified"])
                    };

                    return new ApiResponse<Staff>
                    {
                        Success = true,
                        Data = staff,
                        Message = "Staff retrieved successfully"
                    };
                }

                return new ApiResponse<Staff>
                {
                    Success = false,
                    Message = "Staff not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<Staff>
                {
                    Success = false,
                    Message = $"Error retrieving staff: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> CreateStaffAsync(Staff staff)
        {
            try
            {
                var query = @"
                    INSERT INTO Staff (StaffCode, FullName, Gender, IDNumber, BirthDate, StaffAddress, 
                                     Phone, Email, ContractType, Position, BranchID, DepartmentID, 
                                     HireDate, BaseSalary, AvatarPath)
                    VALUES (@StaffCode, @FullName, @Gender, @IDNumber, @BirthDate, @StaffAddress, 
                           @Phone, @Email, @ContractType, @Position, @BranchID, @DepartmentID, 
                           @HireDate, @BaseSalary, @AvatarPath);
                    SELECT SCOPE_IDENTITY();";

                var parameters = new[]
                {
                    new SqlParameter("@StaffCode", staff.StaffCode),
                    new SqlParameter("@FullName", staff.FullName),
                    new SqlParameter("@Gender", staff.Gender ?? (object)DBNull.Value),
                    new SqlParameter("@IDNumber", staff.IDNumber ?? (object)DBNull.Value),
                    new SqlParameter("@BirthDate", staff.BirthDate ?? (object)DBNull.Value),
                    new SqlParameter("@StaffAddress", staff.StaffAddress ?? (object)DBNull.Value),
                    new SqlParameter("@Phone", staff.Phone ?? (object)DBNull.Value),
                    new SqlParameter("@Email", staff.Email ?? (object)DBNull.Value),
                    new SqlParameter("@ContractType", staff.ContractType ?? (object)DBNull.Value),
                    new SqlParameter("@Position", staff.Position ?? (object)DBNull.Value),
                    new SqlParameter("@BranchID", staff.BranchID ?? (object)DBNull.Value),
                    new SqlParameter("@DepartmentID", staff.DepartmentID ?? (object)DBNull.Value),
                    new SqlParameter("@HireDate", staff.HireDate),
                    new SqlParameter("@BaseSalary", staff.BaseSalary),
                    new SqlParameter("@AvatarPath", staff.AvatarPath ?? (object)DBNull.Value)
                };

                var staffId = await _dbService.ExecuteScalarAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = true,
                    Data = new { StaffId = staffId },
                    Message = "Staff created successfully"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error creating staff: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> UpdateStaffAsync(Staff staff)
        {
            try
            {
                var query = @"
                    UPDATE Staff 
                    SET FullName = @FullName, Gender = @Gender, IDNumber = @IDNumber, 
                        BirthDate = @BirthDate, StaffAddress = @StaffAddress, Phone = @Phone, 
                        Email = @Email, ContractType = @ContractType, Position = @Position, 
                        BranchID = @BranchID, DepartmentID = @DepartmentID, HireDate = @HireDate, 
                        BaseSalary = @BaseSalary, AvatarPath = @AvatarPath, LastModified = GETDATE()
                    WHERE StaffID = @StaffID";

                var parameters = new[]
                {
                    new SqlParameter("@StaffID", staff.StaffID),
                    new SqlParameter("@FullName", staff.FullName),
                    new SqlParameter("@Gender", staff.Gender ?? (object)DBNull.Value),
                    new SqlParameter("@IDNumber", staff.IDNumber ?? (object)DBNull.Value),
                    new SqlParameter("@BirthDate", staff.BirthDate ?? (object)DBNull.Value),
                    new SqlParameter("@StaffAddress", staff.StaffAddress ?? (object)DBNull.Value),
                    new SqlParameter("@Phone", staff.Phone ?? (object)DBNull.Value),
                    new SqlParameter("@Email", staff.Email ?? (object)DBNull.Value),
                    new SqlParameter("@ContractType", staff.ContractType ?? (object)DBNull.Value),
                    new SqlParameter("@Position", staff.Position ?? (object)DBNull.Value),
                    new SqlParameter("@BranchID", staff.BranchID ?? (object)DBNull.Value),
                    new SqlParameter("@DepartmentID", staff.DepartmentID ?? (object)DBNull.Value),
                    new SqlParameter("@HireDate", staff.HireDate),
                    new SqlParameter("@BaseSalary", staff.BaseSalary),
                    new SqlParameter("@AvatarPath", staff.AvatarPath ?? (object)DBNull.Value)
                };

                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Staff updated successfully" : "Staff not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error updating staff: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> DeleteStaffAsync(int staffId)
        {
            try
            {
                var query = @"
                    UPDATE Staff 
                    SET StatusID = (SELECT StatusID FROM GeneralStatus WHERE StatusName = 'Inactive'),
                        LastModified = GETDATE()
                    WHERE StaffID = @StaffID";

                var parameters = new[] { new SqlParameter("@StaffID", staffId) };
                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Staff deactivated successfully" : "Staff not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error deactivating staff: {ex.Message}"
                };
            }
        }
    }
}