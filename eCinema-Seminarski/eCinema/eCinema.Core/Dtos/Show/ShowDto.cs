using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class ShowDto : BaseDto
    {
        public DateTime StartsAt { get; set; }
        public DateTime EndsAt { get; set; }
        public double Price { get; set; }

        public int ShowTypeId { get; set; }
        public ShowTypeDto ShowType { get; set; } = null!;

        public int? RecurringShowId { get; set; }
        public ReccuringShowDto? ReccuringShow { get; set; }

        public int CinemaId { get; set; }
        public CinemaDto Cinema { get; set; } = null!;

        public int MovieId { get; set; }
        public MovieDto Movie { get; set; } = null!;
        public ICollection<ReservationDto> Reservations { get; set; } = null!;
    }
}
