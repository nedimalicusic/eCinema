using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface ILanguagesService : IBaseService<int,LanguageDto,LanguageUpsertDto, LanguageSearchObject>
    {
    }
}
