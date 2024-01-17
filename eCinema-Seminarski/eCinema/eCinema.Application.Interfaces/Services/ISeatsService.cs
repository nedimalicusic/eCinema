using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface ISeatsService : IBaseService<int,SeatDto,SeatUpsertDto,BaseSearchObject>
    {
        Task<IEnumerable<SeatDto>> GetAllSeatsByCinemaId(int cinemaId, CancellationToken cancellationToken);

    }
}
