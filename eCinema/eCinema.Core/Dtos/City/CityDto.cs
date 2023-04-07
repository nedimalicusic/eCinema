namespace eCinema.Core
{
    public class CityDto : BaseDto
    {
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;
        public bool IsActive { get; set; }

        public int CountryId { get; set; }
        public CountryDto Country { get; set; } = null!;
    }
}
