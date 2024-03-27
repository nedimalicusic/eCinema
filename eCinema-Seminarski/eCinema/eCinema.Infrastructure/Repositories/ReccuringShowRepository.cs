using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;

namespace eCinema.Infrastructure.Repositories
{
    public class ReccuringShowRepository : BaseRepository<ReccuringShows, int, BaseSearchObject>, IReccuringShowRepository
    {
        public ReccuringShowRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
