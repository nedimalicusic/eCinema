using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure
{
    public class ActorsRepository : BaseRepository<Actors, int, ActorSearchObject>,IActorsRepository
    {
        public ActorsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Actors>> GetPagedAsync(ActorSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(s => searchObject.name == null || s.FirstName.ToLower().Contains(searchObject.name.ToLower()) || s.LastName.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
