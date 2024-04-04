using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Common.Service;
using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

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

            InsertRelatedEntities(dto, entity.Id);

            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<MovieDto>(entity);
        }

        private void InsertRelatedEntities(MovieUpsertDto dto, int id)
        {
            InsertRelatedCategories(dto, id);
            InsertRelatedGenres(dto, id);
            InsertRelatedActors(dto, id);
        }

        private async void InsertRelatedActors(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.ActorIds)
            {
                var movieActors = new MovieActors
                {
                    MovieId = id,
                    ActorId = item
                };
                await UnitOfWork.MovieActorsRepository.AddAsync(movieActors);
            }
        }

        private async void InsertRelatedGenres(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.GenreIds)
            {
                var movieGenre = new MovieGenre
                {
                    MovieId = id,
                    GenreId = item
                };
                await UnitOfWork.MovieGenresRepository.AddAsync(movieGenre);
            }
        }

        private async void InsertRelatedCategories(MovieUpsertDto dto, int id)
        {
            foreach (var item in dto.CategoryIds)
            {
                var movieCategory = new MovieCategory
                {
                    MovieId = id,
                    CategoryId = item
                };
                await UnitOfWork.MovieCategoryRepository.AddAsync(movieCategory);
            }
        }

        public override async Task<MovieDto> UpdateAsync(MovieUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var movie = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);
            if (movie == null)
                throw new UserNotFoundException();

            Mapper.Map(dto, movie);


            CurrentRepository.Update(movie);
            await UnitOfWork.SaveChangesAsync(cancellationToken);

            if (!movie!.MovieCategories.Select(x => x.CategoryId).SequenceEqual(dto.CategoryIds))
            {
                foreach (var item in movie.MovieCategories)
                {
                    UnitOfWork.MovieCategoryRepository.Remove(item);
                }
                
                InsertRelatedCategories(dto, movie.Id);
            }
            if (!movie.MovieActors.Select(x => x.ActorId).SequenceEqual(dto.ActorIds))
            {
                foreach (var item in movie.MovieActors)
                {
                    UnitOfWork.MovieActorsRepository.Remove(item);
                }

                InsertRelatedActors(dto, movie.Id);
            }
            if (!movie.MovieGenres.Select(mc => mc.GenreId).SequenceEqual(dto.GenreIds))
            {
                foreach (var item in movie.MovieGenres)
                {
                    UnitOfWork.MovieGenresRepository.Remove(item);
                }

                InsertRelatedGenres(dto, movie.Id);
            }

            return Mapper.Map<MovieDto>(movie);
        }
    }
}
