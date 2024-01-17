using eCinema.Core;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ISeatsRepository : IBaseRepository<Seat,int,BaseSearchObject>
    {
        Task<IEnumerable<Seat>> GetAllSeatsByCinemaId(int cinemaId,CancellationToken cancellationToken);
    }
}
