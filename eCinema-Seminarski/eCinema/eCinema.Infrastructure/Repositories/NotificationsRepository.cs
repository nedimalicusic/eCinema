using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class NotificationsRepository : BaseRepository<Notification, int, BaseSearchObject>, INotificationsRepository
    {
        public NotificationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<IEnumerable<Notification>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            return await DbSet.Where(s => s.UserId == userId).ToListAsync(cancellationToken);
        }
    }
}
