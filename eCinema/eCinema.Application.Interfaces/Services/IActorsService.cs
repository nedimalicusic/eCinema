using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IActorsService : IBaseService<int,ActorsDto,ActorsUpsertDto,BaseSearchObject>
    {
    }
}
