using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Api.Controllers
{
    public class UserController : BaseCrudController<UserDto, UserUpserDto, BaseSearchObject, IUsersService>
    {
        public UserController(IUsersService service, ILogger<BaseController> logger) : base(service, logger)
        {
        }
    }
}
