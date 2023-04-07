using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application.Interfaces
{
    public interface IUsersService : IBaseService<int,UserDto,UserUpserDto,BaseSearchObject>
    {
    }
}
