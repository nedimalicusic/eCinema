using eCinema.Core;

namespace eCinema.Application
{
    public class NotificationProfile : BaseProfile
    {
        public NotificationProfile()
        {
            CreateMap<NotificationDto, Notification>().ReverseMap();

            CreateMap<NotificationUpsertDto, Notification>();
        }
    }
}
