using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface IProductionsService : IBaseService<int,ProductionDto,ProductionUpsertDto, ProductionSearchObject>
    {
    }
}
