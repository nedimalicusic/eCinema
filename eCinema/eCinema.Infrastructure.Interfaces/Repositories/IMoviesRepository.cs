using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMoviesRepository : IBaseRepository<Movie,int,BaseSearchObject>
    {
    }
}
