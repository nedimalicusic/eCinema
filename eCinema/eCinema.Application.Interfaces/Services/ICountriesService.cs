using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface ICountriesService : IBaseService<int,CountryDto,CountryUpsertDto,BaseSearchObject>
    {
    }
}
