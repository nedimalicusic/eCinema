using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IEmployeesService : IBaseService<int,EmployeeDto,EmployeeUpsertDto,BaseSearchObject>
    {
    }
}
