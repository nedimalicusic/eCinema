using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces.Services
{
    public interface IWeekDayService : IBaseService<int,WeekDayDto,WeekDayUpsertDto,BaseSearchObject>
    {
    }
}
