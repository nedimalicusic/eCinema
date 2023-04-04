namespace eCinema.Core
{
    public class User : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public Gender Gender { get; set; }
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public Role Role { get; set; }
        public DateTime? LastSignInAt { get; set; }
        public bool IsVerified { get; set; }
        public bool IsActive { get; set; }

        public int? ProfilePhotoId { get; set; }
        public Photo? ProfilePhoto { get; set; } = null!;

        public int CityId { get; set; }
        public City City { get; set; } = null!;

        public ICollection<Reservation> Reservations { get; set; } = null!;
        public ICollection<Notification> Notifications { get; set; } = null!;
    }
}
