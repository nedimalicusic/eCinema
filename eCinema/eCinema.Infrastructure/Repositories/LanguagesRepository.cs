using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Infrastructure
{
    public class LanguagesRepository : BaseRepository<Language, int, BaseSearchObject>,ILanguagesRepository
    {
        public LanguagesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
