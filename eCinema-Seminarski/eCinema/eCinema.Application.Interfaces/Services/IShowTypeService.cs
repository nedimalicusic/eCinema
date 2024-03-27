using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces.Services
{
    public interface IShowTypeService : IBaseService<int,ShowTypeDto,ShowTypeUpsertDto,BaseSearchObject>
    {
    }
}
