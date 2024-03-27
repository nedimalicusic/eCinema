using AutoMapper;
using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using FluentValidation;

namespace eCinema.Application.Services
{
    public class ReccuringShowService : BaseService<ReccuringShows, ReccuringShowDto, ReccuringShowUpsertDto, BaseSearchObject, IReccuringShowRepository>, IReccuringShowService
    {
        public ReccuringShowService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ReccuringShowUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
