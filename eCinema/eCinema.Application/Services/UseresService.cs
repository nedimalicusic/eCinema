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

        public async Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            var user = await CurrentRepository.GetByEmailAsync(email, cancellationToken);
            return Mapper.Map<UserSensitiveDto>(user);
        }
    }
}
