using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface ICitiesService : IBaseService<int,CityDto,CityUpsertDto,BaseSearchObject>
    {
    }
}
