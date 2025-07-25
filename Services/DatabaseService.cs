using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;

namespace HHMS_Application.Services
{
    public class DatabaseService
    {
        private readonly string _connectionString;

        public DatabaseService()
        {
            // Initialize connection string - can be moved to configuration
            _connectionString = "Data Source=(local);Initial Catalog=HHMS_NgoaiNgu68;Integrated Security=true;TrustServerCertificate=true;";
        }

        public async Task<DataTable> ExecuteStoredProcedureAsync(string procedureName, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                using (var command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    
                    if (parameters != null)
                    {
                        command.Parameters.AddRange(parameters);
                    }

                    await connection.OpenAsync();
                    
                    using (var adapter = new SqlDataAdapter(command))
                    {
                        var dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
        }

        public async Task<object> ExecuteScalarAsync(string query, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                using (var command = new SqlCommand(query, connection))
                {
                    if (parameters != null)
                    {
                        command.Parameters.AddRange(parameters);
                    }

                    await connection.OpenAsync();
                    return await command.ExecuteScalarAsync();
                }
            }
        }

        public async Task<int> ExecuteNonQueryAsync(string query, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                using (var command = new SqlCommand(query, connection))
                {
                    if (parameters != null)
                    {
                        command.Parameters.AddRange(parameters);
                    }

                    await connection.OpenAsync();
                    return await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<T> ExecuteQuerySingleAsync<T>(string query, params SqlParameter[] parameters) where T : class, new()
        {
            var dataTable = await ExecuteQueryAsync(query, parameters);
            if (dataTable.Rows.Count > 0)
            {
                return DataTableToObject<T>(dataTable.Rows[0]);
            }
            return null;
        }

        public async Task<DataTable> ExecuteQueryAsync(string query, params SqlParameter[] parameters)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                using (var command = new SqlCommand(query, connection))
                {
                    if (parameters != null)
                    {
                        command.Parameters.AddRange(parameters);
                    }

                    await connection.OpenAsync();
                    
                    using (var adapter = new SqlDataAdapter(command))
                    {
                        var dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
        }

        private T DataTableToObject<T>(DataRow row) where T : class, new()
        {
            var obj = new T();
            var properties = typeof(T).GetProperties();

            foreach (var property in properties)
            {
                if (row.Table.Columns.Contains(property.Name) && row[property.Name] != DBNull.Value)
                {
                    property.SetValue(obj, Convert.ChangeType(row[property.Name], property.PropertyType));
                }
            }

            return obj;
        }

        public string DataTableToJson(DataTable dataTable)
        {
            return JsonConvert.SerializeObject(dataTable, Formatting.Indented);
        }
    }
}