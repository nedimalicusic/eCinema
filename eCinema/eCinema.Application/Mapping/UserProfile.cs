using eCinema.Core;

namespace eCinema.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<UserDto, User>().ReverseMap();

            CreateMap<User, UserSensitiveDto>();

            CreateMap<UserDto, UserUpsertDto>();

            CreateMap<UserUpsertDto, User>()
                .ForMember(u => u.ProfilePhoto, o => o.Ignore())
                .ForMember(u => u.IsVerified, o => o.MapFrom(_ => true))
                .ForMember(u => u.IsActive, o => o.MapFrom(_ => true)); 
        }
    }
}
