using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class MoviesRepository : BaseRepository<Movie, int, MovieSearchObject>, IMoviesRepository
    {
        public MoviesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Movie>> GetPagedAsync(MovieSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var query = DbSet.Include(s => s.MovieGenres).ThenInclude(s => s.Genre).Include(d => d.Production).ThenInclude(s=>s.Country).Include(s => s.Photo).AsQueryable();

            if (searchObject.GenreId != null)
            {
                query = query.Include(s=>s.MovieGenres).ThenInclude(s=>s.Genre).Include(d=>d.Production).Include(s => s.Photo).Where(s => s.MovieGenres.Any(d => d.GenreId == searchObject.GenreId));
            }
            else
            {
                query = query.Include(s => s.MovieGenres).ThenInclude(s => s.Genre).
                    Include(d => d.Production).Include(s => s.Photo).Where(s => searchObject.name==null || s.Title.ToLower().Contains(searchObject.name.ToLower()));
            }

            var result = await query.ToPagedListAsync(searchObject, cancellationToken);

            return result;
        }
        public async Task<IEnumerable<Movie>> GetLastAddMovies(int size, CancellationToken cancellationToken)
        {
            return await DbSet.OrderByDescending(s => s.CreatedAt).Take(size).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Movie>> GetMostWatchedMovies(int size, CancellationToken cancellationToken)
        {
            return await DbSet.OrderByDescending(s=>s.NumberOfViews).Take(size).ToListAsync(cancellationToken);
        }
    }
}
