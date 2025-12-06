using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface INotificationsService : IBaseService<int,NotificationDto,NotificationUpsertDto,BaseSearchObject>
    {
        Task<IEnumerable<NotificationDto>> GetByUserId(int userId, CancellationToken cancellationToken);
        Task MarkAsReed(int notificationId, CancellationToken cancellationToken);
    }
}
