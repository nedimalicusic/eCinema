using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IProductionsService : IBaseService<int,ProductionDto,ProductionUpsertDto,BaseSearchObject>
    {
    }
}
