using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class NotificationController : BaseCrudController<NotificationDto, NotificationUpsertDto, BaseSearchObject, INotificationsService>
    {
        public NotificationController(INotificationsService service, ILogger<NotificationController> logger) : base(service, logger)
        {
        }

        [HttpGet("GetByUserId")]
        public async Task<IActionResult> GetByUserId(int userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var notifications = await Service.GetByUserId(userId, cancellationToken);
                return Ok(notifications);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get notifications!");
                return BadRequest();
            }
        }
    }
}
