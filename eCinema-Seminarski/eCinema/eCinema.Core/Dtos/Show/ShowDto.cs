using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class ShowDto : BaseDto
    {
        public DateTime StartsAt { get; set; }
        public DateTime EndsAt { get; set; }
        public double Price { get; set; }

        public int ShowTypeId { get; set; }
        public ShowType ShowType { get; set; } = null!;

        public int? RecurringShowId { get; set; }
        public ReccuringShows? ReccuringShow { get; set; }

        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;

        public int MovieId { get; set; }
        public Movie Movie { get; set; } = null!;
    }
}
