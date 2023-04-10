using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class NotificationController : BaseCrudController<NotificationDto, NotificationUpsertDto, BaseSearchObject, INotificationsService>
    {
        public NotificationController(INotificationsService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
