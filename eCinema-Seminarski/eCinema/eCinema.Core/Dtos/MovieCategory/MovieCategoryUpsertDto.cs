namespace eCinema.Core
{
    public class MovieCategoryUpsertDto : BaseUpsertDto
    {
        public int MovieId { get; set; }
        public int CategoryId { get; set; }
    }
}
