using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class CountriesController : BaseCrudController<CountryDto, CountryUpsertDto, CountriesSearchObject, ICountriesService>
    {
        public CountriesController(ICountriesService service, ILogger<CountriesController> logger) : base(service, logger)
        {
        }
    }
}
