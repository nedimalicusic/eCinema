namespace eCinema.Core
{
    public class Seat : BaseEntity
    {
        public string Row { get; set; } = null!;
        public int Column { get; set; }

        public bool isSelected { get; set; }
        public bool isReserved { get; set; }
        public bool Available { get; set; }

        public ICollection<Reservation> Reservations { get; set; } = null!;
    }
}
