using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class ShowSeatsRepository : BaseRepository<ShowSeat, int, BaseSearchObject>, IShowSeatsRepository
    {
        public ShowSeatsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
