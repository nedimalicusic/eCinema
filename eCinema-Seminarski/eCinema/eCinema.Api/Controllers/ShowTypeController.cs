using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ShowTypeController : BaseCrudController<ShowTypeDto, ShowTypeUpsertDto, BaseSearchObject, IShowTypeService>
    {
        public ShowTypeController(IShowTypeService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
