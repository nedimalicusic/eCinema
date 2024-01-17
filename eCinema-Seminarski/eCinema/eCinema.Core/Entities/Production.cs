namespace eCinema.Core
{
    public class Production : BaseEntity
    {
        public string Name { get; set; } = null!;

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public ICollection<Movie> Movies { get; set; } = null!;
    }
}
