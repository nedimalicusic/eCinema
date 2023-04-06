using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class ProductionsRepository : BaseRepository<Production, int, BaseSearchObject>, IProductionsRepository
    {
        public ProductionsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
