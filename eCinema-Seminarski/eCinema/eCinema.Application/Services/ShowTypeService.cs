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
    public class ShowTypeService : BaseService<ShowType, ShowTypeDto, ShowTypeUpsertDto, BaseSearchObject, IShowTypeRepository>, IShowTypeService
    {
        public ShowTypeService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ShowTypeUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
