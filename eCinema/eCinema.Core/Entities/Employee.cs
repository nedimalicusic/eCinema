namespace eCinema.Core
{
    public class Employee : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public bool isActive { get; set; }

        public int? ProfilePhotoId { get; set; }
        public Photo? ProfilePhoto { get; set; }

        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
