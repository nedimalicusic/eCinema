using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;

namespace eCinema.Infrastructure.Repositories
{
    public class WeekDayRepository : BaseRepository<WeekDay, int, BaseSearchObject>, IWeekDayRepository
    {
        public WeekDayRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
