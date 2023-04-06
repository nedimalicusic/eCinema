using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class UsersRepository : BaseRepository<User, int, BaseSearchObject>, IUsersRepository
    {
        public UsersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
