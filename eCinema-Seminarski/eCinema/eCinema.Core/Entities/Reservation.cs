namespace eCinema.Core
{
    public class Reservation : BaseEntity
    {
        public bool isActive { get; set; }
        public bool isConfirm { get; set; } = false;

        public int ShowId { get; set; }
        public Show Show { get; set; } = null!;

        public int SeatId { get; set; }
        public Seat Seat { get; set; } = null!;

        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}
