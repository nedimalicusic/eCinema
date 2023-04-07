namespace eCinema.Core
{
    public class ReservationUpsertDto : BaseUpsertDto
    {
        public bool isActive { get; set; }
        public bool IsClosed { get; set; }

        public int ShowSeatId { get; set; }
        public int UserId { get; set; }
    }
}
