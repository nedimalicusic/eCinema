using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class LanguagesRepository : BaseRepository<Language, int, LanguageSearchObject>,ILanguagesRepository
    {
        public LanguagesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public override async Task<PagedList<Language>> GetPagedAsync(LanguageSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(s => searchObject.name == null || s.Name.ToLower().Contains(searchObject.name.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
