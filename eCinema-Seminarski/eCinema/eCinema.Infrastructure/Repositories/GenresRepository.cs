using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class GenresRepository : BaseRepository<Genre, int, GenreSearchObject>, IGenresRepository
    {
        public GenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Genre>> GetPagedAsync(GenreSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(s => searchObject.name == null || s.Name.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);

        }
    }
}
