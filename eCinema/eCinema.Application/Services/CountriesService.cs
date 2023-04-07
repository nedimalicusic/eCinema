using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class CountriesService : BaseService<Country, CountryDto, CountryUpsertDto, BaseSearchObject, ICountiresRepository>, ICountriesService
    {
        public CountriesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CountryUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
