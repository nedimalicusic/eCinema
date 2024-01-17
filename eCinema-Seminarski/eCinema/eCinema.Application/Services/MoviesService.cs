using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Common.Service;

namespace eCinema.Application
{
    public class MoviesService : BaseService<Movie, MovieDto, MovieUpsertDto, MovieSearchObject, IMoviesRepository>, IMoviesService
    {
        private readonly ICryptoService _cryptoService;

        public MoviesService(ICryptoService cryptoService, IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
            _cryptoService = cryptoService;
        }

        public async Task<IEnumerable<MovieDto>> GetLastAddMovies(int size, CancellationToken cancellationToken)
        {
            var movies=await CurrentRepository.GetLastAddMovies(size,cancellationToken);

            return Mapper.Map<IEnumerable<MovieDto>>(movies);
        }

        public async Task<IEnumerable<MovieDto>> GetMostWatchedMovies(int size, CancellationToken cancellationToken)
        {
            var movies = await CurrentRepository.GetMostWatchedMovies(size,cancellationToken);

            return Mapper.Map<IEnumerable<MovieDto>>(movies);
        }

        public override async Task<MovieDto> AddAsync(MovieUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Movie>(dto);

            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<MovieDto>(entity);
        }

        public override async Task<MovieDto> UpdateAsync(MovieUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var movie = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);
            if (movie == null)
                throw new UserNotFoundException();

            Mapper.Map(dto, movie);


            CurrentRepository.Update(movie);
            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<MovieDto>(movie);
        }

    }
}
