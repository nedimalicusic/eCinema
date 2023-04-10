using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class CountriesController : BaseCrudController<CountryDto, CountryUpsertDto, BaseSearchObject, ICountriesService>
    {
        public CountriesController(ICountriesService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
