using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class CategoryDto : BaseDto
    {
        public string Name { get; set; } = null!;
        public bool IsDisplayed { get; set; }
        public ICollection<MovieCategoryDto> MovieCategories { get; set; } = null!;
    }
}
