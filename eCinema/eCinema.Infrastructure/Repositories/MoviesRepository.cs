using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class MoviesRepository : BaseRepository<Movie, int, BaseSearchObject>, IMoviesRepository
    {
        public MoviesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
