using eCinema.Core;
using eCinema.Core.Dtos.Category;
using eCinema.Infrastructure;

namespace eCinema.Application.Interfaces
{
    public interface IMoviesService : IBaseService<int, MovieDto, MovieUpsertDto, MovieSearchObject>
    {
        Task<List<CategoryMoviesDto>> GetCategoryAndMovies(CancellationToken cancellationToken);
    }
}
