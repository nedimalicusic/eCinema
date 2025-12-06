using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class MovieActorsController : BaseCrudController<MovieActorsDto, MovieActorsUpsertDto, BaseSearchObject, IMovieActorsService>
    {
        public MovieActorsController(IMovieActorsService service, ILogger<MovieActorsController> logger) : base(service, logger)
        {
        }
    }
}
