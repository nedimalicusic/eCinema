using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IMoviesRepository : IBaseRepository<Movie,int, MovieSearchObject>
    {
        Task<IEnumerable<Movie>> GetMostWatchedMovies(int size, CancellationToken cancellationToken);
        Task<IEnumerable<Movie>> GetLastAddMovies(int size, CancellationToken cancellationToken);
    }
}
