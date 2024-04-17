using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class MovieGenresRepository : BaseRepository<MovieGenre, int, BaseSearchObject>, IMovieGenresRepository
    {
        public MovieGenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public void DetachEntity(MovieGenre entity)
        {
            var entry = DatabaseContext.Entry(entity);
            if (entry != null)
            {
                entry.State = EntityState.Modified;
            }
        }
    }
}
