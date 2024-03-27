namespace eCinema.Core
{
    public class CategoryUpsertDto : BaseUpsertDto
    {
        public string Name { get; set; } = null!;
        public bool IsDisplayed { get; set; }
    }
}
