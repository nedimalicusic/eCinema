using AutoMapper;
using FluentValidation;

using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class MovieReactionsService : BaseService<MovieReaction, MovieReactionDto, MovieReactionUpsertDto, BaseSearchObject, IMovieReactionsRepository>, IMovieReactionsService
    {
        public MovieReactionsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieReactionUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
