using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure.Repositories
{
    public class MovieCategoryRepository : BaseRepository<MovieCategory, int, BaseSearchObject>, IMovieCategoryRepository
    {
        public MovieCategoryRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public void DetachEntity(MovieCategory entity)
        {
            var entry = DatabaseContext.Entry(entity);
            if (entry != null)
            {
                entry.State = EntityState.Modified;
            }
        }

    }
}
