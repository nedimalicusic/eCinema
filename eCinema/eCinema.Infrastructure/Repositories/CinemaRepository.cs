using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class CinemaRepository : BaseRepository<Cinema, int, BaseSearchObject>, ICinemasRepository
    {
        public CinemaRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
