using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class CategoryRepository : BaseRepository<Category, int, CategorySearchObject>, ICategoryRepository
    {
        public CategoryRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Category>> GetPagedAsync(CategorySearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var query = DbSet.AsQueryable();

            if (searchObject.IncludeMoviesWithData == true)
            {
                query = query.AsSingleQuery()
                    .Include(c => c.MovieCategories)
                    .ThenInclude(mc => mc.Movie)
                    .ThenInclude(m => m.MovieGenres)
                    .ThenInclude(mg => mg.Genre)
                    .Include(c => c.MovieCategories)
                    .ThenInclude(mc => mc.Movie)
                    .ThenInclude(m => m.MovieActors)
                    .ThenInclude(ma => ma.Actors)
                    .Include(c => c.MovieCategories)
                    .ThenInclude(mc => mc.Movie.Production.Country)
                    .Include(c => c.MovieCategories)
                    .ThenInclude(mc => mc.Movie.Language)
                    .Include(c => c.MovieCategories)
                    .ThenInclude(mc => mc.Movie.Photo)
                    .AsNoTracking();
            }

            if (searchObject.IsDisplayed.HasValue)
            {
                query = query.Where(c => c.IsDisplayed == searchObject.IsDisplayed.Value);
            }


            var result = await query.ToPagedListAsync(searchObject, cancellationToken);

            return result;
        }


    }
}
