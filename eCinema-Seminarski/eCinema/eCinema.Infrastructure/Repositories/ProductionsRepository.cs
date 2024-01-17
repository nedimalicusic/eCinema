using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class ProductionsRepository : BaseRepository<Production, int, ProductionSearchObject>, IProductionsRepository
    {
        public ProductionsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Production>> GetPagedAsync(ProductionSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(s=>s.Country).Where(s => searchObject.name == null || s.Name.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
