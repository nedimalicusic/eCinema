using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IPhotosService : IBaseService<int,PhotoDto,PhotoUpsertDto,BaseSearchObject>
    {
    }
}
