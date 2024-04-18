using eCinema.Core.Entities;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface ICategoryRepository : IBaseRepository<Category,int,CategorySearchObject>
    {
    }
}
