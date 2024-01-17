namespace eCinema.Core
{
    public class CityUpsertDto : BaseUpsertDto
    {
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;
        public bool IsActive { get; set; }

        public int CountryId { get; set; }
    }
}
