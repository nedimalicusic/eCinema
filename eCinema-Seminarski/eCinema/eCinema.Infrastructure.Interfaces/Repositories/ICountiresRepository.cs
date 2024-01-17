using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ICountiresRepository : IBaseRepository<Country,int, CountriesSearchObject>
    {
    }
}
