using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces.Services
{
    public interface ICategoryService : IBaseService<int,CategoryDto,CategoryUpsertDto, CategorySearchObject>
    {
    }
}
