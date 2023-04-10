using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IUsersRepository : IBaseRepository<User,int,BaseSearchObject>
    {
        Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
    }
}
