using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure.Internal;

namespace eCinema.Infrastructure
{
    public class SeatsRepository : BaseRepository<Seat, int, BaseSearchObject>, ISeatsRepository
    {
        public SeatsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<IEnumerable<Seat>> GetAllSeatsByCinemaId(int cinemaId, CancellationToken cancellationToken)
        {
            return await DbSet.Take(cinemaId).ToListAsync(cancellationToken);
        }
    }
}
