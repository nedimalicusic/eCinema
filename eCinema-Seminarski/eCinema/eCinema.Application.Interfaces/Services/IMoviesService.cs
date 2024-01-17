using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IMoviesService : IBaseService<int,MovieDto,MovieUpsertDto, MovieSearchObject>
    {
        Task<IEnumerable<MovieDto>> GetMostWatchedMovies(int size,CancellationToken cancellationToken);
        Task<IEnumerable<MovieDto>> GetLastAddMovies(int size,CancellationToken cancellationToken);
    }
}
