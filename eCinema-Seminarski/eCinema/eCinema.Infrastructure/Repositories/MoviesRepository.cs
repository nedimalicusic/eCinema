﻿using eCinema.Core;
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

        public async Task<IEnumerable<Movie>> GetMoviesByCategoryId(int categoryId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s => s.Language).Include(d => d.Production.Country).Include(s => s.Photo)
                 .Include(s => s.MovieGenres).ThenInclude(s => s.Genre)
                 .Include(s => s.MovieCategories).ThenInclude(s => s.Category)
                 .Include(s => s.MovieActors).ThenInclude(s => s.Actors)
                 .Where(s => s.MovieCategories.Any(d => d.CategoryId == categoryId)).AsNoTracking().
                 ToListAsync(cancellationToken);
        }

        public override async Task<PagedList<Movie>> GetPagedAsync(MovieSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var query = DbSet.Include(s => s.Language).Include(d => d.Production).ThenInclude(s => s.Country).Include(s => s.Photo)
                .Include(s => s.MovieGenres).ThenInclude(s => s.Genre)
                .Include(s => s.MovieCategories).ThenInclude(s => s.Category)
                .Include(s => s.MovieActors).ThenInclude(s => s.Actors).AsNoTracking()
                
                .AsQueryable();

            if (searchObject.Name != null)
            {
                query = query.Where(s => searchObject.Name == null || s.Title.ToLower().Contains(searchObject.Name.ToLower()));
            }
            if (searchObject.GenreId != null)
            {
                query = query.Where(s => s.MovieGenres.Any(d => d.GenreId == searchObject.GenreId));
            }
            if (searchObject.CategoryId != null)
            {
                query = query.Where(s => s.MovieCategories.Any(d => d.CategoryId == searchObject.CategoryId));
            }

           

            var result = await query.ToPagedListAsync(searchObject, cancellationToken);

            return result;
        }
    }
}
