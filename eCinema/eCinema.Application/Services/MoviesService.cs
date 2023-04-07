using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class MoviesService : BaseService<Movie, MovieDto, MovieUpsertDto, BaseSearchObject, IMoviesRepository>, IMoviesService
    {
        public MoviesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
