namespace eCinema.Core
{
    public class ProductionDto : BaseDto
    {
        public string Name { get; set; } = null!;

        public int CountryId { get; set; }
        public CountryDto Country { get; set; } = null!;
    }
}
