using eCinema.Core;

using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class MovieReactionController : BaseCrudController<MovieReactionDto, MovieReactionUpsertDto, BaseSearchObject, IMovieReactionsService>
    {
        public MovieReactionController(IMovieReactionsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
