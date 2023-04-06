namespace eCinema.Core
{
    public class Reservation : BaseEntity
    {
        public bool isActive { get; set; }
        public bool IsClosed { get; set; }

        public int ShowSeatId { get; set; }
        public ShowSeat ShowSeat { get; set; } = null!;

        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}
