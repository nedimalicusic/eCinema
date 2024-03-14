using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface IReservationsService : IBaseService<int,ReservationDto,ReservationUpsertDto, ReservationSearchObjet>
    {
        Task<IEnumerable<ReservationDto>> GetByUserId(int userId, CancellationToken cancellationToken);
        Task<List<int>> GetCountByMonthAsync(BarChartSearchObject searchObject, CancellationToken cancellationToken = default);

        Task<IEnumerable<ReservationDto>> GetByShowId(int showId, CancellationToken cancellationToken);
    }
}
