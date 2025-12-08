using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class CinemaRepository : BaseRepository<Cinema, int, CinemaSearchObject>, ICinemasRepository
    {
        public CinemaRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Cinema>> GetPagedAsync(CinemaSearchObject searchObject,CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Include(s => s.City)
                .ThenInclude(s => s.Country)
                .Where(s =>
                    (searchObject.name == null ||
                     s.Name.ToLower().Contains(searchObject.name.ToLower()))
                    &&
                    (searchObject.cinemaId == null ||
                     s.Id == searchObject.cinemaId)
                )
                .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
