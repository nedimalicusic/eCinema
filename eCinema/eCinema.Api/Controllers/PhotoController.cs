using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class PhotoController : BaseCrudController<PhotoDto, PhotoUpsertDto, BaseSearchObject, IPhotosService>
    {
        public PhotoController(IPhotosService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
