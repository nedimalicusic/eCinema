using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class GenresRepository : BaseRepository<Genre, int, BaseSearchObject>, IGenresRepository
    {
        public GenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
