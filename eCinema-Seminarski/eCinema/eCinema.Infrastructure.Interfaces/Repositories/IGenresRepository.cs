using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IGenresRepository : IBaseRepository<Genre,int, GenreSearchObject>
    {
    }
}
