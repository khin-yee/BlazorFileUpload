

namespace UploadFilesLibrary
{
    public interface ISqlDataAccess
    {
        Task<List<T>> LoadData<T>(string storedProc, string connectionName, object? parameters);
        Task SaveData(string storedProc, string connectionName, object parameters);
        Task DeleteData(string storedProc, string connectionName, int parameters);

    }
}