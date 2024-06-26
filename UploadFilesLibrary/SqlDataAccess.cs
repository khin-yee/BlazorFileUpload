﻿using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UploadFilesLibrary
{
    public class SqlDataAccess : ISqlDataAccess
    {
        private readonly IConfiguration _config;
        public SqlDataAccess(IConfiguration config)
        {
            _config = config;
        }
        public async Task<List<T>> LoadData<T>(string storedProc,string connectionName,object? parameters)
        {
            string connectionString = _config.GetConnectionString(connectionName) ??
               throw new Exception($"Missing connection string at {connectionName}");
            var connection = new SqlConnection(connectionString);
            var rows = await connection.QueryAsync<T>(storedProc, parameters, commandType: System.Data.CommandType.StoredProcedure);
            return rows.ToList(); 
        }
        public async Task SaveData(string storedProc, string connectionName, object parameters)
        {
            string connectionString = _config.GetConnectionString(connectionName) ??
                throw new Exception($"Missing connection string at {connectionName}");
            var connection = new SqlConnection(connectionString);
            await connection.ExecuteAsync(storedProc, parameters, commandType: System.Data.CommandType.StoredProcedure);
        }
        public async Task DeleteData(string storedProcedure, string connectionStringName, int id)
        {
            using (IDbConnection connection = new SqlConnection(_config.GetConnectionString(connectionStringName)))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@id", id); // Ensure the parameter name matches the stored procedure's parameter

                await connection.ExecuteAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            }
        }
    }
}
