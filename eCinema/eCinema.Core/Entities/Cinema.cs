namespace eCinema.Core
{
    public class Cinema : BaseEntity
    {
        public string Name { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Email { get; set; } = null!;
        public int PhoneNumber { get; set; }
        public int NumberOfSeats { get; set; }

        public int CityId { get; set; }
        public City City { get; set; } = null!;

        public ICollection<Employee> Employees { get; set; } = null!;
        public ICollection<Show> Shows { get; set; } = null!;
    }
}
