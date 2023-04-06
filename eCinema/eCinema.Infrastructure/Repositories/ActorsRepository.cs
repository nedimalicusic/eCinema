using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class ActorsRepository : BaseRepository<Actors, int, BaseSearchObject>,IActorsRepository
    {
        public ActorsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
