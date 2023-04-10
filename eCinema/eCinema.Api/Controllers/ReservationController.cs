using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ReservationController : BaseCrudController<ReservationDto, ReservationUpsertDto, BaseSearchObject, IReservationsService>
    {
        public ReservationController(IReservationsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
