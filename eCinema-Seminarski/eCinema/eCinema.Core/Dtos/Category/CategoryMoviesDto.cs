
namespace eCinema.Core.Dtos.Category
{
    public class CategoryMoviesDto : BaseDto
    {
        public CategoryDto Category { get; set; } = null!;
        public IEnumerable<MovieDto> Movies { get; set; } = null!;
    }
}
