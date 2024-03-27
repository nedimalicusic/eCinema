using eCinema.Core;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application.Interfaces
{
    public interface IUsersService : IBaseService<int,UserDto,UserUpsertDto, UserSearchObject>
    {
        Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
        Task ChangePassword(UserChangePasswordDto dto, CancellationToken cancellationToken);
    }
}
