using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class ActorsController : BaseCrudController<ActorsDto, ActorsUpsertDto, ActorSearchObject, IActorsService>
    {
        public ActorsController(IActorsService service, ILogger<ActorsController> logger) : base(service, logger)
        {
        }
    }
}
