namespace eCinema.Core
{
    public class Language : BaseEntity
    {
        public string Name { get; set; } = null!;

        public ICollection<Movie> Movies { get; set; } = null!;
    }
}
