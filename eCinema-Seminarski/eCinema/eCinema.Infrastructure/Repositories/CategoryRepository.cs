using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;

namespace eCinema.Infrastructure.Repositories
{
    public class CategoryRepository : BaseRepository<Category, int, BaseSearchObject>, ICategoryRepository
    {
        public CategoryRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
