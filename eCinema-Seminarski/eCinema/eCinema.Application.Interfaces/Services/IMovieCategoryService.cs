using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces.Services
{
    public interface IMovieCategoryService : IBaseService<int,MovieCategoryDto,MovieCategoryUpsertDto,BaseSearchObject>
    {
    }
}
