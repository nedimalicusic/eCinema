using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface INotificationsService : IBaseService<int,NotificationDto,NotificationUpsertDto,BaseSearchObject>
    {
    }
}
