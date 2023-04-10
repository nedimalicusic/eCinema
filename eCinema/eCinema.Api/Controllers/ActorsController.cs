using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ActorsController : BaseCrudController<ActorsDto, ActorsUpsertDto, BaseSearchObject, IActorsService>
    {
        public ActorsController(IActorsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
