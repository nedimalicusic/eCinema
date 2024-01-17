namespace eCinema.Core
{
    public class Country : BaseEntity
    {
        public string Name { get; set; } = null!;
        public string Abbreviation { get; set; } = null!;
        public bool IsActive { get; set; }

        public ICollection<City> Cities { get; set; } = null!;
        public ICollection<Production> Productions { get; set; } = null!;

    }
}
