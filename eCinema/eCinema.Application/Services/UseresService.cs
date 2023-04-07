using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class UseresService : BaseService<User, UserDto, UserUpserDto, BaseSearchObject, IUsersRepository>, IUsersService
    {
        public UseresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpserDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
