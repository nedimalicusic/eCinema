using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class MovieController : BaseCrudController<MovieDto, MovieUpsertDto, BaseSearchObject, IMoviesService>
    {
        public MovieController(IMoviesService service, ILogger<MovieController> logger) : base(service, logger)
        {
        }
    }
}
