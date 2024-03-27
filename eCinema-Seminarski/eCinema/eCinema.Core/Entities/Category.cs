
namespace eCinema.Core.Entities
{
    public class Category : BaseEntity
    {
        public string Name { get; set; } = null!;
        public bool IsDisplayed { get; set; }
        public ICollection<MovieCategory> MovieCategories { get; set; } = null!;
    }
}
