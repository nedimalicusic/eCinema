using eCinema.Core;
using eCinema.Application.Interfaces.Services;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class MovieCategoryController : BaseCrudController<MovieCategoryDto, MovieCategoryUpsertDto, BaseSearchObject, IMovieCategoryService>
    {
        public MovieCategoryController(IMovieCategoryService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
