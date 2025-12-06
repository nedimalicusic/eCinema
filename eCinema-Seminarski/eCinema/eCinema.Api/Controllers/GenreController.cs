using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class GenreController : BaseCrudController<GenreDto, GenreUpsertDto, GenreSearchObject, IGenresService>
    {
        public GenreController(IGenresService service, ILogger<GenreController> logger) : base(service, logger)
        {
        }
    }
}
