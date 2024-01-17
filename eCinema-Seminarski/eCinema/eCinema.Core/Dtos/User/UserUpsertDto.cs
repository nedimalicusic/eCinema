namespace eCinema.Core
{
    public class UserUpsertDto : BaseUpsertDto
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Password { get; set; }
        public string PhoneNumber { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
        public DateTime? LastSignInAt { get; set; }
        public Role? Role { get; set; }
        public bool? IsVerified { get; set; }
        public bool? IsActive { get; set; }

        public int ProfilePhotoId { get; set; }
    }
}
