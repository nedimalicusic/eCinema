using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IMovieActorsService : IBaseService<int,MovieActorsDto,MovieActorsUpsertDto,BaseSearchObject>
    {
    }
}
