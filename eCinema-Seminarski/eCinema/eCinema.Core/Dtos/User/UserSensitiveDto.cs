namespace eCinema.Core
{
    public class UserSensitiveDto : UserDto
    {
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
    }
}
