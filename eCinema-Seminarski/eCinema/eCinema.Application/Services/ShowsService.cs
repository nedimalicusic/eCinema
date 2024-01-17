using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class ShowsService : BaseService<Show, ShowDto, ShowUpsertDto, ShowSearchObject, IShowsRepository>, IShowsService
    {
        public ShowsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ShowUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task<IEnumerable<ShowDto>> GetByMovieId(int movieId, CancellationToken cancellationToken)
        {
            var shows = await CurrentRepository.GetbyMovieId(movieId, cancellationToken);

            return Mapper.Map<IEnumerable<ShowDto>>(shows);
        }

        public async Task<IEnumerable<ShowDto>> GetLastAddShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            var shows = await CurrentRepository.GetLastAddShows(size, cinemaId, cancellationToken);

            return Mapper.Map<IEnumerable<ShowDto>>(shows);
        }

        public async Task<IEnumerable<ShowDto>> GetMostWatchedShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            var shows = await CurrentRepository.GetMostWatchedShows(size, cinemaId, cancellationToken);

            return Mapper.Map<IEnumerable<ShowDto>>(shows);
        }

        public async Task<IEnumerable<ShowDto>> GetShowByGenreId(int? genreId,int cinemaId, CancellationToken cancellationToken)
        {
            var shows = await CurrentRepository.GetShowByGenreId(genreId, cinemaId, cancellationToken);

            return Mapper.Map<IEnumerable<ShowDto>>(shows);
        }
    }
}
