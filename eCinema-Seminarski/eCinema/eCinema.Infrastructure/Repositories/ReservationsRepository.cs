using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking.Internal;

namespace eCinema.Infrastructure
{
    public class ReservationsRepository : BaseRepository<Reservation, int, ReservationSearchObjet>, IReservationsRepository
    {
        public ReservationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public async Task<IEnumerable<Reservation>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(d=>d.User).Include(d=>d.Show).ThenInclude(d=>d.Movie).ThenInclude(s=>s.Production).ThenInclude(s=>s.Country).Include(d=>d.Show).ThenInclude(d=>d.Cinema).ThenInclude(s=>s.City).Include(d=>d.Seat).AsNoTracking()
                .AsQueryable().Where(s => s.UserId == userId).ToListAsync(cancellationToken);
        }

        public int getCountOfReservation(int cinemaId, CancellationToken cancellationToken)
        {
            return DbSet.Where(s => s.Show.CinemaId == cinemaId).AsNoTracking().Count();
        }

        public override async Task<PagedList<Reservation>> GetPagedAsync(ReservationSearchObjet searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Include(s => s.Show.Cinema.City.Country)
                .Include(s => s.Show.Movie.Production.Country)
                .Include(s => s.User)
                .Include(s => s.Seat)
                .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
