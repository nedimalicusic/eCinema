using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class CitiesController : BaseCrudController<CityDto, CityUpsertDto, BaseSearchObject, ICitiesService>
    {
        public CitiesController(ICitiesService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
