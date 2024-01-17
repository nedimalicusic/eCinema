using eCinema.Core;

namespace eCinema.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<UserDto, User>().ReverseMap();

            CreateMap<User, UserSensitiveDto>();



            CreateMap<UserUpsertDto, User>()
                .ForMember(u => u.ProfilePhoto, o => o.Ignore());
        }
    }
}
