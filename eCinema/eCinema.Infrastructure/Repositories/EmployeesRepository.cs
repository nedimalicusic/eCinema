using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class EmployeesRepository : BaseRepository<Employee, int, BaseSearchObject>, IEmployeesRepository
    {
        public EmployeesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
