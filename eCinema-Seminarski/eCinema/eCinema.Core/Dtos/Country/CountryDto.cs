namespace eCinema.Core
{
    public class CountryDto : BaseDto
    {
        public string Name { get; set; } = null!;
        public string Abbreviation { get; set; } = null!;
        public bool IsActive { get; set; }
    }
}
