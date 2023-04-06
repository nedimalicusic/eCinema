using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class SeatsRepository : BaseRepository<Seat, int, BaseSearchObject>, ISeatsRepository
    {
        public SeatsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
