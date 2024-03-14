using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{

    public class ReservationsRepository : BaseRepository<Reservation, int, ReservationSearchObjet>, IReservationsRepository
    {
        public ReservationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public async Task<IEnumerable<Reservation>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(d=>d.User).Include(d=>d.Show).ThenInclude(d=>d.Movie).ThenInclude(s=>s.Production)
                .ThenInclude(s=>s.Country).Include(s=>s.Show).ThenInclude(s=>s.Movie).ThenInclude(s=>s.Language).Include(s => s.Show).ThenInclude(s => s.Movie).ThenInclude(s => s.Photo)
                .Include(d=>d.Show).ThenInclude(d=>d.Cinema).ThenInclude(s=>s.City).ThenInclude(s=>s.Country).Include(d=>d.Seat).AsNoTracking()
                .AsQueryable().Where(s => s.UserId == userId).ToListAsync(cancellationToken);
        }

        public int getCountOfReservation(int? cinemaId, CancellationToken cancellationToken)
        {
            return DbSet.Where(s => cinemaId==null || s.Show.CinemaId == cinemaId).AsNoTracking().Count();
        }   

        public override async Task<PagedList<Reservation>> GetPagedAsync(ReservationSearchObjet searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                 .Where(u =>
                     (searchObject.name == null || u.Show.Movie.Title.Contains(searchObject.name)) &&
                     (searchObject.cinemaId == null || u.Show.CinemaId == searchObject.cinemaId))
                 .Include(s => s.Seat)
                 .Include(s => s.Show)
                     .ThenInclude(s => s.Cinema)
                         .ThenInclude(s => s.City)
                             .ThenInclude(s => s.Country)
                 .Include(s => s.User)
                 .Include(s => s.Show)
                     .ThenInclude(s => s.Movie)
                         .ThenInclude(s => s.Production)
                 .Include(s => s.Show)
                     .ThenInclude(s => s.Movie)
                         .ThenInclude(s => s.Photo)
                 .ToPagedListAsync(searchObject, cancellationToken);

        }

        public async Task<List<int>> GetCountByMonthAsync(BarChartSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var counts = await DbSet
               .Where(r => r.CreatedAt.Year == searchObject.year && (searchObject.cinemaId == null || searchObject.cinemaId==r.Show.CinemaId))
               .GroupBy(r => r.CreatedAt.Month)
               .Select(group => new
               {
                   Month = group.Key,
                   Count = group.Count()
               })
               .OrderBy(result => result.Month)
               .ToListAsync(cancellationToken);

            List<int> result = new List<int>();

            for (int month = 1; month <= 12; month++)
            {
                var count = counts.FirstOrDefault(c => c.Month == month)?.Count ?? 0;
                result.Add(count);
            }

            return result;
        }

        public async Task<IEnumerable<Reservation>> GetByShowId(int showId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s=>s.Seat).Include(s=>s.Show).ThenInclude(s=>s.Movie).ThenInclude(s=>s.Production).ThenInclude(s=>s.Country)
                .Include(s => s.Show).ThenInclude(s => s.Movie).ThenInclude(s => s.Photo)
                   .Include(s => s.Show).ThenInclude(s => s.Movie).ThenInclude(s => s.Language)
                   .Include(s => s.Show).ThenInclude(s=>s.Cinema).ThenInclude(s=>s.City).ThenInclude(s=>s.Country)
                .Where(s=>s.ShowId==showId).ToListAsync(cancellationToken);
        }
    }
}
