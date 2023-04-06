using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class ShowsRepository : BaseRepository<Show, int, BaseSearchObject>, IShowsRepository
    {
        public ShowsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
