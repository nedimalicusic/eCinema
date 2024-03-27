using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class CategoryController : BaseCrudController<CategoryDto, CategoryUpsertDto, BaseSearchObject, ICategoryService>
    {
        public CategoryController(ICategoryService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
