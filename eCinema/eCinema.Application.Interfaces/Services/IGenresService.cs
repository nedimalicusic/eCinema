using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IGenresService : IBaseService<int,GenreDto,GenreUpsertDto,BaseSearchObject>
    {
    }
}
