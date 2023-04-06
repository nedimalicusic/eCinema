using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class NotificationsRepository : BaseRepository<Notification, int, BaseSearchObject>, INotificationsRepository
    {
        public NotificationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
