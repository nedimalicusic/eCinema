using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;

namespace eCinema.Infrastructure.Repositories
{
    public class ShowTypeRepository : BaseRepository<ShowType, int, BaseSearchObject>, IShowTypeRepository
    {
        public ShowTypeRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
