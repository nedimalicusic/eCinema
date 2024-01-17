using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class NotificationsService : BaseService<Notification, NotificationDto, NotificationUpsertDto, BaseSearchObject, INotificationsRepository>, INotificationsService
    {
        public NotificationsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<NotificationUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task<IEnumerable<NotificationDto>> GetByUserId(int userId, CancellationToken cancellationToken)
        {
            var notifications = await CurrentRepository.GetByUserId(userId, cancellationToken);

            return Mapper.Map<IEnumerable<NotificationDto>>(notifications);
        }
    }
}
