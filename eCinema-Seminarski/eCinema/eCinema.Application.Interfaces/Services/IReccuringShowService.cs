using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces.Services
{
    public interface IReccuringShowService : IBaseService<int,ReccuringShowDto,ReccuringShowUpsertDto,BaseSearchObject>
    {
    }
}
