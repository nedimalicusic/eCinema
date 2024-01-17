using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class ProductionController : BaseCrudController<ProductionDto, ProductionUpsertDto, ProductionSearchObject, IProductionsService>
    {
        public ProductionController(IProductionsService service, ILogger<ProductionController> logger) : base(service, logger)
        {
        }
    }
}
