using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class CinemaController : BaseCrudController<CinemaDto, CinemaUpsertDto, CinemaSearchObject, ICinemasService>
    {
        public CinemaController(ICinemasService service, ILogger<CinemaController> logger) : base(service, logger)
        {
        }

        [HttpGet("GetDashboardInformation")]
        public async Task<IActionResult> GetDashboardInformation(int cinemaId, CancellationToken cancellationToken = default)
        {
            try
            {

                var information = await Service.GetDashboardInformation(cinemaId, cancellationToken);
                return Ok(information);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get Dashboard information");
                return BadRequest();
            }
        }
    }
}
