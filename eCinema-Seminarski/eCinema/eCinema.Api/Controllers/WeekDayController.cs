using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class WeekDayController : BaseCrudController<WeekDayDto, WeekDayUpsertDto, BaseSearchObject, IWeekDayService>
    {
        public WeekDayController(IWeekDayService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
