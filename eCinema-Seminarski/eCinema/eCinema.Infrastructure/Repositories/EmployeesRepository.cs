using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class EmployeesRepository : BaseRepository<Employee, int, EmployeeSearchObject>, IEmployeesRepository
    {
        public EmployeesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public int getCountOfEmployees(int cinemaId, CancellationToken cancellationToken = default)
        {
            return DbSet.Where(s=>s.CinemaId==cinemaId).AsNoTracking().Count();
        }

        public override async Task<PagedList<Employee>> GetPagedAsync(EmployeeSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(s => s.ProfilePhoto).Include(s => s.Cinema).ThenInclude(s => s.City).ThenInclude(s => s.Country)
                 .Where(u => (searchObject.name == null
                 || u.FirstName.ToLower().Contains(searchObject.name.ToLower())
                 || u.LastName.ToLower().Contains(searchObject.name.ToLower()))
                  && (searchObject.isActive == null || u.isActive == searchObject.isActive)
                  && (searchObject.gender == null || u.Gender == searchObject.gender)
                  && (searchObject.cinemaId == null || u.CinemaId == searchObject.cinemaId))
                  .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
