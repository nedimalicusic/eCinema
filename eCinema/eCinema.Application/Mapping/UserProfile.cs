using eCinema.Core;

namespace eCinema.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<UserDto, User>().ReverseMap();

            CreateMap<UserUpserDto, User>();
        }
    }
}
