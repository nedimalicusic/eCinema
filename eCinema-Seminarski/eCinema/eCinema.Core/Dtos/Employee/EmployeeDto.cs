namespace eCinema.Core
{
    public class EmployeeDto : BaseDto
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public bool isActive { get; set; }

        public int? ProfilePhotoId { get; set; }
        public PhotoDto? ProfilePhoto { get; set; }

        public int CinemaId { get; set; }
        public CinemaDto Cinema { get; set; } = null!;
    }
}
