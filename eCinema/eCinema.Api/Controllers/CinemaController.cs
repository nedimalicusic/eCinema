using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class CinemaController : BaseCrudController<CinemaDto, CinemaUpsertDto, BaseSearchObject, ICinemasService>
    {
        public CinemaController(ICinemasService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
