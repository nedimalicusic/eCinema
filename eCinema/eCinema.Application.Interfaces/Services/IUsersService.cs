using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IUsersService : IBaseService<int,UserDto,UserUpsertDto,BaseSearchObject>
    {
        Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
    }
}
