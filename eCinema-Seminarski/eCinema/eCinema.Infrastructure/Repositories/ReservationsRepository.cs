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
            return await DbSet
                .Where(r => r.UserId == userId)
                .AsNoTracking()
                .AsSplitQuery()
                .Include(r => r.User)
                .Include(r => r.Seat)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Movie)
                        .ThenInclude(m => m.Production)
                            .ThenInclude(p => p.Country)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Movie)
                        .ThenInclude(m => m.Language)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Movie)
                        .ThenInclude(m => m.Photo)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Movie)
                        .ThenInclude(m => m.MovieReactions) 
                .Include(r => r.Show)
                    .ThenInclude(s => s.Cinema)
                        .ThenInclude(c => c.City)
                            .ThenInclude(city => city.Country)
                .Include(r => r.Show)
                    .ThenInclude(s => s.ShowType)
                .ToListAsync(cancellationToken);
        }


        public int getCountOfReservation(int? cinemaId, CancellationToken cancellationToken)
        {
            return DbSet.Where(s => cinemaId==null || s.Show.CinemaId == cinemaId).AsNoTracking().Count();
        }

        public override async Task<PagedList<Reservation>> GetPagedAsync(ReservationSearchObjet searchObject, CancellationToken cancellationToken = default)
        {
            var query = DbSet
                .AsNoTracking()
                .Where(u =>
                    (searchObject.name == null || u.Show.Movie.Title.Contains(searchObject.name)) &&
                    (searchObject.cinemaId == null || u.Show.CinemaId == searchObject.cinemaId) &&
                    (searchObject.showId == null || u.ShowId == searchObject.showId))
                .Include(r => r.User)
                .Include(r => r.Seat)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Cinema)
                        .ThenInclude(c => c.City)
                            .ThenInclude(city => city.Country)
                .Include(r => r.Show)
                    .ThenInclude(s => s.Movie)
                        .ThenInclude(m => m.Production)
                            .ThenInclude(s=>s.Country)
                .Include(r => r.Show.Movie.Language)
                 .Include(r => r.Show)
                    .ThenInclude(s => s.ShowType)
                .Include(r => r.Show.Movie.Photo)
                .Include(r => r.Show.Movie.MovieGenres)
                    .ThenInclude(mg => mg.Genre)
                .Include(r => r.Show.Movie.MovieCategories)
                    .ThenInclude(mc => mc.Category)
                .Include(r => r.Show.Movie.MovieActors)
                    .ThenInclude(ma => ma.Actors)
                .AsSplitQuery()                       
                .OrderByDescending(r => r.Id);        

            return await query.ToPagedListAsync(searchObject, cancellationToken);
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
            return await DbSet.Include(s=>s.Seat)
                    .Include(s=>s.Show.Movie.Production.Country)
                    .Include(s => s.Show.Movie.Photo)
                    .Include(s => s.Show.ShowType)
                    .Include(s => s.User.ProfilePhoto)
                   .Include(s => s.Show.Movie.Language)
                   .Include(s => s.Show.Cinema.City.Country)
                .Where(s=>s.ShowId==showId).ToListAsync(cancellationToken);
        }
    }
}
