
namespace eCinema.Core
{
    public class ShowUpsertDto : BaseUpsertDto
    {
        public DateTime StartsAt { get; set; }
        public DateTime EndsAt { get; set; }
        public double Price { get; set; }

        public int ShowTypeId { get; set; }
        public int? RecurringShowId { get; set; }
        public int CinemaId { get; set; }
        public int MovieId { get; set; }
    }
}
