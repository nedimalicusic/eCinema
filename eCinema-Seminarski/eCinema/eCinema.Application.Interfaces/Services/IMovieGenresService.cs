using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IMovieGenresService : IBaseService<int,MovieGenreDto,MovieGenreUpsertDto,BaseSearchObject>
    {
    }
}
