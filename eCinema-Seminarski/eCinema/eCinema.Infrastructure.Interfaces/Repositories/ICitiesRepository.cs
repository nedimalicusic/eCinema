using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ICitiesRepository : IBaseRepository<City,int, CitiesSearchObject>
    {
    }
}
