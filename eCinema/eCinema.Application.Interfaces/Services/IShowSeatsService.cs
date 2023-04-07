using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IShowSeatsService : IBaseService<int,ShowSeatDto,ShowSeatUpsertDto,BaseSearchObject>
    {
    }
}
