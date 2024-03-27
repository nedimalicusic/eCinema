using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;

namespace eCinema.Infrastructure.Repositories
{
    public class MovieCategoryRepository : BaseRepository<MovieCategory, int, BaseSearchObject>, IMovieCategoryRepository
    {
        public MovieCategoryRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
