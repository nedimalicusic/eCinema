using eCinema.Core.Entities;

namespace eCinema.Infrastructure.Interfaces.Repositories
{
    public interface ICategoryRepository : IBaseRepository<Category,int,BaseSearchObject>
    {
    }
}
