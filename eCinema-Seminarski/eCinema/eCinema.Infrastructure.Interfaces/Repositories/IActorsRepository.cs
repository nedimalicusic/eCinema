using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IActorsRepository : IBaseRepository<Actors,int, ActorSearchObject>
    {
    }
}
