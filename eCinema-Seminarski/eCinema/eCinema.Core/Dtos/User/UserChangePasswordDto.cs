
namespace eCinema.Core
{
    public class UserChangePasswordDto 
    {
        public int Id { get; set; }
        public string Password { get; set; } = null!;
        public string NewPassword { get; set; } = null!;
        public string ConfirmNewPassword { get; set; } = null!;
    }
}
