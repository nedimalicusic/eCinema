using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface ICitiesService : IBaseService<int,CityDto,CityUpsertDto, CitiesSearchObject>
    {
    }
}
