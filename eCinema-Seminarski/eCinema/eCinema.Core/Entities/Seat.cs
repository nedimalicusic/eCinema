namespace eCinema.Core
{
    public class Seat : BaseEntity
    {
        public string Row { get; set; } = null!;
        public int Column { get; set; }

        public ICollection<Reservation> Reservations { get; set; } = null!;

    }
}
