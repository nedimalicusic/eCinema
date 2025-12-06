using eCinema.Core;

using eCinema.Application.Interfaces.Services;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class CategoryController : BaseCrudController<CategoryDto, CategoryUpsertDto, CategorySearchObject, ICategoryService>
    {
        public CategoryController(ICategoryService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
