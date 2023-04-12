using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class GenreController : BaseCrudController<GenreDto, GenreUpsertDto, BaseSearchObject, IGenresService>
    {
        public GenreController(IGenresService service, ILogger<GenreController> logger) : base(service, logger)
        {
        }
    }
}
