using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ILanguagesRepository : IBaseRepository<Language,int, LanguageSearchObject>
    {
    }
}
