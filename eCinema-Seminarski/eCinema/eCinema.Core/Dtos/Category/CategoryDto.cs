namespace eCinema.Core
{
    public class CategoryDto : BaseDto
    {
        public string Name { get; set; } = null!;
        public bool IsDisplayed { get; set; }
    }
}
