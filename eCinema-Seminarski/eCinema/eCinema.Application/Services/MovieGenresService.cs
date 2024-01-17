using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class MovieGenresService : BaseService<MovieGenre, MovieGenreDto, MovieGenreUpsertDto, BaseSearchObject, IMovieGenresRepository>, IMovieGenresService
    {
        public MovieGenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieGenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
