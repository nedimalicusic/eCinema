using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ShowSeatController : BaseCrudController<ShowSeatDto, ShowSeatUpsertDto, BaseSearchObject, IShowSeatsService>
    {
        public ShowSeatController(IShowSeatsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
