using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IShowsRepository : IBaseRepository<Show,int,ShowSearchObject>
    {
        Task<IEnumerable<Show>> GetbyMovieId(int movieId,CancellationToken cancellationToken);
        Task<IEnumerable<Show>> GetShowByGenreId(int? genreId,int cinemaId,CancellationToken cancellationToken);
        Task<IEnumerable<Show>> GetMostWatchedShows(int size,int cinemaId, CancellationToken cancellationToken);
        Task<IEnumerable<Show>> GetLastAddShows(int size,int cinemaId, CancellationToken cancellationToken);
        Task<IEnumerable<Show>> GetActiveShows(CancellationToken cancellationToken);

    }
}
