using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class MovieGenresRepository : BaseRepository<MovieGenre, int, BaseSearchObject>, IMovieGenresRepository
    {
        public MovieGenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
