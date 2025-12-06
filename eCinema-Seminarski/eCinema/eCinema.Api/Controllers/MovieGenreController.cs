using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class MovieGenreController : BaseCrudController<MovieGenreDto, MovieGenreUpsertDto, BaseSearchObject, IMovieGenresService>
    {
        public MovieGenreController(IMovieGenresService service, ILogger<MovieGenreController> logger) : base(service, logger)
        {
        }
    }
}
