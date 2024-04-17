using eCinema.Core;
using eCinema.Core.Entities;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMovieActorsRepository : IBaseRepository<MovieActors,int,BaseSearchObject>
    {
        void DetachEntity(MovieActors entity);

    }
}
