using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class SeatController : BaseCrudController<SeatDto, SeatUpsertDto, BaseSearchObject, ISeatsService>
    {
        public SeatController(ISeatsService service, ILogger<SeatController> logger) : base(service, logger)
        {
        }
    }
}
