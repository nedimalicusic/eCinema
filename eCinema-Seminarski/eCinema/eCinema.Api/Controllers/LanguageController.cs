using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Api.Controllers
{
    public class LanguageController : BaseCrudController<LanguageDto, LanguageUpsertDto, LanguageSearchObject, ILanguagesService>
    {
        public LanguageController(ILanguagesService service, ILogger<LanguageController> logger) : base(service, logger)
        {
        }
    }
}
