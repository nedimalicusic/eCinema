using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class ActorsService : BaseService<Actors, ActorsDto, ActorsUpsertDto, ActorSearchObject, IActorsRepository>, IActorsService
    {
        public ActorsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ActorsUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
