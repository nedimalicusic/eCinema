using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IReservationsService : IBaseService<int,ReservationDto,ReservationUpsertDto,BaseSearchObject>
    {
    }
}
