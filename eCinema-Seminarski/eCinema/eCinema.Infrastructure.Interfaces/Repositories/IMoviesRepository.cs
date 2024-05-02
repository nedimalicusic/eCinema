using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMoviesRepository : IBaseRepository<Movie,int, MovieSearchObject>
    {
        Task<IEnumerable<Movie>> GetMoviesByCategoryId(int categoryId, CancellationToken cancellationToken);
    }
}
