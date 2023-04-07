namespace eCinema.Core
{
    public class CinemaDto : BaseDto
    {
        public string Name { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Email { get; set; } = null!;
        public int PhoneNumber { get; set; }
        public int NumberOfSeats { get; set; }

        public int CityId { get; set; }
        public CityDto City { get; set; } = null!;
    }
}
