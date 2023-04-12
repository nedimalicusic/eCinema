using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class ProductionController : BaseCrudController<ProductionDto, ProductionUpsertDto, BaseSearchObject, IProductionsService>
    {
        public ProductionController(IProductionsService service, ILogger<ProductionController> logger) : base(service, logger)
        {
        }
    }
}
