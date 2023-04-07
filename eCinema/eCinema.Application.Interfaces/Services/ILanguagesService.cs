using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface ILanguagesService : IBaseService<int,LanguageDto,LanguageUpsertDto,BaseSearchObject>
    {
    }
}
