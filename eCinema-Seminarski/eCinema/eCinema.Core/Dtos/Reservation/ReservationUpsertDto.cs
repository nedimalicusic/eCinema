namespace eCinema.Core
{
    public class ReservationUpsertDto : BaseUpsertDto
    {
        public bool isActive { get; set; }
        public bool isConfirm { get; set; } = false;

        public int ShowId { get; set; }
        public int SeatId { get; set; }
        public int UserId { get; set; }
    }
}
