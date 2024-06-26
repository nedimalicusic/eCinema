﻿using eCinema.Core;
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
            return await DbSet.Include(d=>d.Movie).ThenInclude (s=>s.Production).ThenInclude(s=>s.Country).Include(d => d.Movie)
                .ThenInclude(s=>s.Language).Include(d => d.Movie).ThenInclude(s => s.Photo).Include(s=>s.Cinema)
                .ThenInclude(d=>d.City).ThenInclude(s=>s.Country).Include(s => s.Reservations).Where(s => s.MovieId == movieId).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetLastAddShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s=>s.Movie).ThenInclude(d => d.Production).ThenInclude(s => s.Country)
                .Include(s=>s.Cinema).ThenInclude(s => s.City).Where(d => d.CinemaId == cinemaId).Include(s=>s.Movie.Language).Include(s=>s.Movie.Photo).Include(s=>s.Movie.Production).ThenInclude(s=>s.Country)
                .OrderByDescending(s => s.CreatedAt).Take(size).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetMostWatchedShows(int size,int cinemaId, CancellationToken cancellationToken)
        {
            return await DbSet.Include(s => s.Movie).ThenInclude(d=>d.Production).ThenInclude(s=>s.Country).Include(s => s.Cinema)
                .ThenInclude(s=>s.City).Where(d=>d.CinemaId==cinemaId).Include(s => s.Movie.Language).Include(s => s.Movie.Photo)
                .Include(s => s.Movie.Production).ThenInclude(s => s.Country)
                .OrderByDescending(s => s.Movie.NumberOfViews).Take(size).ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<Show>> GetShowByGenreId(int? genreId,int cinemaId, CancellationToken cancellationToken)
        {
            if (genreId != null)
            {
                var shows = await DbSet.Include(s => s.Movie).ThenInclude(d => d.Production).ThenInclude(s => s.Country).Include(s => s.Cinema)
                .ThenInclude(s => s.City).Where(d => d.CinemaId == cinemaId).Include(s => s.Movie.Language).Include(s => s.Movie.Photo)
                .Include(s => s.Movie.Production).ThenInclude(s => s.Country)
                          .Where(show => show.Movie.MovieGenres.Any(mg => mg.GenreId == genreId) && show.CinemaId == cinemaId)
                          .ToListAsync();
                return shows;
            }
            else
            {
                var shows = await DbSet.Include(s => s.Movie).ThenInclude(d => d.Production).ThenInclude(s => s.Country).Include(s => s.Cinema)
                .ThenInclude(s => s.City).Where(d => d.CinemaId == cinemaId).Include(s => s.Movie.Language).Include(s => s.Movie.Photo)
                .Include(s => s.Movie.Production).ThenInclude(s => s.Country)
                    .Where(show => show.CinemaId == cinemaId)
                    .ToListAsync();
                return shows;
            }
        }

        public override async Task<PagedList<Show>> GetPagedAsync(ShowSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(u =>
                    (searchObject.Name == null || u.Movie.Title.ToLower().Contains(searchObject.Name.ToLower())) &&
                    (searchObject.CinemaId == null || u.CinemaId == searchObject.CinemaId) &&
                    (searchObject.MovieId == null || u.MovieId == searchObject.MovieId) &&
                    (searchObject.Date == null || u.StartsAt.Date == searchObject.Date.Value.Date)
                ).Include(s => s.Movie.Production.Country)
                 .Include(s=>s.Movie.Language)
                 .Include(s=>s.Movie.MovieGenres).ThenInclude(s=>s.Genre)
                 .Include(s=>s.Movie.MovieCategories).ThenInclude(s=>s.Category)
                 .Include(s=>s.Movie.MovieActors).ThenInclude(s=>s.Actors)
                 .Include(s=>s.ShowType).Include(s=>s.ReccuringShow)
                .Include(s=>s.Movie.Photo)
                .Include(s => s.Cinema.City.Country)
                 .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
