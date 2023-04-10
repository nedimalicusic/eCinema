using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ShowController : BaseCrudController<ShowDto, ShowUpsertDto, BaseSearchObject, IShowsService>
    {
        public ShowController(IShowsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
