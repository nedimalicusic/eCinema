using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface INotificationsRepository : IBaseRepository<Notification,int,BaseSearchObject>
    {
        Task<IEnumerable<Notification>> GetByUserId(int userId,CancellationToken cancellationToken);
    }
}
