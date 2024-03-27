using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces.Services
{
    public interface ICategoryService : IBaseService<int,CategoryDto,CategoryUpsertDto,BaseSearchObject>
    {
    }
}
