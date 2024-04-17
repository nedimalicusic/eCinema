using eCinema.Core;
using eCinema.Core.Entities;

namespace eCinema.Infrastructure.Interfaces.Repositories
{
    public interface IMovieCategoryRepository : IBaseRepository<MovieCategory,int,BaseSearchObject>
    {
        void DetachEntity(MovieCategory entity);
    }
}
