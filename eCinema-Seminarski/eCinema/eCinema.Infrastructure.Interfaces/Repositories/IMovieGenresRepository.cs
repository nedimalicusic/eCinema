using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMovieGenresRepository : IBaseRepository<MovieGenre,int,BaseSearchObject>
    {
        void DetachEntity(MovieGenre entity);
    }
}
