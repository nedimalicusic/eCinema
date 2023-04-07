using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IShowsService : IBaseService<int,ShowDto,ShowUpsertDto,BaseSearchObject>
    {
    }
}
