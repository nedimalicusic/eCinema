using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class SeatController : BaseCrudController<SeatDto, SeatUpsertDto, BaseSearchObject, ISeatsService>
    {
        public SeatController(ISeatsService service, ILogger<SeatController> logger) : base(service, logger)
        {
        }

        [HttpGet("GetAllSeatsByCinemaId")]
        public async Task<IActionResult> GetAllSeatsByCinemaId(int cinemaId, CancellationToken cancellationToken = default)
        {
            try
            {
                var cinemas = await Service.GetAllSeatsByCinemaId(cinemaId, cancellationToken);
                return Ok(cinemas);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get cinemas!");
                return BadRequest();
            }
        }
    }
}
