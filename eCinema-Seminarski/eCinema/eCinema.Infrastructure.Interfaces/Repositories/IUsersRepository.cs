using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IUsersRepository : IBaseRepository<User,int, UserSearchObject>
    {
        Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
       int getCountOfUsers(CancellationToken cancellationToken = default);
       int getCountOfUsersActive(int  cinemaId, CancellationToken cancellationToken = default);
       int getCountOfUsersInactive(int  cinemaId, CancellationToken cancellationToken = default);
    }
}
