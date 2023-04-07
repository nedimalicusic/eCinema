namespace eCinema.Core
{
    public class CountryUpsertDto : BaseUpsertDto
    {
        public string Name { get; set; } = null!;
        public string Abbreviation { get; set; } = null!;
        public bool IsActive { get; set; }
    }
}
