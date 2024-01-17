using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class MovieActorsRepository : BaseRepository<MovieActors, int, BaseSearchObject>, IMovieActorsRepository
    {
        public MovieActorsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
