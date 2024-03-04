using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IEmployeesRepository : IBaseRepository<Employee,int,EmployeeSearchObject>
    {
        int getCountOfEmployees(int? cinemaId,CancellationToken cancellationToken = default);
    }
}
