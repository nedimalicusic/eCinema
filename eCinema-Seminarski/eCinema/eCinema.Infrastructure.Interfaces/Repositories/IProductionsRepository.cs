using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Infrastructure.Interfaces
{
    public interface IProductionsRepository : IBaseRepository<Production,int, ProductionSearchObject>
    {
    }
}
