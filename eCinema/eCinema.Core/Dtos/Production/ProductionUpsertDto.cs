namespace eCinema.Core
{
    public class ProductionUpsertDto : BaseUpsertDto
    {
        public string Name { get; set; } = null!;
        public int CountryId { get; set; }
    }
}
