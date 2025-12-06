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
        public override Task<Movie?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return DbSet.Include(s => s.MovieGenres).ThenInclude(s => s.Genre)
                .Include(s => s.MovieActors).ThenInclude(s => s.Actors)
                .Include(s => s.MovieCategories).ThenInclude(s => s.Category).Where(s => s.Id == id).AsNoTracking().FirstOrDefaultAsync(cancellationToken);
        }

        public async Task<IEnumerable<Movie>> GetByIds(List<int> ids, CancellationToken cancellationToken)
        {
            if (ids == null || ids.Count == 0)
                return new List<Movie>();

            return await DbSet
                .AsNoTracking()
                .Include(m => m.Language)
                .Include(m => m.Production)
                    .ThenInclude(p => p.Country)
                .Include(m => m.Photo)
                .Include(m => m.MovieGenres)
                    .ThenInclude(mg => mg.Genre)
                .Include(m => m.MovieCategories)
                    .ThenInclude(mc => mc.Category)
                .Include(m => m.MovieActors)
                    .ThenInclude(ma => ma.Actors)
                .Where(m => ids.Contains(m.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Movie>> GetMostWatched(CancellationToken cancellationToken)
        {
            return await DbSet
                .AsNoTracking()
                .Include(m => m.Language)
                .Include(m => m.Production)
                    .ThenInclude(p => p.Country)
                .Include(m => m.Photo)
                .Include(m => m.MovieGenres)
                    .ThenInclude(mg => mg.Genre)
                .Include(m => m.MovieCategories)
                    .ThenInclude(mc => mc.Category)
                .Include(m => m.MovieActors)
                    .ThenInclude(ma => ma.Actors)
                .OrderByDescending(m => m.NumberOfViews)
                .Take(3) 
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Movie>> GetMoviesByCategoryId(int categoryId, CancellationToken cancellationToken)
        {
            return await DbSet
                .AsNoTracking() 
                .Include(m => m.Language)
                .Include(m => m.Production)
                    .ThenInclude(p => p.Country)
                .Include(m => m.Photo)
                .Include(m => m.MovieGenres)
                    .ThenInclude(mg => mg.Genre)
                .Include(m => m.MovieCategories)
                    .ThenInclude(mc => mc.Category)
                .Include(m => m.MovieActors)
                    .ThenInclude(ma => ma.Actors)
                .Where(m => m.MovieCategories.Any(mc => mc.CategoryId == categoryId))
                .ToListAsync(cancellationToken);
        }

        public override async Task<PagedList<Movie>> GetPagedAsync(MovieSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var query = DbSet
                .AsNoTracking()
                .AsSplitQuery() 
                .Include(m => m.Language)
                .Include(m => m.Production).ThenInclude(p => p.Country)
                .Include(m => m.Photo)
                .Include(m => m.MovieGenres).ThenInclude(mg => mg.Genre)
                .Include(m => m.MovieCategories).ThenInclude(mc => mc.Category)
                .Include(m => m.MovieActors).ThenInclude(ma => ma.Actors)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchObject.Name))
            {
                var name = searchObject.Name.ToLower();
                query = query.Where(s => s.Title.ToLower().Contains(name));
            }

            if (searchObject.GenreId.HasValue)
            {
                query = query.Where(s => s.MovieGenres.Any(d => d.GenreId == searchObject.GenreId.Value));
            }

            if (searchObject.CategoryId.HasValue)
            {
                query = query.Where(s => s.MovieCategories.Any(d => d.CategoryId == searchObject.CategoryId.Value));
            }

            query = query.OrderBy(s => s.Id);

            var result = await query.ToPagedListAsync(searchObject, cancellationToken);
            return result;
        }

    }
}
