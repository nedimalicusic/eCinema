using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class CitiesRepository : BaseRepository<City, int, CitiesSearchObject>, ICitiesRepository
    {
        public CitiesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<City>> GetPagedAsync(CitiesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(s => s.Country).Where(s=> searchObject.name==null || s.Name.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
