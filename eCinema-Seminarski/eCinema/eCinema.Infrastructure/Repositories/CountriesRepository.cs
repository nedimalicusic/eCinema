using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class CountriesRepository : BaseRepository<Country, int, CountriesSearchObject>, ICountiresRepository
    {
        public CountriesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Country>> GetPagedAsync(CountriesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(s => searchObject.name == null || s.Name.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
