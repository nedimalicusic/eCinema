using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class ShowController : BaseCrudController<ShowDto, ShowUpsertDto, ShowSearchObject, IShowsService>
    {
        public ShowController(IShowsService service, ILogger<ShowController> logger) : base(service, logger)
        {
        }

        [HttpGet("GetByMovieId")]
        public async Task<IActionResult> GetByMovieId(int movieId, CancellationToken cancellationToken = default)
        {
            try
            {
                var shows = await Service.GetByMovieId(movieId, cancellationToken);
                return Ok(shows);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get shows!");
                return BadRequest();
            }
        }

        [HttpGet("GetByGenreId")]
        public async Task<IActionResult> GetByGenreId(int? genreId,int cinemaId, CancellationToken cancellationToken = default)
        {
            try
            {
                var shows = await Service.GetShowByGenreId(genreId, cinemaId, cancellationToken);
                return Ok(shows);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get shows!");
                return BadRequest();
            }
        }

        [HttpGet("GetLastAddShows")]
        public async Task<IActionResult> GetLastAddShows(int size,int cinemaId, CancellationToken cancellationToken = default)
        {
            try
            {
                var shows = await Service.GetLastAddShows(size,cinemaId, cancellationToken);
                return Ok(shows);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get shows!");
                return BadRequest();
            }
        }

        [HttpGet("GetMostWatchedShows")]
        public async Task<IActionResult> GetMostWatchedShows(int size, int cinemaId, CancellationToken cancellationToken = default)
        {
            try
            {
                var shows = await Service.GetMostWatchedShows(size, cinemaId, cancellationToken);
                return Ok(shows);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get shows!");
                return BadRequest();
            }
        }

    }
}
