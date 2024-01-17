using eCinema.Application;
using eCinema.Core;

namespace eCinema.Api.Mapping
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<AccessSignUpModel, UserUpsertDto>()
                .ForMember(a => a.IsActive, o => o.MapFrom(s => true))
                .ForMember(a => a.IsVerified, o => o.MapFrom(s => true))
                .ForMember(a => a.Role, o => o.MapFrom(s => Role.User));

            CreateMap<UserUpsertModel, UserUpsertDto>()
            .ForMember(a => a.ProfilePhotoId, o => o.Ignore()
            );
        }
    }
}
