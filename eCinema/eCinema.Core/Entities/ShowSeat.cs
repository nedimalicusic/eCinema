namespace eCinema.Core
{
    public class ShowSeat :BaseEntity
    {
        public bool isSelected { get; set; }
        public bool isReserved { get; set; }
        public bool isAvailable { get; set; }

        public int ShowId { get; set; }
        public Show Show { get; set; } = null!;

        public int SeatId { get; set; }
        public Seat Seat { get; set; } = null!;

        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
