using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface IShowsService : IBaseService<int,ShowDto,ShowUpsertDto, ShowSearchObject>
    {
        Task<IEnumerable<ShowDto>> GetByMovieId(int movieId,CancellationToken cancellationToken);
        Task<IEnumerable<ShowDto>> GetShowByGenreId(int? genreId,int cinemaId, CancellationToken cancellationToken);
        Task<IEnumerable<ShowDto>> GetMostWatchedShows(int size,int cinemaId, CancellationToken cancellationToken);
        Task<IEnumerable<ShowDto>> GetLastAddShows(int size,int cinemaId,CancellationToken cancellationToken);

    }
}
