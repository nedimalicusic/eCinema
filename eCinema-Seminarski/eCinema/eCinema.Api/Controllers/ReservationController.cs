using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class ReservationController : BaseCrudController<ReservationDto, ReservationUpsertDto, ReservationSearchObjet, IReservationsService>
    {
        public ReservationController(IReservationsService service, ILogger<ReservationController> logger) : base(service, logger)
        {
        }

        [HttpGet("GetByUserId")]
        public async Task<IActionResult> GetByUserId(int userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var reservations = await Service.GetByUserId(userId, cancellationToken);
                return Ok(reservations);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get reservations!");
                return BadRequest();
            }
        }

    }
}
