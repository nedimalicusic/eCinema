using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class LanguageController : BaseCrudController<LanguageDto, LanguageUpsertDto, BaseSearchObject, ILanguagesService>
    {
        public LanguageController(ILanguagesService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
