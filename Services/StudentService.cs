using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using HHMS_Application.Models;

namespace HHMS_Application.Services
{
    public class StudentService
    {
        private readonly DatabaseService _dbService;

        public StudentService()
        {
            _dbService = new DatabaseService();
        }

        public async Task<ApiResponse<List<Student>>> GetAllStudentsAsync(string searchTerm = null, int? branchId = null)
        {
            try
            {
                var query = @"
                    SELECT s.*, b.BranchName 
                    FROM Student s
                    LEFT JOIN Branch b ON s.BranchID = b.BranchID
                    WHERE s.StatusID = 1";

                var parameters = new List<SqlParameter>();

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND (s.FullName LIKE @SearchTerm OR s.StudentCode LIKE @SearchTerm OR s.Email LIKE @SearchTerm)";
                    parameters.Add(new SqlParameter("@SearchTerm", $"%{searchTerm}%"));
                }

                if (branchId.HasValue)
                {
                    query += " AND s.BranchID = @BranchID";
                    parameters.Add(new SqlParameter("@BranchID", branchId.Value));
                }

                query += " ORDER BY s.StudentCode";

                var dataTable = await _dbService.ExecuteQueryAsync(query, parameters.ToArray());
                var studentList = new List<Student>();

                foreach (DataRow row in dataTable.Rows)
                {
                    studentList.Add(new Student
                    {
                        StudentID = Convert.ToInt32(row["StudentID"]),
                        StudentCode = row["StudentCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Gender = row["Gender"]?.ToString(),
                        BirthDate = row["BirthDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["BirthDate"]),
                        IDNumber = row["IDNumber"]?.ToString(),
                        Phone = row["Phone"]?.ToString(),
                        Email = row["Email"]?.ToString(),
                        StudentAddress = row["StudentAddress"]?.ToString(),
                        ParentID = row["ParentID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["ParentID"]),
                        BranchID = row["BranchID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["BranchID"]),
                        EnrollmentDate = Convert.ToDateTime(row["EnrollmentDate"]),
                        StatusID = Convert.ToInt32(row["StatusID"]),
                        AvatarPath = row["AvatarPath"]?.ToString(),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        LastModified = Convert.ToDateTime(row["LastModified"])
                    });
                }

                return new ApiResponse<List<Student>>
                {
                    Success = true,
                    Data = studentList,
                    Message = "Student list retrieved successfully",
                    TotalRecords = studentList.Count
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<List<Student>>
                {
                    Success = false,
                    Message = $"Error retrieving student list: {ex.Message}",
                    Data = new List<Student>()
                };
            }
        }

        public async Task<ApiResponse<Student>> GetStudentByIdAsync(int studentId)
        {
            try
            {
                var query = @"
                    SELECT s.*, b.BranchName 
                    FROM Student s
                    LEFT JOIN Branch b ON s.BranchID = b.BranchID
                    WHERE s.StudentID = @StudentID";

                var parameters = new[] { new SqlParameter("@StudentID", studentId) };
                var dataTable = await _dbService.ExecuteQueryAsync(query, parameters);

                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var student = new Student
                    {
                        StudentID = Convert.ToInt32(row["StudentID"]),
                        StudentCode = row["StudentCode"].ToString(),
                        FullName = row["FullName"].ToString(),
                        Gender = row["Gender"]?.ToString(),
                        BirthDate = row["BirthDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["BirthDate"]),
                        IDNumber = row["IDNumber"]?.ToString(),
                        Phone = row["Phone"]?.ToString(),
                        Email = row["Email"]?.ToString(),
                        StudentAddress = row["StudentAddress"]?.ToString(),
                        ParentID = row["ParentID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["ParentID"]),
                        BranchID = row["BranchID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["BranchID"]),
                        EnrollmentDate = Convert.ToDateTime(row["EnrollmentDate"]),
                        StatusID = Convert.ToInt32(row["StatusID"]),
                        AvatarPath = row["AvatarPath"]?.ToString(),
                        CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                        LastModified = Convert.ToDateTime(row["LastModified"])
                    };

                    return new ApiResponse<Student>
                    {
                        Success = true,
                        Data = student,
                        Message = "Student retrieved successfully"
                    };
                }

                return new ApiResponse<Student>
                {
                    Success = false,
                    Message = "Student not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<Student>
                {
                    Success = false,
                    Message = $"Error retrieving student: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> CreateStudentAsync(Student student)
        {
            try
            {
                var query = @"
                    INSERT INTO Student (StudentCode, FullName, Gender, BirthDate, IDNumber, 
                                       Phone, Email, StudentAddress, ParentID, BranchID, 
                                       EnrollmentDate, AvatarPath)
                    VALUES (@StudentCode, @FullName, @Gender, @BirthDate, @IDNumber, 
                           @Phone, @Email, @StudentAddress, @ParentID, @BranchID, 
                           @EnrollmentDate, @AvatarPath);
                    SELECT SCOPE_IDENTITY();";

                var parameters = new[]
                {
                    new SqlParameter("@StudentCode", student.StudentCode),
                    new SqlParameter("@FullName", student.FullName),
                    new SqlParameter("@Gender", student.Gender ?? (object)DBNull.Value),
                    new SqlParameter("@BirthDate", student.BirthDate ?? (object)DBNull.Value),
                    new SqlParameter("@IDNumber", student.IDNumber ?? (object)DBNull.Value),
                    new SqlParameter("@Phone", student.Phone ?? (object)DBNull.Value),
                    new SqlParameter("@Email", student.Email ?? (object)DBNull.Value),
                    new SqlParameter("@StudentAddress", student.StudentAddress ?? (object)DBNull.Value),
                    new SqlParameter("@ParentID", student.ParentID ?? (object)DBNull.Value),
                    new SqlParameter("@BranchID", student.BranchID ?? (object)DBNull.Value),
                    new SqlParameter("@EnrollmentDate", student.EnrollmentDate),
                    new SqlParameter("@AvatarPath", student.AvatarPath ?? (object)DBNull.Value)
                };

                var studentId = await _dbService.ExecuteScalarAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = true,
                    Data = new { StudentId = studentId },
                    Message = "Student created successfully"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error creating student: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> UpdateStudentAsync(Student student)
        {
            try
            {
                var query = @"
                    UPDATE Student 
                    SET FullName = @FullName, Gender = @Gender, BirthDate = @BirthDate, 
                        IDNumber = @IDNumber, Phone = @Phone, Email = @Email, 
                        StudentAddress = @StudentAddress, ParentID = @ParentID, 
                        BranchID = @BranchID, EnrollmentDate = @EnrollmentDate, 
                        AvatarPath = @AvatarPath, LastModified = GETDATE()
                    WHERE StudentID = @StudentID";

                var parameters = new[]
                {
                    new SqlParameter("@StudentID", student.StudentID),
                    new SqlParameter("@FullName", student.FullName),
                    new SqlParameter("@Gender", student.Gender ?? (object)DBNull.Value),
                    new SqlParameter("@BirthDate", student.BirthDate ?? (object)DBNull.Value),
                    new SqlParameter("@IDNumber", student.IDNumber ?? (object)DBNull.Value),
                    new SqlParameter("@Phone", student.Phone ?? (object)DBNull.Value),
                    new SqlParameter("@Email", student.Email ?? (object)DBNull.Value),
                    new SqlParameter("@StudentAddress", student.StudentAddress ?? (object)DBNull.Value),
                    new SqlParameter("@ParentID", student.ParentID ?? (object)DBNull.Value),
                    new SqlParameter("@BranchID", student.BranchID ?? (object)DBNull.Value),
                    new SqlParameter("@EnrollmentDate", student.EnrollmentDate),
                    new SqlParameter("@AvatarPath", student.AvatarPath ?? (object)DBNull.Value)
                };

                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Student updated successfully" : "Student not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error updating student: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> DeleteStudentAsync(int studentId)
        {
            try
            {
                var query = @"
                    UPDATE Student 
                    SET StatusID = (SELECT StatusID FROM GeneralStatus WHERE StatusName = 'Inactive'),
                        LastModified = GETDATE()
                    WHERE StudentID = @StudentID";

                var parameters = new[] { new SqlParameter("@StudentID", studentId) };
                var affectedRows = await _dbService.ExecuteNonQueryAsync(query, parameters);

                return new ApiResponse<object>
                {
                    Success = affectedRows > 0,
                    Message = affectedRows > 0 ? "Student deactivated successfully" : "Student not found"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error deactivating student: {ex.Message}"
                };
            }
        }

        public async Task<ApiResponse<object>> GetStudentStatisticsAsync()
        {
            try
            {
                var query = @"
                    SELECT 
                        COUNT(*) as TotalStudents,
                        SUM(CASE WHEN Gender = 'Nam' THEN 1 ELSE 0 END) as MaleStudents,
                        SUM(CASE WHEN Gender = 'Nữ' THEN 1 ELSE 0 END) as FemaleStudents,
                        COUNT(DISTINCT BranchID) as BranchesWithStudents,
                        AVG(DATEDIFF(YEAR, BirthDate, GETDATE())) as AverageAge
                    FROM Student 
                    WHERE StatusID = 1 AND BirthDate IS NOT NULL";

                var dataTable = await _dbService.ExecuteQueryAsync(query);
                
                if (dataTable.Rows.Count > 0)
                {
                    var row = dataTable.Rows[0];
                    var statistics = new
                    {
                        TotalStudents = Convert.ToInt32(row["TotalStudents"]),
                        MaleStudents = Convert.ToInt32(row["MaleStudents"]),
                        FemaleStudents = Convert.ToInt32(row["FemaleStudents"]),
                        BranchesWithStudents = Convert.ToInt32(row["BranchesWithStudents"]),
                        AverageAge = row["AverageAge"] == DBNull.Value ? 0.0 : Convert.ToDouble(row["AverageAge"])
                    };

                    return new ApiResponse<object>
                    {
                        Success = true,
                        Data = statistics,
                        Message = "Student statistics retrieved successfully"
                    };
                }

                return new ApiResponse<object>
                {
                    Success = false,
                    Message = "No student statistics available"
                };
            }
            catch (Exception ex)
            {
                return new ApiResponse<object>
                {
                    Success = false,
                    Message = $"Error retrieving student statistics: {ex.Message}"
                };
            }
        }
    }
}