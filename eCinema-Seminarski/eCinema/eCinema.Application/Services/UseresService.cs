using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Common.Service;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using eCinema.Application.Interfaces.Services;

namespace eCinema.Application
{
    public class UseresService : BaseService<User, UserDto, UserUpsertDto, UserSearchObject, IUsersRepository>, IUsersService
    {
        private readonly IRabbitMQProducer _rabbitMQProducer;
        private readonly ICryptoService _cryptoService;

        public UseresService(IRabbitMQProducer rabbitMQProducer, ICryptoService cryptoService, IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
            _rabbitMQProducer = rabbitMQProducer;
            _cryptoService = cryptoService;
        }

        public async Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            var user = await CurrentRepository.GetByEmailAsync(email, cancellationToken);
            return Mapper.Map<UserSensitiveDto>(user);
        }

        public override async Task<UserDto> AddAsync(UserUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<User>(dto);

            entity.PasswordSalt = _cryptoService.GenerateSalt();
            entity.PasswordHash = _cryptoService.GenerateHash(dto.Password!, entity.PasswordSalt);

            _rabbitMQProducer.SendMessage("Test rabbit message. Simualation send email for create user.");
            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<UserDto>(entity);
        }

        public async Task<List<UserForSelectionDto?>> GetUserForSelectionAsync(CancellationToken cancellationToken = default)
        {
            var users = await CurrentRepository.GetUsersForSelection(cancellationToken);

            return Mapper.Map<List<UserForSelectionDto?>>(users);
        }

        public override async Task<UserDto> UpdateAsync(UserUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var user = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);
            if (user == null)
                throw new UserNotFoundException();

            Mapper.Map(dto, user);

            if (!string.IsNullOrEmpty(dto.Password))
            {
                user.PasswordSalt = _cryptoService.GenerateSalt();
                user.PasswordHash = _cryptoService.GenerateHash(dto.Password, user.PasswordSalt);
            }

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<UserDto>(user);
        }

        public async Task ChangePassword(UserChangePasswordDto dto, CancellationToken cancellationToken)
        {
            var user = await CurrentRepository.GetByIdAsync(dto.Id, cancellationToken);

            if (user == null)
                throw new UserNotFoundException();

            if (!_cryptoService.Verify(user.PasswordHash, user.PasswordSalt, dto.Password))
                throw new UserWrongCredentialsException();

            user.PasswordSalt = _cryptoService.GenerateSalt();
            user.PasswordHash = _cryptoService.GenerateHash(dto.NewPassword, user.PasswordSalt);

            CurrentRepository.Update(user);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }

    }
}
