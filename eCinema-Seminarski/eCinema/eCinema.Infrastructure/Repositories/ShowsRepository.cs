using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class ShowsRepository : BaseRepository<Show, int, ShowSearchObject>, IShowsRepository
    {
        public ShowsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<IEnumerable<Show>> GetbyMovieId(int movieId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(d=>d.Movie).Include(s=>s.Cinema).ThenInclude(d=>d.City).Where(s => s.MovieId == movieId).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetLastAddShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s=>s.Movie).ThenInclude(d => d.Production).ThenInclude(s => s.Country).Include(s=>s.Cinema).ThenInclude(s => s.City).Where(d => d.CinemaId == cinemaId).OrderByDescending(s => s.CreatedAt).Take(size).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetMostWatchedShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s => s.Movie).ThenInclude(d=>d.Production).ThenInclude(s=>s.Country).Include(s => s.Cinema).ThenInclude(s=>s.City).Where(d=>d.CinemaId==cinemaId).OrderByDescending(s => s.Movie.NumberOfViews).Take(size).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetShowByGenreId(int? genreId,int cinemaId, CancellationToken cancellationToken)
        {
            if (genreId != null)
            {
                var shows = await DbSet.Include(s => s.Movie).ThenInclude(d => d.MovieGenres).ThenInclude(d => d.Genre).Include(s => s.Movie).ThenInclude(s => s.Production).ThenInclude(s=>s.Country).Include(s => s.Cinema).ThenInclude(s => s.City)
                          .Where(show => show.Movie.MovieGenres.Any(mg => mg.GenreId == genreId) && show.CinemaId == cinemaId)
                          .ToListAsync();
                return shows;
            }
            else
            {
                var shows = await DbSet.Include(s => s.Movie).ThenInclude(d => d.MovieGenres).ThenInclude(d => d.Genre).Include(s => s.Movie).ThenInclude(s => s.Production).ThenInclude(s => s.Country).Include(s => s.Cinema).ThenInclude(s => s.City)
                    .Where(show => show.CinemaId == cinemaId)
                    .ToListAsync();
                return shows;
            }
        }

        public override async Task<PagedList<Show>> GetPagedAsync(ShowSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Include(s => s.Movie)
                    .ThenInclude(s => s.Production)
                        .ThenInclude(s => s.Country)
                .Include(s => s.Movie)
                    .ThenInclude(s => s.Language)
                .Include(s => s.Cinema)
                    .ThenInclude(s => s.City)
                        .ThenInclude(s => s.Country)
                .Where(u =>
                    (searchObject.name == null || u.Movie.Title.ToLower().Contains(searchObject.name.ToLower())) &&
                    (searchObject.cinemaId == null || u.CinemaId == searchObject.cinemaId)
                )
                 .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
