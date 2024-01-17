using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class MovieActorsService : BaseService<MovieActors, MovieActorsDto, MovieActorsUpsertDto, BaseSearchObject, IMovieActorsRepository>, IMovieActorsService
    {
        public MovieActorsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieActorsUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
