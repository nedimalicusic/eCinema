using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ReccuringShowController : BaseCrudController<ReccuringShowDto, ReccuringShowUpsertDto, BaseSearchObject, IReccuringShowService>
    {
        public ReccuringShowController(IReccuringShowService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
