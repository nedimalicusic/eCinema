using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class CitiesService : BaseService<City, CityDto, CityUpsertDto, BaseSearchObject, ICitiesRepository>, ICitiesService
    {
        public CitiesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CityUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
