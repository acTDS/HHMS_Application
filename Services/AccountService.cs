using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using HHMS_Application.Models;

namespace HHMS_Application.Services
{
    public class AccountService
    {
        private readonly DatabaseService _dbService;

        public AccountService()
        {
            _dbService = new DatabaseService();
        }

        public async Task<ApiResponse<List<Account>>> GetAccountsAsync(string searchTerm = null, int? statusFilter = null, int? roleFilter = null)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@SearchTerm", searchTerm ?? (object)DBNull.Value),
                    new SqlParameter("@StatusFilter", statusFilter ?? (object)DBNull.Value),
                    new SqlParameter("@RoleFilter", roleFilter ?? (object)DBNull.Value)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_GetAccountsForManagement", parameters);
                var accounts = new List<Account>();

                foreach (DataRow row in dataTable.Rows)
                {
                    accounts.Add(new Account
                    {
                        AccountID = Convert.ToInt32(row["AccountID"]),
                        StaffID = Convert.ToInt32(row["StaffID"]),
                        StaffCode = row["StaffCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Username = row["Username"].ToString(),
                        Email = row["Email"].ToString(),
                        DisplayName = row["DisplayName"].ToString(),
                        RoleID = row["RoleID"] == DBNull.Value ? 0 : Convert.ToInt32(row["RoleID"]),
                        RoleName = row["RoleName"]?.ToString(),
                        AccountStatus = row["AccountStatus"].ToString(),
                        LastLogin = row["LastLogin"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["LastLogin"]),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        IsLocked = Convert.ToBoolean(row["IsLocked"]),
                        LoginAttempts = Convert.ToInt32(row["LoginAttempts"]),
                        FirstLoginChangePwd = Convert.ToBoolean(row["FirstLoginChangePwd"]),
                        PasswordResetRequired = Convert.ToBoolean(row["PasswordResetRequired"]),
                        EffectivePermissionCount = Convert.ToInt32(row["EffectivePermissionCount"])
                    });
                }

                return new ApiResponse<List<Account>>
                {
                    Success = true,
                    Data = accounts,
                    Message = "Accounts retrieved successfully",
                    TotalRecords = accounts.Count
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<List<Account>>
                {
                    Success = false,
                    Message = $"Error retrieving accounts: {ex.Message}",
                    Data = new List<Account>()
                };
            }
        }

        public async Task<ApiResponse<Account>> GetAccountByIdAsync(int accountId)
        {
            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@AccountID", accountId)
                };

                var dataTable = await _dbService.ExecuteStoredProcedureAsync("sp_GetAccountPermissions", parameters);
                
                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var account = new Account
                    {
                        AccountID = Convert.ToInt32(row["AccountID"]),
                        StaffID = Convert.ToInt32(row["StaffID"]),
                        StaffCode = row["StaffCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Username = row["Username"].ToString(),
                        Email = row["Email"].ToString(),
                        DisplayName = row["DisplayName"].ToString(),
                        RoleID = row["RoleID"] == DBNull.Value ? 0 : Convert.ToInt32(row["RoleID"]),
                        RoleName = row["RoleName"]?.ToString(),
                        AccountStatus = row["AccountStatus"].ToString(),
                        LastLogin = row["LastLogin"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["LastLogin"]),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        IsLocked = Convert.ToBoolean(row["IsLocked"]),
                        LoginAttempts = Convert.ToInt32(row["LoginAttempts"]),
                        FirstLoginChangePwd = Convert.ToBoolean(row["FirstLoginChangePwd"]),
                        PasswordResetRequired = Convert.ToBoolean(row["PasswordResetRequired"]),
                        EffectivePermissionCount = Convert.ToInt32(row["EffectivePermissionCount"])
                    };

                    return new ApiResponse<Account>
                    {
                        Success = true,
                        Data = account,
                        Message = "Account retrieved successfully"
                    };
                }

                return new ApiResponse<Account>
                {
                    Success = false,
                    Message = "Account not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<Account>
                {
                    Success = false,
                    Message = $"Error retrieving account: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> CreateAccountAsync(string username, string email, int staffId, string displayName)
        {
            try
            {
                var query = @"
                    INSERT INTO Account (StaffID, Username, PasswordHash, Email, DisplayName, FirstLoginChangePwd)
                    VALUES (@StaffID, @Username, 'default_password_hash', @Email, @DisplayName, 1);
                    SELECT SCOPE_IDENTITY();";

                var parameters = new[]
                {
                    new SqlParameter("@StaffID", staffId),
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@DisplayName", displayName)
                };

                var accountId = await _dbService.ExecuteScalarAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = true,
                    Data = new { AccountId = accountId },
                    Message = "Account created successfully"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error creating account: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> UpdateAccountAsync(int accountId, string email, string displayName, bool isLocked, bool passwordResetRequired)
        {
            try
            {
                var query = @"
                    UPDATE Account 
                    SET Email = @Email, 
                        DisplayName = @DisplayName, 
                        IsLocked = @IsLocked, 
                        PasswordResetRequired = @PasswordResetRequired,
                        LastModified = GETDATE()
                    WHERE AccountID = @AccountID";

                var parameters = new[]
                {
                    new SqlParameter("@AccountID", accountId),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@DisplayName", displayName),
                    new SqlParameter("@IsLocked", isLocked),
                    new SqlParameter("@PasswordResetRequired", passwordResetRequired)
                };

                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Account updated successfully" : "Account not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error updating account: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> DeleteAccountAsync(int accountId)
        {
            try
            {
                var query = @"
                    UPDATE Account 
                    SET StatusID = (SELECT StatusID FROM GeneralStatus WHERE StatusName = 'Inactive'),
                        LastModified = GETDATE()
                    WHERE AccountID = @AccountID";

                var parameters = new[]
                {
                    new SqlParameter("@AccountID", accountId)
                };

                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Account deactivated successfully" : "Account not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error deactivating account: {ex.Message}"
                };
            }
        }
    }
}